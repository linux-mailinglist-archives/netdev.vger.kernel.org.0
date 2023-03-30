Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B966D043F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjC3MBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjC3MBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:01:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F13F2D4F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LIeIeVO/W19N3NLTD2InDSEwsi/LTsc1lCmV6Hlbseg=; b=qDRsduEa6zBocLjpVp2UzoMqv0
        b2cp8slphvIwvF9XvV17wTlNxNman5dlTOGYG9ryaMXvy1AEXBxBD+RK4/FwXMw1yE7uGriB2/O/a
        RSiA2ZaIH8J8KH8veu5JLY780ZkOcjHwWfF2tgHVCTcIFAt4OlubE1IWYUPeUdW9OE7s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phqyM-008sM1-Ko; Thu, 30 Mar 2023 14:01:42 +0200
Date:   Thu, 30 Mar 2023 14:01:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Message-ID: <943ee78c-e40a-4682-a271-65d40b69314f@lunn.ch>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
 <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
 <DS7PR10MB49260FFA60F0B3A5AB7AD69EFA879@DS7PR10MB4926.namprd10.prod.outlook.com>
 <156b7aee-b61a-40b9-ac51-59bcaef0c129@lunn.ch>
 <ZBxjs4arSTq4cDgf@shell.armlinux.org.uk>
 <DS7PR10MB4926A59970F3DEAE76542FFFFA8E9@DS7PR10MB4926.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR10MB4926A59970F3DEAE76542FFFFA8E9@DS7PR10MB4926.namprd10.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Regardless, what do you think reading 0x0000 or 0xFFFF should be
> considered as a PHY error?

It is clearly a hack to work around the missing clock. Sorry, but no.

   Andrew
