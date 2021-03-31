Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257B3350443
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhCaQO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCaQOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:14:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17416102A;
        Wed, 31 Mar 2021 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617207244;
        bh=VgwWgmjg9khzPt0mP1Tojd5JQXXGG70rDa5nw1IZQnQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HalAKJD2CJZEeF30MW0WR05W+hTZFDzEVCSEXzL4OhU+v/mDuPK/+LeXZ+ITxe052
         nJCA/Qt6D4xMaMQsU8IpXcFRJRvFjosDtMnatRvn1TsQ/Nw7V9u2tGFQ8MCUYu7/1k
         +IodcWBdDvom3CjuGSlhLKngyeFHjwAnJqPVq8YVU4Nrm4JJ1QiJNkvUCIhO24gdvY
         fIHNxx89OwUuwSr+yJ+iGIeRM5VCPndF90RrnSNScnmMVWH5Fe/kwzwg1VQIQG3T53
         oGYxEQAMStzHWeN+N5W5v5K54WbFa9+jCzEBdR3k/oNIOwcWrBaad/1BEknkJ69Pkl
         N0Ty4VZYUErpA==
Received: by mail-lj1-f172.google.com with SMTP id u20so24475884lja.13;
        Wed, 31 Mar 2021 09:14:03 -0700 (PDT)
X-Gm-Message-State: AOAM530/rKUJc3Pq624N+n9RXB1clOne0IEBUG40zJw1NoasbkONZDjP
        F0wF2fjEkNlKbNxF8RxmWsSxyjBmorx4d3Me1N8=
X-Google-Smtp-Source: ABdhPJyZnC6MHHfZno0xYkcUUBI/HLYguDDsNuX/RpDHNIEmgvJHJ/TpM4Nd6uPzwi6dfPuRZaE3/K6pfOjR+l2rvXs=
X-Received: by 2002:a2e:809a:: with SMTP id i26mr2541423ljg.357.1617207242113;
 Wed, 31 Mar 2021 09:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210331075135.3850782-1-hefengqing@huawei.com>
In-Reply-To: <20210331075135.3850782-1-hefengqing@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 31 Mar 2021 09:13:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW60V4WL+SGhYeZTGmLhFvc_vywATB61BBAvc9R8m02pTg@mail.gmail.com>
Message-ID: <CAPhsuW60V4WL+SGhYeZTGmLhFvc_vywATB61BBAvc9R8m02pTg@mail.gmail.com>
Subject: Re: [Patch bpf-next] bpf: remove unused parameter from ___bpf_prog_run
To:     He Fengqing <hefengqing@huawei.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 12:14 AM He Fengqing <hefengqing@huawei.com> wrote:
>
> 'stack' parameter is not used in ___bpf_prog_run,
> the base address have been set to FP reg. So consequently remove it.
>
> Signed-off-by: He Fengqing <hefengqing@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>
