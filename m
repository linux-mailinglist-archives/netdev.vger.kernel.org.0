Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276505EDE62
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiI1OE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiI1OE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF07C77B;
        Wed, 28 Sep 2022 07:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4C961EB0;
        Wed, 28 Sep 2022 14:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F13C433D6;
        Wed, 28 Sep 2022 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664373863;
        bh=eGsDXMtLRzTOXZ9qGIM2z2RwI0km/E3ySdsgOm3wVCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bp5QH/+e3R/xu5ro+6KrGaH/s19oKhKmoF8XDk75ck6tI8f5ak9nKFJrgekgHxDPz
         jSsLbvD81N1OUnnOZ3hbkDQ0OwaFhwkvOBX6vVV3gDEK58zEN/Mhww0jkQZMXKjiLa
         7RBWKqIM8gT2LB7ampbVNhbHK+8DRJurMKdsSooa+7ofdE4896u6ftgCP0Syw+LgFP
         ROKY9TLk3tHyoSNs2nUd34nMkfzHDIFoT+XzABtHdSIlrnmoDO9oK/sCugaqmECgwX
         +iSjcECXlAh5ZcRGINTN5eVROIraBYudoI2OaeNOAUNTY0RP/347CSTFCt9FihOgd5
         M4zFpaduNyqag==
Date:   Wed, 28 Sep 2022 07:04:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, Alex Elder <elder@linaro.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] net: ipa: generalized register
 definitions
Message-ID: <20220928070421.12b7021a@kernel.org>
In-Reply-To: <166433041840.32421.1858136173918846349.git-patchwork-notify@kernel.org>
References: <20220926220931.3261749-1-elder@linaro.org>
        <166433041840.32421.1858136173918846349.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 02:00:18 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Mon, 26 Sep 2022 17:09:16 -0500 you wrote:
> > This series is quite a bit bigger than what I normally like to send,
> > and I apologize for that.  I would like it to get incorporated in
> > its entirety this week if possible, and splitting up the series
> > carries a small risk that wouldn't happen.
> > 
> > Each IPA register has a defined offset, and in most cases, a set
> > of masks that define the width and position of fields within the
> > register.  Most registers currently use the same offset for all
> > versions of IPA.  Usually fields within registers are also the same
> > across many versions.  Offsets and fields like this are defined
> > using preprocessor constants.
> > 
> > [...]  
> 
> Here is the summary with links:
>   - [net-next,01/15] net: ipa: introduce IPA register IDs
>     https://git.kernel.org/netdev/net-next/c/98e2dd71a826
>   - [net-next,02/15] net: ipa: use IPA register IDs to determine offsets
>     https://git.kernel.org/netdev/net-next/c/6bfb753850d3
>   - [net-next,03/15] net: ipa: add per-version IPA register definition files
>     https://git.kernel.org/netdev/net-next/c/07f120bcf76b
>   - [net-next,04/15] net: ipa: use ipa_reg[] array for register offsets
>     https://git.kernel.org/netdev/net-next/c/82a06807453a
>   - [net-next,05/15] net: ipa: introduce ipa_reg()
>     (no matching commit)
>   - [net-next,06/15] net: ipa: introduce ipa_reg field masks
>     https://git.kernel.org/netdev/net-next/c/a5ad8956f97a
>   - [net-next,07/15] net: ipa: define COMP_CFG IPA register fields
>     https://git.kernel.org/netdev/net-next/c/12c7ea7dfd2c
>   - [net-next,08/15] net: ipa: define CLKON_CFG and ROUTE IPA register fields
>     (no matching commit)
>   - [net-next,09/15] net: ipa: define some more IPA register fields
>     (no matching commit)
>   - [net-next,10/15] net: ipa: define more IPA register fields
>     (no matching commit)
>   - [net-next,11/15] net: ipa: define even more IPA register fields
>     (no matching commit)
>   - [net-next,12/15] net: ipa: define resource group/type IPA register fields
>     (no matching commit)
>   - [net-next,13/15] net: ipa: define some IPA endpoint register fields
>     (no matching commit)
>   - [net-next,14/15] net: ipa: define more IPA endpoint register fields
>     (no matching commit)
>   - [net-next,15/15] net: ipa: define remaining IPA register fields
>     (no matching commit)
> 
> You are awesome, thank you!

Hi Konstantin,

did anything change in the pw-bot in the last couple of weeks?

I didn't touch these patches and yet half got missed.
Do you recommend we slap a Link on all patches? Currently I only 
add it to the cover letter / merge commit.
