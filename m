Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE5D674AC5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjATEfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjATEfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:35:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0507C13C6;
        Thu, 19 Jan 2023 20:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0CCFB8280F;
        Fri, 20 Jan 2023 03:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB383C433D2;
        Fri, 20 Jan 2023 03:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674186807;
        bh=bIXbgJCMl5PKIM+Vupm5sIWAH0IdHT0YOlmjutBmixQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iRF0iXY/2IW0CMYm+izymHoRODfmk9iCeew7c4QSAaO0rU7SygCQmyVhy39sytVt/
         csaTf0mdvrwknTT0ObpEcoppJk3C8HDluiZFSg3Jzi8+cGdnkx/oEeQZEMxYQrLFhR
         t41z+plnHypes4HKdjXgguyqp6QmJeeVph6redi2yXtsjQg4Mw2ksx8U8p6KlbpOvy
         Q1DK+6Xlw4Ru7dSBetFk5N1PF+qjhpVw6oBygRQLQmTeFRzpSqfkcY3dvd04pDP/y7
         dfb243qT671QOTTh/nHEkN8SnI9WlK4gDWiA8fTLNhYhB+gHGJ6s/Bey6D8gYCfBFJ
         ZQZRO9MrandTQ==
Date:   Thu, 19 Jan 2023 19:53:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: add driver specific
 get/set_eee support
Message-ID: <20230119195325.50528972@kernel.org>
In-Reply-To: <20230119131821.3832456-2-o.rempel@pengutronix.de>
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
        <20230119131821.3832456-2-o.rempel@pengutronix.de>
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

On Thu, 19 Jan 2023 14:18:18 +0100 Oleksij Rempel wrote:
> +	/** @get_eee: Set the EEE configuration */

set

> +	int (*set_eee)(struct phy_device *phydev, struct ethtool_eee *e);
