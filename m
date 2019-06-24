Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4E51A72
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbfFXSYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:24:09 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39980 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfFXSYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 14:24:09 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so23102631eds.7
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 11:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=L6TFZDLgiQ+GTxHGzKJSP/a/EPP8OeYxDWXJtC90/vk=;
        b=QOYP0dEYJNuJVjmOO5FOwhk/bvrDd/eDWemmP8BQVhVw2qfeZDi7dGb/iwjxmoGK88
         eyd44onNdJGmoMUHCQlT420IRo/+Lp2W8IvMWXSLI5bkLbbwp4eHpdVr0adWksL9dJC2
         wJZj0dPuPJNa8nx02cSPdE8WgqhUFKnIeSS6ZEnmIh8MsEhJU7U07ttZmd9lOBpf0vD0
         aSp9enDkOFVpEBzR9w6LKIu7ggmd+vDb2ISUULAOJfCc47h0SXLSWfV2bzntrYn0hmtg
         ec+de8Mk6aPceNfC/SXNQMic0LJUUtPwXTDzb1ZCZTHno+hlYQ6lk1Xv+jjDZVE47HCB
         lUTA==
X-Gm-Message-State: APjAAAU9HQ+8acwQ16Xiqul3e6sYP2QbmAdB41wBrr57E7VvNUaYAHuJ
        fDzgYc5cQLReJcuVlzRSpsqeJQ==
X-Google-Smtp-Source: APXvYqw0/qptTDpR+PkXz+OAgEtaICXNWggRvXA1K541s83SDiI6gaZfx/i7cLDdyRobH/HX+pwT5Q==
X-Received: by 2002:a17:906:304d:: with SMTP id d13mr4843137ejd.99.1561400647790;
        Mon, 24 Jun 2019 11:24:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f10sm4191856eda.41.2019.06.24.11.24.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 11:24:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1DE41804B5; Mon, 24 Jun 2019 20:24:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] samples: bpf: make the use of xdp samples consistent
In-Reply-To: <20190624112009.20048-1-danieltimlee@gmail.com>
References: <20190624112009.20048-1-danieltimlee@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 Jun 2019 14:24:06 -0400
Message-ID: <871rzi4zax.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Daniel T. Lee" <danieltimlee@gmail.com> writes:

> Currently, each xdp samples are inconsistent in the use.
> Most of the samples fetch the interface with it's name.
> (ex. xdp1, xdp2skb, xdp_redirect, xdp_sample_pkts, etc.)

The xdp_redirect and xdp_redirect_map also only accept ifindexes, not
interface names. Care to fix those while you're at it? :)

-Toke
