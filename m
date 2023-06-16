Return-Path: <netdev+bounces-11314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C788732938
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DD442816A4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956928F7A;
	Fri, 16 Jun 2023 07:49:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44B8F63
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:49:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E9826B8;
	Fri, 16 Jun 2023 00:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QvCn4oK7hu8ELYXtMB27kadFWNtUi6i5Gfp2p1naLKo=; b=zhyDhY/5qrgAu00J4uoPFmi+xo
	sGgiUcG46xlm/sCLPApPSOOKwR1GwVyl9a0k2nCYmHo/SeeDSmP055b/km5ZsrFPrR8Z9vReMzpE/
	mcq1Dr+CGn/suzXYrOOXp26FHu4/8y3TEl/IfTi2SVLFfo6c7BWYbY26iAVX485lNmUlzO7/Z+orO
	552fbdmnwYeZJPWhxtGQP80g9tu3XsmKsiIpOa5G5FCyvnZE3zt//+UZs2yu+GDVRN9cb+UykSNbH
	ohtpB0UoOyvl3CFtqteecs+7bNKXtSAt6ukXFQGQbdscczLD4kAt+a28GcoCPymxp53wrFNQofmmM
	GeE6VzVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40480)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qA4DI-0004VG-Mc; Fri, 16 Jun 2023 08:49:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qA4DF-0002Kn-HS; Fri, 16 Jun 2023 08:49:41 +0100
Date: Fri, 16 Jun 2023 08:49:41 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jianhui Zhao <zhaojh329@gmail.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <ZIwUFXOCCKZYSUBi@shell.armlinux.org.uk>
References: <20230614134522.11169-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614134522.11169-1-zhaojh329@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 09:45:22PM +0800, Jianhui Zhao wrote:
> +static const struct attribute_group phy_dev_c45_ids_group = {
> +	.name = "c45_ids",
> +	.attrs = phy_c45_id_attrs
> +};

One last thing - is there any point to creating these attributes if
the PHY isn't c45?

We could add here:

	.is_visible = phy_dev_c45_visible,

with:

static umode_t phy_dev_c45_visible(struct kobject *kobj,
				   struct attribute *attr, int foo)
{
	struct phy_device *phydev = to_phy_device(kobj_to_dev(kobj));

	return phydev->is_c45 ? attr->mode : 0;
}

which will only show the c45 attributes if the PHY is a c45 PHY.

Andrew, any opinions?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

