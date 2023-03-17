Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E20C6BEE55
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjCQQbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCQQbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:31:16 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5FE33CCD;
        Fri, 17 Mar 2023 09:31:09 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32HGSaVO081340;
        Fri, 17 Mar 2023 17:28:36 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32HGSaVO081340
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1679070517;
        bh=kmSvARczm0InFVzzK9I97akQBokHemprDe2GPs2aaV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qNpX34D6Prxgv4GmY/ppDulOv9uKFAC9YJtAFZkDlOnTcNV0F5EjTzqMaGZGNVeTw
         oFCUmiZF2yuI1n8oFrSAXDn25oddYdk0Jn7raLffR7Io3sVJesRi9bEue1fRptNu+y
         niX1hfCkFHAK0dY5HCg0kZIiOLU3xF5vJFMVm09Y=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32HGSah2081339;
        Fri, 17 Mar 2023 17:28:36 +0100
Date:   Fri, 17 Mar 2023 17:28:35 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     David Yang <mmyangfl@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: hisi-festa: Add support for HiSilicon Festa
 PHYs
Message-ID: <20230317162835.GA81256@electric-eye.fr.zoreil.com>
References: <20230317143042.291260-1-mmyangfl@gmail.com>
 <d5ec2ec2-65a0-6ad3-a0a3-cad57d7f6616@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5ec2ec2-65a0-6ad3-a0a3-cad57d7f6616@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> :
> On 17.03.2023 15:30, David Yang wrote:
[...]
> > diff --git a/drivers/net/phy/hisi-festa.c b/drivers/net/phy/hisi-festa.c
> > new file mode 100644
> > index 000000000..ab54ed3ca
> > --- /dev/null
> > +++ b/drivers/net/phy/hisi-festa.c
[...]
> > +static int hisi_festa_patch_fw(struct phy_device *phydev)

This function can fail...

[...]
> > +static int hisi_festa_config_init(struct phy_device *phydev)
> > +{
> > +	hisi_festa_patch_fw(phydev);
> > +	/* ok, use programmed firmware */
> > +	return 0;

... but nobody cares.

This lack of consistency may also be fixed once Heiner's remarks are
answered.

-- 
Ueimor
