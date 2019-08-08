Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B952C86A76
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404582AbfHHTRa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 15:17:30 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45158 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404306AbfHHTRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:17:30 -0400
Received: by mail-ed1-f67.google.com with SMTP id x19so86111667eda.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=V5DSNxAKSaNIHwuxL6S+WWvWTN6sDI7/E23laVieiPA=;
        b=h27ZilzkFuiZW9oM14ASH4Soqf0W0dWod5De3CkZJqf2S71rE0biyOwvT/PMNOuW6E
         8WGrxsBc9XIGIWiGzPtWwMT4yAlMRlUSvbcm254uEi57d/8oyYftxRwEeN6QASef8/ds
         aXgq8OCywZbQUZYp6w4dgGu1z11pzcNw9NKUl6Ydn5B7GzvRzO3dsAMJnUYMNbAxDrst
         D/Aisuv1t7HtNsADjOLPzkkiGAixTn1riCll0XAIYH2Mp87INXG1dteBU2tUc2RtcWdP
         2ovpzk2SnivZ8h9d7q0qZRj9sEIF2834jaCDIxb3rmWih9P3CKcKPMDjIRoMmbDFYkeM
         Wyvg==
X-Gm-Message-State: APjAAAWFmmeOsQpiIbxDaIvFGQpWtB8HXwBBx7HHKnNE90G3sd/Q9YRp
        Z3p8v8GGdy9YZsj3cDb0cRpTxw==
X-Google-Smtp-Source: APXvYqyDCIFaf0OJG/Ksyegl29j9+eGXPHRpO1jSrP6/8KmqKxjQFrBOEcbHRgHtAxKfOtZ7Dt0CVQ==
X-Received: by 2002:a17:906:1599:: with SMTP id k25mr14648529ejd.281.1565291848628;
        Thu, 08 Aug 2019 12:17:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e14sm3440475ejj.69.2019.08.08.12.17.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 12:17:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8A6C91804B2; Thu,  8 Aug 2019 21:17:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com, ys114321@gmail.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [bpf-next v3 PATCH 2/3] samples/bpf: make xdp_fwd more practically usable via devmap lookup
In-Reply-To: <156528106270.22124.2563148023961869582.stgit@firesoul>
References: <156528102557.22124.261409336813472418.stgit@firesoul> <156528106270.22124.2563148023961869582.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Aug 2019 21:17:27 +0200
Message-ID: <87v9v7sbzs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> This address the TODO in samples/bpf/xdp_fwd_kern.c, which points out
> that the chosen egress index should be checked for existence in the
> devmap. This can now be done via taking advantage of Toke's work in
> commit 0cdbb4b09a06 ("devmap: Allow map lookups from eBPF").
>
> This change makes xdp_fwd more practically usable, as this allows for
> a mixed environment, where IP-forwarding fallback to network stack, if
> the egress device isn't configured to use XDP.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
