Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1C36A5C0D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjB1Pfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjB1Pfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:35:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0104199E;
        Tue, 28 Feb 2023 07:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=04dlp5GnPerfCpKDQNy1P6d4B3/FgMP0LskvsBFPz3g=; b=nbUqKXEelSf04uzzdVWhjaP8G5
        NMb2zdAEFe+ErP4liU4V6Qlbyqx8SraqZ4ijrES/4btN9daaz3aFFoV4WsnRG7/eOShMlmh6WGmQa
        MMYvH/exI35qwJcr7sOVuzc3L86htgzUVra/hbPZRRJI42k+cqLvs7VoCYLQcDUNf+CY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pX20e-006Aar-NW; Tue, 28 Feb 2023 16:35:20 +0100
Date:   Tue, 28 Feb 2023 16:35:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ken Sloat <ken.s@variscite.com>
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Message-ID: <Y/4fOFTSFeAiS4+o@lunn.ch>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <Y/4VV6MwM9xA/3KD@lunn.ch>
 <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
 <Y/4ba4s37NayCIwW@lunn.ch>
 <DU0PR08MB9003DF34A62F764A90F70FE5ECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU0PR08MB9003DF34A62F764A90F70FE5ECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What about for the bindings, how is something like "adi,disable-fast-down-1000base-t?"

Yes, that is good. Plus you have a free text field to describe what it
actually does.

	 Andrew
