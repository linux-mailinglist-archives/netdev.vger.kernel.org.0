Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EA063C03A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiK2MkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiK2MkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3D949B55;
        Tue, 29 Nov 2022 04:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F433B815E9;
        Tue, 29 Nov 2022 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DC92C433D7;
        Tue, 29 Nov 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669725616;
        bh=81J56jrE5uFmZVK3lgDFKhSwPMsZg/s1PTlCp/aDuOE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rxn93+nJxss4G+zag68ef041D5LsJy2KY1eG8z/7R4GvbasaZMIYn8oRetJl+9J06
         2c1j1V1VajJLZqy8WGdqveoZS+IQgljlq4+dm0FbIWsIf2sHMeeBrMlG3oZ3H4tJq1
         tn1IAqhW6BmHCDw746CuREaCVCE/+ocJkfMxS/IwQr42ZT4O0gfq3q5mgcqXx/6W8n
         kYUl+6T2Qhc8SMgOTslxFSQpRluhTxzmV7jJTeYUw7uBcmWPzcXsuJu7i1AQL9lBGm
         ggk4FZvwhCIlmBmd7hUMxPHexRAwuam0qugQjapPEOM95poCWa/SvL6c80+uVwxsPJ
         0cWkugtHnS5NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79EB5E29F38;
        Tue, 29 Nov 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] Add support for lan966x IS2 VCAP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166972561648.15346.2560633115999516462.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 12:40:16 +0000
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 25 Nov 2022 10:50:01 +0100 you wrote:
> This provides initial support for lan966x for 'tc' traffic control
> userspace tool and its flower filter. For this is required to use
> the VCAP library.
> 
> Currently supported flower filter keys and actions are:
> - source and destination MAC address keys
> - trap action
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: microchip: vcap: Merge the vcap_ag_api_kunit.h into vcap_ag_api.h
    https://git.kernel.org/netdev/net-next/c/0a335db8c745
  - [net-next,2/9] net: microchip: vcap: Extend vcap with lan966x
    https://git.kernel.org/netdev/net-next/c/ee72d90b042e
  - [net-next,3/9] net: lan966x: Add initial VCAP
    https://git.kernel.org/netdev/net-next/c/b053122532d7
  - [net-next,4/9] net: lan966x: Add is2 vcap model to vcap API.
    https://git.kernel.org/netdev/net-next/c/39bedc169cff
  - [net-next,5/9] net: lan966x: add vcap registers
    https://git.kernel.org/netdev/net-next/c/f919ccc93dc6
  - [net-next,6/9] net: lan966x: add tc flower support for VCAP API
    https://git.kernel.org/netdev/net-next/c/3643abd6e6bc
  - [net-next,7/9] net: lan966x: add tc matchall goto action
    https://git.kernel.org/netdev/net-next/c/61caac2d1ab5
  - [net-next,8/9] net: lan966x: Add port keyset config and callback interface
    https://git.kernel.org/netdev/net-next/c/4426b78c626d
  - [net-next,9/9] net: microchip: vcap: Implement w32be
    https://git.kernel.org/netdev/net-next/c/4f141e367123

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


