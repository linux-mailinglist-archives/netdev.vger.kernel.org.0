Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1254546FA
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhKQNPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhKQNPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:15:52 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADF9C061570;
        Wed, 17 Nov 2021 05:12:54 -0800 (PST)
Received: from localhost (unknown [151.68.164.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id EF7A666F1;
        Wed, 17 Nov 2021 13:12:51 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net EF7A666F1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1637154773; bh=RqOZ23BhV9RO5xXgnmEiwuWQ5dgdsqUxxSkLw87co+4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fSzeC/7YkG5oReHXjPQMMOcz6IPgAo298LUNP+2NVVrj4T84sWjraHJ+Y0Cs0HLRQ
         Pjjo1/20Zo0kfsdSFjDMh4BnwMUPeCdLG1wywJl0ZqlNAq85D4BVThIFby3fD+wbRj
         hKWUi3XVS2WA9MDMW/kroHha5/a4ysDR/b8/Qb0fSqzwB/lME+VYlGLUgtcgIit1pV
         Izr4YlWvBYKbmIBcQQmr4crURcJ7u8bzZ1ciiBmKIzAjurwcD7MNkXcblG0Cf99DHJ
         CBJ61e0Pd5/n40QAaGd15jwjKx15lBgVtbwqKJQ3FG4cIQNpO7RV7gHG5BPz/NrfSY
         8KA6EVFt3Lp3Q==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Address some bad references to Kernel docs
In-Reply-To: <cover.1637064577.git.mchehab+huawei@kernel.org>
References: <cover.1637064577.git.mchehab+huawei@kernel.org>
Date:   Wed, 17 Nov 2021 06:12:48 -0700
Message-ID: <87r1bfexin.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:

> Hi Jon,
>
> It follows 4 patches addressing some issues during the 5.16 Kernel development
> cycle that were sent to the MLs but weren't merged yet. 
>
> They apply cleanly on the top of 5.16-rc1.

I've applied the set, thanks.

jon
