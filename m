Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31D4DA334
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344185AbiCOTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiCOTV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:21:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8484639BA6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 330F4B81896
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02A40C340EE;
        Tue, 15 Mar 2022 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647372014;
        bh=/0C3uR20qpps6JUzDKnGgXL+hG2hu6XcOPCApxgpmcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IXI/YhoU4vh7SHU02RGzu6dx+LIMptAzosmusoP49OLPpKdDF8FogTtN2i6y7a6Ok
         gWkUeXdIavZY4mrkJc+jokqYKZgIHhE8j0VN5IyMdBWlT3L5xb8GQ5ADUQlSqJnVPX
         Mcqq+hJGy3oc4CZnUVONrGqZmqbuWBAqaPNn20dXwPs7EtAEFt4W5kbvZ7vJsRgtcy
         IA8NBciiJ+CnSx+KnZdZGXFTG12OjqMWY94TYK9EMlU2Y/tMc+xSzP/XbsmXLud/Za
         0H/mAPZmcb3DENHAWVD3iBsaLjVzLwyCl65LauHOEqzjgZXCkUpAqqyHp24tXeOVXq
         gm4ZdYdNn4/bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E290DE6BBCA;
        Tue, 15 Mar 2022 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/11][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-03-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164737201392.25309.7603305703350572277.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 19:20:13 +0000
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 14 Mar 2022 18:11:44 -0700 you wrote:
> Jacob Keller says:
> 
> The ice_virtchnl_pf.c file has become a single place for a lot of
> virtualization functionality. This includes most of the virtchnl message
> handling, integration with kernel hooks like the .ndo operations, reset
> logic, and more.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/11] ice: rename ice_sriov.c to ice_vf_mbx.c
    https://git.kernel.org/netdev/net-next/c/d775155a8661
  - [net-next,v2,02/11] ice: rename ice_virtchnl_pf.c to ice_sriov.c
    https://git.kernel.org/netdev/net-next/c/0deb0bf70c3f
  - [net-next,v2,03/11] ice: remove circular header dependencies on ice.h
    https://git.kernel.org/netdev/net-next/c/649c87c6ff52
  - [net-next,v2,04/11] ice: convert vf->vc_ops to a const pointer
    https://git.kernel.org/netdev/net-next/c/a7e117109a25
  - [net-next,v2,05/11] ice: remove unused definitions from ice_sriov.h
    https://git.kernel.org/netdev/net-next/c/00a57e2959bd
  - [net-next,v2,06/11] ice: rename ICE_MAX_VF_COUNT to avoid confusion
    https://git.kernel.org/netdev/net-next/c/dc36796eadca
  - [net-next,v2,07/11] ice: refactor spoofchk control code in ice_sriov.c
    https://git.kernel.org/netdev/net-next/c/a8ea6d86bd98
  - [net-next,v2,08/11] ice: move ice_set_vf_port_vlan near other .ndo ops
    https://git.kernel.org/netdev/net-next/c/346f7aa3c773
  - [net-next,v2,09/11] ice: cleanup error logging for ice_ena_vfs
    https://git.kernel.org/netdev/net-next/c/94ab2488d467
  - [net-next,v2,10/11] ice: log an error message when eswitch fails to configure
    https://git.kernel.org/netdev/net-next/c/2b36944810b2
  - [net-next,v2,11/11] ice: use ice_is_vf_trusted helper function
    https://git.kernel.org/netdev/net-next/c/1261691dda6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


