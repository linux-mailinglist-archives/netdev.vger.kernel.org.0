Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247D54DB395
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbiCPOqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243640AbiCPOqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA7F6006F;
        Wed, 16 Mar 2022 07:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 369EBB81B76;
        Wed, 16 Mar 2022 14:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577DEC340EC;
        Wed, 16 Mar 2022 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647441927;
        bh=tJToEPSfN0c7o7+u0m33QWvqfmZGCF5OVG9pt0H5KYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmFcu7t1lvUZDN3STtQnofQiFDNiDI/uPR/wiWcfpwh7OdQSRvDkXLu3bQ/DTmKnx
         fLdlmFIqdDILDKi8gkikX4insVG0NVNyj3EiHe148bHsZIcMqt+wMAnJI0hhUhxpOd
         SgHtSnWdjN1Z9lA9Um32DVtx+uHcsgUrrb6PYWQfA5zgmAvUSLWtaciDFtlxDHprc/
         BZYLhTgglPreQvktOWXP9IIIAg0kAb82MeOQM3ntmgwk6JW/dEY5TVETdxc9xsL0NN
         3f9wpleuDLzZBcs04oqZWyCukW/7MD8G+AZuUDCA2BV/F1pHq9PCPDJaxk9JAxJvhZ
         JsSEfvfLD4w9g==
Date:   Wed, 16 Mar 2022 10:45:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Casper Andersson <casper.casan@gmail.com>,
        Joacim Zetterling <joacim.zetterling@westermo.com>,
        "David S . Miller" <davem@davemloft.net>,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.16 16/27] net: sparx5: Add #include to remove
 warning
Message-ID: <YjH4BCEAArhrQMJ7@sashalap>
References: <20220309161711.135679-1-sashal@kernel.org>
 <20220309161711.135679-16-sashal@kernel.org>
 <20220309084911.2e75d67d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220309084911.2e75d67d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 08:49:11AM -0800, Jakub Kicinski wrote:
>On Wed,  9 Mar 2022 11:16:53 -0500 Sasha Levin wrote:
>> main.h uses NUM_TARGETS from main_regs.h, but
>> the missing include never causes any errors
>> because everywhere main.h is (currently)
>> included, main_regs.h is included before.
>> But since it is dependent on main_regs.h
>> it should always be included.
>
>This is not fixing anything in the current trees.

I'll drop it, thanks!

-- 
Thanks,
Sasha
