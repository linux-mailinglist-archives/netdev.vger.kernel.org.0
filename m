Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A9C4D02B2
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbiCGP0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiCGP0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:26:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A13B90CD9;
        Mon,  7 Mar 2022 07:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68188B815E2;
        Mon,  7 Mar 2022 15:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B884C340EB;
        Mon,  7 Mar 2022 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646666733;
        bh=BNQWhI2ZZ59vaTrOPgc5ts1aXPYVmELNBcWywiAR6ug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SnAbyCdbk1hQur6TFu02eVVDcJCVsjO+0vHlxOYZuK08YK0WDdtrP0AY8VMxqnRQx
         oRs4ngY50FAS0myedFBp7iw5T0zkCCKtxsg41jU5JIOIhChW2pTYVEJ7t7PYYAMQMF
         j6zFXYzafHCzaTD6CLd/Tf62jEwuUnbmS8eWr91M=
Date:   Mon, 7 Mar 2022 16:25:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Hou Tao <houtao1@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Message-ID: <YiYj6t7uhxZ5cw2t@kroah.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <CA+G9fYtXE1TvxtXZPw++ZkGAUZ4f1rD1tBkMsDb33jsm-C1OZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtXE1TvxtXZPw++ZkGAUZ4f1rD1tBkMsDb33jsm-C1OZw@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:30:18PM +0530, Naresh Kamboju wrote:
> On Mon, 7 Mar 2022 at 15:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.27 release.
> > There are 262 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.27-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Following build errors/warnings noticed on arm64.
> 
> 
> arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
> arch/arm64/net/bpf_jit_comp.c:791:21: error: implicit declaration of
> function 'bpf_pseudo_func' [-Werror=implicit-function-declaration]
>   791 |                 if (bpf_pseudo_func(insn))
>       |                     ^~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors

Found this one, now dropped.

