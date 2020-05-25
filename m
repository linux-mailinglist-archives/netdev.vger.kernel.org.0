Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E121E12BB
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgEYQcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:32:18 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:14054
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731503AbgEYQcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:32:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMX8ILav+I+BKjxHQ2J+P1zuN/brh+pLHu/DqkBYJiQVrjI/XZYD8k8CGafa+Z6APmEqLBXKLLTWWo9vM9ugDmPISSmZLIL1jgnpbwQL27xh6+uxpzQj+uyNnXfDJKHHj/CFheKfU6UNWTrO1MXurDrvzZ316nKurcWx82weaThJxMdW22SX9omTmSX385kbZ1u4dSOfe3QIm2h/vO7LAMncctvLcuXZbUfuWcJhfJNS+vanLnIPpBFZdbeXop1y7Q66Q84dObyaFWMnw4foKdaYMkjiwa015offqRWXHB55NmEdv/JazAhj52C1uwsqve+kp9VwR2sw9aMPKWs7lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLYS+8KaviG3AcYG3U4N7O76AjJCJpmDtkhBytcagt8=;
 b=kARln5Z+4poxPd5jhTCCIIgBj52j2Wj1pF/gbljGXymafpCzb9x2mtKQgKpW4tYbdOv/4yHBVM4qVUzg0R8rlWMQH0kVkX2Za1uR/TWkwlyr9iaXmIWcvAVzCCwn5ZT2UASk6zqyFtA8QAa9Tq1AD9YEaGZPg1Ukw9OS5brwajJP7A1mSCajvsWh866omTPYD/4B2IjaConPqx6V7eCmDc5K++Oi9w1xZUOuTUYUBH0YcIlTWzYSbkKk3PNpd2Hdlu8dHxAPZat0U31BZ0CEDTrq+fqgoAPcpBXIjhR6ifvLAx0RK4xBLYNNrx06GfOFqLTi0rYW2wvtjRcNXXg/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLYS+8KaviG3AcYG3U4N7O76AjJCJpmDtkhBytcagt8=;
 b=me7yO4zTwjcwDfogTpjkaBIg57mnFpu5tkpSHkIYvf1j3ITHuz9l48v+Db6OBWC+SirdU5FGkN/PJKLS/p49Cn9G0UeBbk1uPDmGCMzvybHmXRrROOv7hwdOTVUKElLxOcWOSHXKJB8CuLbrsfuwDy4fLj9j8O/GioCcZsD2SAA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3846.eurprd04.prod.outlook.com
 (2603:10a6:209:18::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 16:32:15 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 16:32:15 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v3 4/4] ARM: dts: imx6qdl-sabresd: enable fec wake-on-lan
Date:   Tue, 26 May 2020 00:27:13 +0800
Message-Id: <1590424033-16906-5-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
References: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 16:32:12 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df3235d7-0043-4d87-57dd-08d800c92f2b
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB38462AE75556FDBFCC6A5270FFB30@AM6PR0402MB3846.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0lq5S7atnszEC9bf+nlWqnyalqq2zAPjIZNMGWAj+hKqFFJx7esWWmyPUIJwQ3zInbLvpn8oRDphErX/Co6DWHIkXSHLtc6mPLAvuFzOt0ym6g1KU3WFvNMGFQPEp1eFWL/vneoNGdUlfsWqml9LedYaIRrTIZL23DYuQV5WCxZKksbba98y51AjWsgFfSSlXwcmML3ku8e/Tpf/SiauWKoHa8lZRdjCCHvpm0bJBpdZl4kpb2fQpaIH+MDgLXd925bGyGltin7qqYjIBdAPgwtuxlAWO8byP13HGDm2bqsaIoMwStBBTs7Ta0nFEX+SlNNmoJpKXAPqQRC2KJZngz5z8EcTjUKUd8136YJFrvaLW48MJqB0KyygX3qGkV+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(6512007)(9686003)(4326008)(36756003)(16526019)(86362001)(4744005)(316002)(6506007)(2906002)(52116002)(5660300002)(26005)(186003)(66556008)(8936002)(66946007)(66476007)(956004)(2616005)(478600001)(6486002)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3lFRULRUdbfJVhwx++afRcSFam1BccAplixOFbU/uLLPpQIm+OxmnKI0CZXL8glVH99IU1d0UO70zoOrJV+bgWwSYyIHvLshe2mpU7MQRBoQ0/XDnN9j119ykLn3gUAP7wpXSY1/si1TIjbCFOwhfETyAfdhst+7/RIaCTeza7z5guQZ4VzJYqVkNOB54geZI8RdJKAVRPFgnNAxosmppidEzfsoM1S102K5LEQaRhzsLPepy96TREFEj9XYJ6YNTPq+G0JzL5QN3gFve4gDtSRUMAlsj7x3+n0kj1EOVuCBJ9jqp8UI1s8sAci7j2/YS9S06YWlta2giUjJhL9LeTlCKzPgUYULdoApumaBWH/EIC5pUnDTg6E5rNwkOz7NCs9UNLs2fJQprsB3dzY5OTC4NQazitroxtTOherMuffPw4sFXJelG3Ds2z7y1YPyYkD79tEoPg3gmQEkwT+fmhBtpjGWYvUfWHR0Hy/G574=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3235d7-0043-4d87-57dd-08d800c92f2b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 16:32:15.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuUebXgj8OQjSBYAfpCAlzvEIjp7hBuCO4caF2sugc607eSiZ4jW6PPDoc1+m4oRptluIXlvP+kO3EnbGBo5wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Enable ethernet wake-on-lan feature for imx6q/dl/qp sabresd
boards since the PHY clock is supplied by external osc.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index fe59dde..28b35cc 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -204,6 +204,7 @@
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+	fsl,magic-packet;
 	status = "okay";
 };
 
-- 
2.7.4

