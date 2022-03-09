Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8246A4D3573
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbiCIRB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbiCIRBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:01:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C481B124E;
        Wed,  9 Mar 2022 08:49:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4168361B2F;
        Wed,  9 Mar 2022 16:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ADEC340E8;
        Wed,  9 Mar 2022 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844552;
        bh=R05hXvPBP0MsO+0eUuu6EsT2J6bCxSeBZHf81CbpyFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gajoMSmIyUiNx17+PuKlBUFal3ZZ0quQUoj7Ltj5KBcXcoLuWqLhJmlUEb/NzbTjE
         6w70KZVVSj3pA3ThwIy91gCWxREE+25c8PIs5PM7nGKFk7E8rtzIZdDYPfNCEnRsgD
         2oGxZsWp+nsPLgbhrOxlOk9gOItzTHFAJPy/5R/xYYFIKnmr9q5kb8rGE5cr4yAZ1+
         iXh2PAp1h81jgbb0wVCJR53u5OtvPlFXmugaCEvof0ebNUp17y1niYEN0pgI2Lwkp4
         AxKBe8nGcO6MahKVU4AIkrzX++ZYDUpBQYc+VpjgHFYOZOg6Ajp+O5/44zisJnoy7U
         w2IeBLteoAyXQ==
Date:   Wed, 9 Mar 2022 08:49:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Casper Andersson <casper.casan@gmail.com>,
        Joacim Zetterling <joacim.zetterling@westermo.com>,
        "David S . Miller" <davem@davemloft.net>,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.16 16/27] net: sparx5: Add #include to remove
 warning
Message-ID: <20220309084911.2e75d67d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309161711.135679-16-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
        <20220309161711.135679-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Mar 2022 11:16:53 -0500 Sasha Levin wrote:
> main.h uses NUM_TARGETS from main_regs.h, but
> the missing include never causes any errors
> because everywhere main.h is (currently)
> included, main_regs.h is included before.
> But since it is dependent on main_regs.h
> it should always be included.

This is not fixing anything in the current trees.
