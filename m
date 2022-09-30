Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A2B5F02E4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiI3Ck0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiI3CkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF729EEB54
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E14362221
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6250C433B5;
        Fri, 30 Sep 2022 02:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505621;
        bh=CRweTz1lh/mZw0CBQQ0lSqtomCv3AH5wDu+/mcW5X/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MNvmBpLKV2PZgQxDLVCyxKI7Gl1AZKHl+2vv2PBCym8HPpjzHJbEFUZvbW8lxGARV
         fF2zUBWwq9UDtjikYp4qZHU8fh27sspHASwg1WiUpnV4LdGG2T72h/WamaVui+QspV
         8TrBvLbkED6lO8F3dv0hcGm0uDn0Ih7NUV8H5oYevI32esiylUuh8f8VNWeJTfxNVX
         Np5XtODNrdgopIgjxYyqijFLTHgcjWSCJRmt4o9zviUjvo6gF+/hON2apcoF/+vXJ0
         gzWcBo7S/kqNa0n86SGsbMkhK5od7PO+1juxWcLZYN5QDvEacnKDpp9O5JVfYOw6nZ
         Kdpnf4xHdV04A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2196C395DA;
        Fri, 30 Sep 2022 02:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates
 2022-09-28 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450562179.6749.646489872907469037.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:40:21 +0000
References: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 28 Sep 2022 13:32:14 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Arkadiusz implements a single pin initialization function, checking feature
> bits, instead of having separate device functions and updates sub-device
> IDs for recognizing E810T devices.
> 
> Martyna adds support for switchdev filters on VLAN priority field.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ice: Merge pin initialization of E810 and E810T adapters
    https://git.kernel.org/netdev/net-next/c/43c4958a3ddb
  - [net-next,2/3] ice: support features on new E810T variants
    https://git.kernel.org/netdev/net-next/c/793189a2fc69
  - [net-next,3/3] ice: Add support for VLAN priority filters in switchdev
    https://git.kernel.org/netdev/net-next/c/34800178b302

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


