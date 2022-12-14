Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0EE64C1EA
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiLNBjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiLNBjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:39:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ADC1C129;
        Tue, 13 Dec 2022 17:39:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD84261713;
        Wed, 14 Dec 2022 01:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB86EC433EF;
        Wed, 14 Dec 2022 01:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670981978;
        bh=TWju7GnbhhaVa/YmdorGA+W7tvS1dQZHU7JPcGNtMaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=id+dac9LCG1rc1y2c2Qx7u0CT8hVdsGT28DDFeekxQehlUJZdqp1utwVG3oK34F1M
         hp/84PWYc4AuD1Ciw3iGGIFsOISIABweztzTG6O7D7LUr0ojmARFozodC4Xvk7fm8g
         R2JIpFipYmObsnfCu1gc4HiXaAw0epKQRDb6qCbnsEdzrEy7GfXgSXB8SjcVWppoDa
         p0bmIZs3ErkTSdDeF6N0VW4POxmVPnaRcsMHRUxOD4WNqzemBDyWgbJco9exlqvKQz
         IOIlg5+XrdFQMuGs99yNMJZsVrWMCy+v0YHLH5L+fANEg2VIt0YgLGES7rad1WtsAO
         +yIwP4D81TAtQ==
Date:   Tue, 13 Dec 2022 17:39:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] net: macb: fix connectivity after resume
Message-ID: <20221213173936.0eea106a@kernel.org>
In-Reply-To: <20221212112845.73290-1-claudiu.beznea@microchip.com>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
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

On Mon, 12 Dec 2022 13:28:43 +0200 Claudiu Beznea wrote:
> This series fixes connectivity on SAMA7G5 with KSZ9131 ethernet PHY.
> Driver fix is in patch 2/2. Patch 1/2 is a prerequisite.

I'm not sure if there was a conclusion reached in the discussion 
but I'm worried this will get lost in the merge window shuffle.
So if the conclusion is reached please repost against net.
