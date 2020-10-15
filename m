Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCE28F973
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391568AbgJOTan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:30:43 -0400
Received: from mail-eopbgr1410111.outbound.protection.outlook.com ([40.107.141.111]:54291
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391541AbgJOTan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:30:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYLcX6Muh04KONK9o4ZkA5M0sgAcO3JmLa0uI/i0yYUMHFpmHEahj2wpEJy76x9G95LyVMlG9MW7Bq69LnhmMQNzzxbyF/wb2TFrPbJysnxyRNYz7g+OUgZFraM6bv/VXKSwembo0BSzF7Gx1WhnUC00u+oAqSq9gVowv/VFnk6ukkuB2taiWGSNaehod/H6OYfHsoL1I7RaatjAXSlNcZWuLQCEYDeCq8uJJJFyG9bqnet4gF5iJN9Z/GcRtpiOeCQA/7/M6/hYt3noccYFZcs2QwrCPNvDgasUn5m1vDlFCp5hujMtu6NUAT0VQvRmlLWdSeHN4Stf2CHff3ltHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLu1Gf7fs5auIuCo4dbBlOqrnaA1080CHxNhcoznW+w=;
 b=C0wFMlzs0VHDZVT+rqKWniNPoZ71HRDgN0TsfzquHKEC7xvsDH61ZKLvhyhxi1Zkv6PVjSgZeCaGR7Lq9K1EgntbysAp6AACHQ1Co13Zu6wft7hLpy+/VIFHOr13x9QSLoIETvwWFzMN6OlKZQ5z0TCcdzmG40WgQ0712pPSXPYZfgTn9a92Cl38n83XPVGat44YX02C9ehi+w4thB74AqvCDNQksYwzqKQa8MktcAwTAUhLjkTmjuiCiM1AKdxyrKZFWGmTxRNNuCOKAp1VuQAKivBsq2ebnRcIR2oNXFVw77WsHkiAs58UGWfXUei77JWkT1xXK7VJWMt9JRbY5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLu1Gf7fs5auIuCo4dbBlOqrnaA1080CHxNhcoznW+w=;
 b=jRjE1K5LbH2GAAlYExT0I7GVJAc/eqx3TvYXnKedXqO2bzTewi/7U6sUrJ/xOZmM91uG5Rl6KLqV4icn1m4U40toKJLvksd2eTtsMztXxjuCoqVHGPigunFIEV0Xa3pgRJY3Zy7ERfeo/6g8VlB2i7uSUoEdDTVspA9xxxPgifs=
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com (2603:1096:603:32::12)
 by OSBPR01MB2583.jpnprd01.prod.outlook.com (2603:1096:604:17::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Thu, 15 Oct
 2020 19:30:39 +0000
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae]) by OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae%4]) with mapi id 15.20.3477.021; Thu, 15 Oct 2020
 19:30:39 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/4] ptp: ptp_idt82p33: update to support adjphase
Thread-Topic: [PATCH net 1/4] ptp: ptp_idt82p33: update to support adjphase
Thread-Index: AQHWbNNNcRh/NvaO/EqwPA/iKPqxyamZeT1Q
Date:   Thu, 15 Oct 2020 19:30:38 +0000
Message-ID: <OSAPR01MB178028345EC84C1564DD104ABA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
References: <1596815755-10994-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1596815755-10994-1-git-send-email-min.li.xe@renesas.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: renesas.com; dkim=none (message not signed)
 header.d=none;renesas.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [173.195.53.163]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4a09810-f88a-4553-e329-08d87140cc33
x-ms-traffictypediagnostic: OSBPR01MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB25835869CEE9F91867C0538BBA020@OSBPR01MB2583.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ifcGET8fEGa1oOA2Q2eAPQYBlw9lQ76nSvSZkPcgxXOX2NzkTg43bepj6eIc4Ce56fWwCOl4oX/9Ihx/WpXn3P65qDIvJzk+B0pLytB55HsOkM8b7G4nkhpQBdhHl1clLcNrm7r2rnX6Zw4r+xpZ54AIvgfkrjfituvUXgHsEG2uxzx8E+zFewf98oTsdnu0ONkcuKqtHrLzkMLHIQzBb7ATiCmR4H1yciiOeRz8+BLJM32xlsdYSPDAPsLBKA0t7xFRysOnGMTz86njdEh3FqUnRzpKYCHBL3uCyBkK5xsTmiorfk3Pe9Ne+yzrAEeU2owCF3yTeiHN/xKnZZvjskt+E1uctCWdw6LCPTgSBqOuIhHIvpWdJBhVDn8QUtI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB1780.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(15650500001)(8936002)(7696005)(186003)(8676002)(55016002)(2906002)(9686003)(54906003)(66946007)(5660300002)(76116006)(316002)(110136005)(26005)(86362001)(64756008)(66476007)(66446008)(66556008)(6506007)(52536014)(53546011)(83380400001)(71200400001)(33656002)(4326008)(478600001)(473944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: W9yfg7pDMu1KI1m1LJWnUmYbYQkQZAEDw4JuPU/Jtior0YCyJEhrKTPkpjBsvcNGsko1t3htk/h8HquaWpuspHSRRFICGcFlwwVw4jMJiDTjbPkyPw4Fnb8YXGkahMshLK0JvZJOU9QsOD+/HOExOpCf5q/47REzHwoAGpw6TjMNNZ9fpB24Hgy5hcBzW9LU4k/7SGs0F6Al8ZzyBGO0iW+YbKppFb/NSDEHj41P+1JqBmteFqel+4mKnivJjdw6gInIYsg/3qMk6Mp5rytluSn/9d3mGr0pzP3u7srgE3ggyuCUokCad/3jRMW/LdQEcusebGL8PgI2lMGr8zF7zyljvCcaRuhgpQ4cyEkRGbDBCDz61zl52/Cjsl892BLghEBDTPH/Yd7ygkGs5dx23u+lSxCuIJ9YpP2Esptk3iFR1zHhSscw+Dsjq4odgHYSrxCXW9YhEed4oM94evsrOHTO+laz3jR2WOnKCu3RoCVWA3Zyji1RkMmW9f+aPMEX9y4OJaTBXeejFh3enj9VX9HUsZUgw0h6ZZDu59EgSDExtHlaaAcqzEQ/VBtLm9HklwZFESfwZKkMRaIthkiD7jo88pp1tvGuvCJDr1OR1Htx5mGBlTFmzk55UjMZJ1CYLT4XqFVY5cjc2pfp3qs6wA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB1780.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a09810-f88a-4553-e329-08d87140cc33
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 19:30:38.9164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lmmEbF2PsHQRgPK2Mv4OcdL7HF7pduuN6RxowmouydqEgbqYLbtANpWTKq30+RZvyjsFmyfd/FbZNFTOdDSkLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2583
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David/Richard

When you have time, can you take a look at this change? Thanks

Min

-----Original Message-----
From: min.li.xe@renesas.com <min.li.xe@renesas.com>=20
Sent: August 7, 2020 11:56 AM
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Min Li <min.li.xe=
@renesas.com>
Subject: [PATCH net 1/4] ptp: ptp_idt82p33: update to support adjphase

From: Min Li <min.li.xe@renesas.com>

Add adjphase support for idt82p33xxx synchronization management unit.
Also fix n_per_out to the actual number of outputs.

Changes since v1:
- Break into small changes

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 48 ++++++++++++++++++++++++++++++++++++++++++=
+++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c index =
179f6c4..bd1fbcd 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -674,6 +674,51 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 	return err;
 }
=20
+static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32=20
+offsetNs) {
+	struct idt82p33_channel *channel =3D
+		container_of(ptp, struct idt82p33_channel, caps);
+	struct idt82p33 *idt82p33 =3D channel->idt82p33;
+	s64 offsetInFs;
+	s64 offsetRegVal;
+	u8 val[4] =3D {0};
+	int err;
+
+	offsetInFs =3D (s64)(-offsetNs) * 1000000;
+
+	if (offsetInFs > WRITE_PHASE_OFFSET_LIMIT)
+		offsetInFs =3D WRITE_PHASE_OFFSET_LIMIT;
+	else if (offsetInFs < -WRITE_PHASE_OFFSET_LIMIT)
+		offsetInFs =3D -WRITE_PHASE_OFFSET_LIMIT;
+
+	/* Convert from phaseOffsetInFs to register value */
+	offsetRegVal =3D ((offsetInFs * 1000) / IDT_T0DPLL_PHASE_RESOL);
+
+	val[0] =3D offsetRegVal & 0xFF;
+	val[1] =3D (offsetRegVal >> 8) & 0xFF;
+	val[2] =3D (offsetRegVal >> 16) & 0xFF;
+	val[3] =3D (offsetRegVal >> 24) & 0x1F;
+	val[3] |=3D PH_OFFSET_EN;
+
+	mutex_lock(&idt82p33->reg_lock);
+
+	err =3D idt82p33_dpll_set_mode(channel, PLL_MODE_WPH);
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
+		goto out;
+	}
+
+	err =3D idt82p33_write(idt82p33, channel->dpll_phase_cnfg, val,
+			     sizeof(val));
+
+out:
+	mutex_unlock(&idt82p33->reg_lock);
+	return err;
+}
+
 static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)  =
{
 	struct idt82p33_channel *channel =3D
@@ -784,6 +829,8 @@ static void idt82p33_caps_init(struct ptp_clock_info *c=
aps)  {
 	caps->owner =3D THIS_MODULE;
 	caps->max_adj =3D 92000;
+	caps->n_per_out =3D 11;
+	caps->adjphase =3D idt82p33_adjwritephase;
 	caps->adjfine =3D idt82p33_adjfine;
 	caps->adjtime =3D idt82p33_adjtime;
 	caps->gettime64 =3D idt82p33_gettime;
@@ -810,7 +857,6 @@ static int idt82p33_enable_channel(struct idt82p33 *idt=
82p33, u32 index)
 	idt82p33_caps_init(&channel->caps);
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT 82P33 PLL%u", index);
-	channel->caps.n_per_out =3D hweight8(channel->output_mask);
=20
 	err =3D idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
 	if (err)
--
2.7.4

