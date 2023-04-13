Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CF96E108A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjDMPAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjDMPAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A34D72A8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC93E63F45
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F366FC433EF;
        Thu, 13 Apr 2023 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681398011;
        bh=KcActgIAW0oZDDcfo4y0JFrZdrVcF6B8ivReN+mnXbI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7lFa2GIvTzfhfxD3+m1QAtDWqbnXf5g5BEXK9LeHKxwAbVfxMP0k9gDaxM4vnd8x
         rBzPhOVwJ9g7kJ2Uk4gWera7vx/I6lNiVkDyoSnQGAjUMtb53Sk4btnieNb+o2QLmf
         1l0ZZOSdPrxNn07L6RrSaHFB51BtccQWe4iXY2wmGc3UlMHomMQuF+7xeUNC3mffAy
         DsQioUcKPXhIY84a6viaOICy/FSxseUmvBDFcGXPKFcdvDtEDYrFWPNTvWK9zQGN9S
         0sn21i8UM0IiirxucB8vMQ+Ar660SXHAgWbRXGB2xsvNAieVEAmiy6ezukUgkbphFq
         g/5xmscUU5XwA==
Date:   Thu, 13 Apr 2023 08:00:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org,
        "helpdesk@kernel.org" <helpdesk@kernel.org>
Cc:     Rahul Rameshbabu <rrameshbabu@nvidia.com>, netdev@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: pw bot mismatches on pure rename patches (was: Re: [PATCH net-next
 1/2] tools: ynl: Remove absolute paths to yaml files from ethtool testing
 tool)
Message-ID: <20230413080010.7e69dde3@kernel.org>
In-Reply-To: <168135961849.12762.11668973666026729971.git-patchwork-notify@kernel.org>
References: <20230413012252.184434-1-rrameshbabu@nvidia.com>
        <168135961849.12762.11668973666026729971.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 04:20:18 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - [net-next,1/2] tools: ynl: Remove absolute paths to yaml files from ethtool testing tool
>     (no matching commit)
>   - [net-next,2/2] tools: ynl: Rename ethtool to ethtool.py
>     https://git.kernel.org/netdev/net-next/c/f2b3b6a22df7
> 
> You are awesome, thank you!

Hi Konstantin,

this may be worth investigating, looks like a generic bug. The patch:
https://lore.kernel.org/all/20230413012252.184434-2-rrameshbabu@nvidia.com/
has no diff, so I'm guessing it confused the bot and the bot matched
on whatever got pushed into the tree next.
