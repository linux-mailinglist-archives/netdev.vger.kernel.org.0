Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A28188253
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 12:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgCQLhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 07:37:08 -0400
Received: from mail-vi1eur05on2089.outbound.protection.outlook.com ([40.107.21.89]:43744
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbgCQLhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 07:37:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnCnIkMRl3E7z0eTDUxrJsKjo3V1aiBHX0UWxDz1NxGosum1xyruWOX3fwSRJga7XiDOexl9z6yOc8G5D6Edbq3sK5qqZGwBzdxdLiztyxsKm7F0B+ufJcSPXGC21flhk4/nrI8wno9eHIq7asuhCvbPGR2kQ0vCBA/f+RMUUBJq31TDfVnSqdOk63ckXVHcXJc2luRkmj+GUx7eHC4QWPbh7xnjgwX8m6dkobZbG3l53i/ac0P/kAl0s1ePnCTNZxe/+7uNe8YVwp0GxpNuboCZt0T43kGG9ua4mg8KQoRi+b8XFDsFQrh8c1hJH8yHalkrI8G86t/j36FGLCuStA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQQJmgoDYJbWuBxC9YO0ZQG5YzULXKJ0XyD9y0sVRVU=;
 b=hMxuwYNgjTov2hISfgskotussrnNwXV+TWptSPslwQvU3Vu/2jV3BNVzplsybQH8zXnx37ol1GGwu66zsjImSRwSvCjC7Y9waJ4XmG3+MteFAM5Dqv5vJ2R09UOl/e/RMmrC5w2Z5P4trVUELGCE8M/Zfe1OKh2Xf7+xOzjLUrLYcoEp8TuHP+OW5QgfW8uQ4IZn4ty6cwyr8xT5fHWlSx+s7VzHHD9j7qjI0tYA91bIkOdZab6DRs8gk0tX4/Ho/WejJ0XYHDabJJMa7cv27ZvfgOjl5vIGnelIEgaJD/AVF3gGIJ0i1yaIxc9fIYbF16qWg91n8AJ8rzptmc7c/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQQJmgoDYJbWuBxC9YO0ZQG5YzULXKJ0XyD9y0sVRVU=;
 b=XONFGi7lU465OsxyURNJYVKi0WBJPuqnTUoOJQOOG6Ozkjog+2s+ieoyehSQu7FisOtaOrm+cHwovQB2Ngdhp4csNUebYKeiC/Hn4FPJAZbimyhlPSIZuamjfLBNwk90uni9O8HeqtJYts5O7cE0+fyr4R5PEOoQ03dw0AB3CnI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB7153.eurprd04.prod.outlook.com (10.186.131.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Tue, 17 Mar 2020 11:37:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 11:37:02 +0000
Date:   Tue, 17 Mar 2020 17:06:50 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Message-ID: <20200317113650.GA6016@lsv03152.swis.in-blr01.nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131153440.20870-2-calvin.johnson@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 17 Mar 2020 11:36:57 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06da80fb-3b50-4769-bd85-08d7ca6782d6
X-MS-TrafficTypeDiagnostic: AM0PR04MB7153:|AM0PR04MB7153:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB715309A3175C5F3108D8304DD2F60@AM0PR04MB7153.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(199004)(186003)(16526019)(5660300002)(316002)(44832011)(86362001)(54906003)(956004)(66946007)(66556008)(66476007)(478600001)(33656002)(4326008)(1076003)(8676002)(9686003)(81156014)(81166006)(8936002)(55016002)(6666004)(1006002)(7696005)(52116002)(6506007)(2906002)(7416002)(6916009)(26005)(55236004)(110426005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB7153;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Agx+6WwlUZMvMwY5+xvkIOeHOd/QHNIWUm+eoeWxHNsmNmSwjCLVOmG3PUsv0F8XkMaRe7CtERUUBC9OPi1sCv6+zFFtD/midMlERCSSjySuAHHF09le2QUSLxNM0UWOcEcEbY5jhlMYVX1aKZeuIoO1oV4G3K8IrSZ2CQ5jxDjCpUfdPpyE6rSvQ7SI61N0L4vGP+9DYQQDfxUkOf9uuJQPOR1k2ZgqOlyj4nWt98MA4RUXQNwCyCzi2cqOD/aFTjhI61B4QrBDtKF4Py+zWh2gz5TetW8WclWgR99DQt/VAR1jANCPjpWHUsBd+4472BFZdjRbH8gq2o4fTsKvwHNsYy5XlHw5tkNi3T4QL0AKyzRS6fJogEHZDv+wp8tPdlvCXELkIscUc8e7mAYzLjpITGMPH6EdQ1+P1MPtF8fYBmfcy7U/4CZ4lhyZBbQ8LS0AQtyVHGwjdNwS1XEKzkVrYfHhBIyK8Zm6gI+ityPMH0+z9Z00uZo0rALv9djd
X-MS-Exchange-AntiSpam-MessageData: 3rfCOvF5xfeRXsvW2FnBpwFnosPqguOSzFU2zW8bBpdIEJ2/d1ZnA9IJIBUICQPyFGdsR9KC1cluct24VpLwx8EHcBUfsKsapC+w2+n04Pzm2T+RyZWWDrEzmIr9o4ISnz9bRlppuR58tMyEA+xA1g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06da80fb-3b50-4769-bd85-08d7ca6782d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 11:37:02.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqnHT2gOro7JKPiaWFCyl9vhpJB1JR82GWkXCLX5eDnn5DyBo/ihJu5i2pcePJ7fSHpNYFjAhXWZSux+GkebXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jan 31, 2020 at 09:04:34PM +0530, Calvin Johnson wrote:

<snip>

> +/**
> + * fwnode_mdiobus_child_is_phy - Return true if the child is a PHY node.
> + * It must either:
> + * o Compatible string of "ethernet-phy-ieee802.3-c45"
> + * o Compatible string of "ethernet-phy-ieee802.3-c22"
> + * Checking "compatible" property is done, in order to follow the DT binding.
> + */
> +static bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
> +{
> +	int ret;
> +
> +	ret = fwnode_property_match_string(child, "compatible",
> +					   "ethernet-phy-ieee802.3-c45");
> +	if (!ret)
> +		return true;
> +
> +	ret = fwnode_property_match_string(child, "compatible",
> +					   "ethernet-phy-ieee802.3-c22");
> +	if (!ret)
> +		return true;
> +
> +	if (!fwnode_property_present(child, "compatible"))
> +		return true;
> +
> +	return false;
> +}

Can we use _CID in ACPI to get the compatible string? Is there any other method
to handle this kind of situation where we would like to pass C45 or C22 info to
the mdiobus driver?

Thanks
Calvin
