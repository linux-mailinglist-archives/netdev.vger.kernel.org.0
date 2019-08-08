Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CCD86A7A
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404550AbfHHTRy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 15:17:54 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44414 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404376AbfHHTRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:17:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so91994624edr.11
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:17:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=m39lMJUpY7a4WeYD+9s2JE3G1NI0nVGaOgAWMiqLeEo=;
        b=ZYuAf8hKn/5znLWkWoES3CgLfjVSMC2B+13FWRHpw1PJAYQybaEQLNDLbbnui03xq5
         WdxedN128vJRe4T5rTOb1iEYVZixdJXvoNM+VMlwS/dszkNbKeJYIGtY6UlcVxIdWHf8
         /2QcC/B0eRIs5hGrQWE+sqhEIzr7IiS99AXt/oZkXMhmthlE1SXiwhzeSnrOtqJCAaNI
         9o+qwZO0sjsnhc+1owjWZC+/rma7qBPBvTq98ZxOQOJhK8faVy8v9zvoz7lCX5rnqsBp
         tqCUoVMI5bX1P7rzHwA2bKuUR13PpbTXYMJGNT4PF/1nATjH3tKREsir6O3VEKV8myPy
         ewIw==
X-Gm-Message-State: APjAAAW5RnA5eq91o6K8Ok9Q8ByDQuzZ2Vd//OOEw9WNaradSRrTv9iu
        EHyBiSFc6zsg7Cr7hmzgblhYRg==
X-Google-Smtp-Source: APXvYqzkFB5S67qvh+YV1+UooGRO3Bcjou2hQpFevVmSG5wM9OV/QlIwEj36a4o8pUFtKhPYyw4fFw==
X-Received: by 2002:a17:906:3715:: with SMTP id d21mr1136378ejc.104.1565291872250;
        Thu, 08 Aug 2019 12:17:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y11sm15612862ejb.54.2019.08.08.12.17.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 12:17:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 392341804B2; Thu,  8 Aug 2019 21:17:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com, ys114321@gmail.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [bpf-next v3 PATCH 3/3] samples/bpf: xdp_fwd explain bpf_fib_lookup return codes
In-Reply-To: <156528106777.22124.12162740342925045912.stgit@firesoul>
References: <156528102557.22124.261409336813472418.stgit@firesoul> <156528106777.22124.12162740342925045912.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Aug 2019 21:17:51 +0200
Message-ID: <87sgqbsbz4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> Make it clear that this XDP program depend on the network
> stack to do the ARP resolution.  This is connected with the
> BPF_FIB_LKUP_RET_NO_NEIGH return code from bpf_fib_lookup().
>
> Another common mistake (seen via XDP-tutorial) is that users
> don't realize that sysctl net.ipv{4,6}.conf.all.forwarding
> setting is honored by bpf_fib_lookup.
>
> Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
