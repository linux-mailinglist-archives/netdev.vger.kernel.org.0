Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EF932F4C1
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 21:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhCEUsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 15:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhCEUsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 15:48:19 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F718C06175F;
        Fri,  5 Mar 2021 12:48:19 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 89A384D0ECE13;
        Fri,  5 Mar 2021 12:48:16 -0800 (PST)
Date:   Fri, 05 Mar 2021 12:48:12 -0800 (PST)
Message-Id: <20210305.124812.611998680216818380.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: mscc: ocelot: Fix fall-through warnings for
 Clang
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210305073403.GA122237@embeddedor>
References: <20210305073403.GA122237@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 05 Mar 2021 12:48:16 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit these again when net-next opens back up, thank you.

