Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5267A9B9
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 05:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjAYEvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 23:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjAYEvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 23:51:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868F641B52;
        Tue, 24 Jan 2023 20:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E865D6143D;
        Wed, 25 Jan 2023 04:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D314C433D2;
        Wed, 25 Jan 2023 04:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674622304;
        bh=+bUBPnxd3fQuxYwejKIWgFqvkNH0x+67EyHYkT60dDY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InnR8dyWzT3i7mTN8xAgxgtxqlKvpdddpB4kL4GaWX+XkYSvIHxvt/7+XLXt33ToL
         P5LgSYgAU4jjHGbg2zj2ZS0rxLqXaTO3uC26niqOxlrKcitxbE/c47gdiqFQ+Vlpxk
         0fymu51CL6JLFn0ZyGkuO5ZKCoCHqwDn8y4rWZmABE+5XCmuh9fMJU40umapMbSKUT
         rUnjk7IiCv/2qL4IZ7G0ZRhtvfEFM+eMlHiuRkS67Q7xrNEIJUmr4B12WvEvsi4r/N
         IEaRQ/qQ8XCfAvmc26C2YmoRYNU3zcv8Ddwdw2oRP6yiDamWTdqkBb8o7wvnzn8Rqe
         9iVFrCwiZyewg==
Date:   Tue, 24 Jan 2023 20:51:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     m.chetan.kumar@linux.intel.com
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
Message-ID: <20230124205142.772ac24c@kernel.org>
In-Reply-To: <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
        <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
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

On Sat, 21 Jan 2023 19:03:58 +0530 m.chetan.kumar@linux.intel.com wrote:
> +In fastboot mode the userspace application uses these commands for obtaining the
> +current snapshot of second stage bootloader.

I don't know what fastboot is, and reading this doc I see it used in
three forms:
 - fastboot protocol
 - fastboot mode
 - fastboot command & response

In the end - I have no idea what the devlink param you're adding does.
