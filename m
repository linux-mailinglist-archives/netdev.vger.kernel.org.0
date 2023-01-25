Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6742167B903
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbjAYSIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjAYSIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:08:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C432B2AE;
        Wed, 25 Jan 2023 10:08:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95EB961576;
        Wed, 25 Jan 2023 18:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E4BC433EF;
        Wed, 25 Jan 2023 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674670094;
        bh=2l9kIBgtWMv+fgeU0j6LXlSvk4M0hVcKWIzp1wnUWRk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=El3NnLWpuV5xrvPTYs9ygsU3Jv+3o8TfK9M27uSqfUAj3LQGtSfBaWko3aTHmQ4px
         k8JWG8CgXZixj460XNna396WgsmVS+jEpohwNFYFKnDVKpPlEZ1e7GKkcfKKlSwnHv
         NyzZ4XnaWWbCvQXYKjLIBe527MQtaSwv5dzAQDk427FVP1+JEptRaezeGVhthSUt3g
         6T3Pf5rTq0/9owRbCZAPuFpxqEyOAw9OKm68l15uBPRUuhXQfJk2//XYs2x/5qXxgZ
         ZGaAexy2ZEhv86SvQMX3TptsZVZazvOTnA9s1JdzGycV2ZZbu14oTcR7Tf0+WjMA83
         ghZm/sQ/QK4WA==
Date:   Wed, 25 Jan 2023 10:08:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, ilpo.jarvinen@linux.intel.com,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 5/5] net: wwan: t7xx: Devlink documentation
Message-ID: <20230125100812.026c0a1e@kernel.org>
In-Reply-To: <c9f0eca7-99e8-62a5-9790-1230c43e1817@linux.intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
        <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
        <20230124205142.772ac24c@kernel.org>
        <c9f0eca7-99e8-62a5-9790-1230c43e1817@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 16:03:37 +0530 Kumar, M Chetan wrote:
> > I don't know what fastboot is, and reading this doc I see it used in
> > three forms:
> >   - fastboot protocol
> >   - fastboot mode
> >   - fastboot command & response  
> 
> The fastboot is sort of a tool. It implements the protocol for 
> programming the device flash or getting device information. The device 
> implements the fastboot commands and host issue those commands for 
> programming the firmware to device flash or to obtain device 
> information. Inorder to execute those commands, first the device needs 
> to be put into fastboot mode.
> 
> More details on fastboot can be found in links [1].
> 
> > In the end - I have no idea what the devlink param you're adding does.  
> 
> "fastboot" devlink param is used to put the device into fastboot mode
> to program firmware to device flash or to obtain device information.
> 
> 
> [1]
> https://en.wikipedia.org/wiki/Fastboot
> https://android.googlesource.com/platform/system/core/+/refs/heads/master/fastboot/README.md

As Ilpo mentions, please add this info into the doc, including 
the links.

The most confusing part is that "fastboot" sounds like it's going 
to boot fast, while IIUC the behavior is the opposite - it's not going
to boot at all and just expose an interface to load the FW, is that
right?

Please also clarify what the normal operation for the device is.
In what scenarios does the fastboot mode get used?

And just to double confirm - that the FW loaded in fastboot mode is
persistently stored on the device, and will be used after power cycle.
Rather than it being an upload into RAM.
