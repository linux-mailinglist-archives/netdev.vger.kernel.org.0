Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28A328F97F
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391661AbgJOTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:31:05 -0400
Received: from mail-eopbgr1410119.outbound.protection.outlook.com ([40.107.141.119]:57379
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391637AbgJOTbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:31:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEFurHfMizlMp1RcGpLPsKMPICTMi/S3GUtxGuzMEY4Ocl7d33qlT6ZRgYX+LKvDMIhY2BO65hDWLtpasLxGYq4puVWZva+bv3vTlvtJARLjxgnLJI2c9+tomJxIq4YIbh77fgiuHaQvruA1icGYTDXiTVIQThWuZdKby7niQidMtxSnJ5GDiDqwqZCW6z8wN83NCqtP4UWIAvwo3ZE0by0N9Eg2KixntAcpF6A2s7O7Zi3orILzpJ9KPz/XIMmtDcWW7JeIer72I7SczqL41nB/XMXVDNHjOShfw7oeRNP8bs5N7HrvGX/0o02ZLt2mtexZLb6nVldXzDnE3Anaow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY+Bedoa6qulVVg6d3QcpX8KYgRkAC2TF/m3Iv7+TVk=;
 b=Ad2B6bV7u96ZG5iVgUkAViMlAsq7Gn8U/75j67Y84BnlWHTE5CPMPXVPnFGRnH4h2i3AVXgIpDuZaIgPS8A3BHVIskxAmopTUR9L2KoC5OyDa4lGHnk0h3BclX8qTIW1ofMQqFuoCVHjLR9NqjjWApoBh7RzmQTN291RBwX3Cqt0c8nPKkINnSBjCxK1NdEisGeD/p0D1udhxWZ0quA1pX0GRDjxQtRZoVmrUmiMBgWVDnENVyPRYNwVDkg9rtw971YF781BDyHK7LumtJkqaBAGhwJfDhYQEe+kBWtcqqPOFnr/pymPlfwICHZ4SScWgnWYax/LuD4N/p2UVq92tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wY+Bedoa6qulVVg6d3QcpX8KYgRkAC2TF/m3Iv7+TVk=;
 b=LImHpDeQaMYP6zBujK7w/lCl4PeIqYDrNBiNgdCgd+pJjU6MJqxTPB45LBWMK/LOZI2ScTfIzPXECYU/xhbZBa4Cnm1wMuSupuUm21XCmWxTwBw1lNw+nSiAzuKhObBo4oaNM1BzAyLZLlGVqgNWqg9UeMzco9f+3/bJMr+J1Qw=
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com (2603:1096:603:32::12)
 by OSBPR01MB2583.jpnprd01.prod.outlook.com (2603:1096:604:17::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Thu, 15 Oct
 2020 19:30:57 +0000
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae]) by OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae%4]) with mapi id 15.20.3477.021; Thu, 15 Oct 2020
 19:30:57 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 4/4] ptp: ptp_idt82p33: support individually configure
 output by index
Thread-Topic: [PATCH net 4/4] ptp: ptp_idt82p33: support individually
 configure output by index
Thread-Index: AQHWbNOrfUA0C0DGnkCUtI/kv55TQ6mZebwQ
Date:   Thu, 15 Oct 2020 19:30:57 +0000
Message-ID: <OSAPR01MB178051B4AC87B84D2A4B18FFBA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
References: <1596815903-11144-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1596815903-11144-1-git-send-email-min.li.xe@renesas.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: renesas.com; dkim=none (message not signed)
 header.d=none;renesas.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [173.195.53.163]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c8cab35-cfad-426b-d685-08d87140d736
x-ms-traffictypediagnostic: OSBPR01MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2583E1CD9BA4AD6ACCB4C93ABA020@OSBPR01MB2583.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rYkVL3ngr+M7eif0paA4ytp8y62LBdLemSixI/5xhpC/sKTO9ejog6qlZGHhCiQSM4EzDDfDJ8eojumKS9p7NF90+NNOJKBh0HIQSDgM3fyJZvm5FLRe364pqG4piVgkhO5OmHBqU0QC8RASzbbNmeeyVCv0aveanF0iJwxOF172+jyMtwLMfDoYnaGbmAbYI68ZUJM+1mgw1Rk/w9Gd8Iufgb0gw1mmu1IW2xZZ7OwHa2NzJTTQWHGl9ufdvjVhQCFhW5MNPUYAqv4/lS+mdJja7zgj1X0XG/B9zV8ZTkkm+LylGLXf+3TuRo7eN4XymVM8BXFOQsQHTk/YfXie8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB1780.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(8936002)(7696005)(186003)(8676002)(55016002)(2906002)(9686003)(54906003)(66946007)(5660300002)(76116006)(316002)(110136005)(26005)(86362001)(64756008)(66476007)(66446008)(66556008)(6506007)(52536014)(53546011)(83380400001)(71200400001)(33656002)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ymOmj6+wA7uw0sYZ30/+pnaTGArFQRVOw5vNm8HNYftfT+W2ImSpV+3nK98xMdwP5GtK+clFA03TNDj7RPYNTaz4KqtA0U0jwE7t/kZ14p5KHJisf5+gNwmQyiFuTFl2acvmdliYiRvzOx1zWHD3taVj7c9QG9netHa4X+1j94h1LRuuBgW4/5/pPdWtKoxlu2bUwhlGGizjnwxtjiphVig3fMPlA7dxLNbCY7D2bhS5o8fZvFIZQre1CzzMVi1u7k/Ex7JJQuDxD1dus62jrrK6bjmq7Z4QNjmamSVv/PmrxapbHQakt5A0mL7KVSyFLl4OfnKjmut+ALBZVoVwrv0qOqhnx6rx8pu87q1KpkA0RX9gm6/NrHi8x0Gwdxo+EbC9Fm0sAbVrX7Pmdq6HG1c/FVUxXYOFMFHck9WiJybO8Eja6l/EmDPVFg9BaokFDRKKriUdSype5A9zfLgufRkJlhq5gAtgs6f3ZOHhbkJFylaTgsYuZjPhx3iLi3mNeLhgCMCY5NyvvPg7soAHWtHD3kMUHFXlR+8k+28JdV4VGTVxZYTFGgGG307uuaot/lCQ8NPt0sNYodcJrLm+79Eqs/T7YwIHnVQJgBtmXF2yIWiBgb6SEjjHFM+VuN4Gu36of+rGD74r5CzvHLRIlg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB1780.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8cab35-cfad-426b-d685-08d87140d736
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 19:30:57.3397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ngGrjcm2uc5iBjSRgQoT/268OIqCiKbacAANf5LC1zvKtwYY+CMOmoB5hrmhI2xWL6Co9LW+vvPWfvVMvVyqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2583
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David/Richard

When you have time, can you take a look at this change? Thanks

Min

-----Original Message-----
From: min.li.xe@renesas.com <min.li.xe@renesas.com>=20
Sent: August 7, 2020 11:58 AM
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Min Li <min.li.xe=
@renesas.com>
Subject: [PATCH net 4/4] ptp: ptp_idt82p33: support individually configure =
output by index

From: Min Li <min.li.xe@renesas.com>

Enable/disable individual output by index instead of by output_mask

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 62 ++++++++++++++++++++++++++++++++++--------=
----
 drivers/ptp/ptp_idt82p33.h |  2 ++
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c index =
2d62aed..b3c82d7 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -578,33 +578,46 @@ static long idt82p33_sync_tod_work_handler(struct ptp=
_clock_info *ptp)
 	return ret;
 }
=20
-static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enab=
le)
+static int idt82p33_output_enable(struct idt82p33_channel *channel,
+				  bool enable, unsigned int outn)
 {
 	struct idt82p33 *idt82p33 =3D channel->idt82p33;
-	u8 mask, outn, val;
 	int err;
+	u8 val;
+
+	err =3D idt82p33_read(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
+
+	if (err)
+		return err;
+
+	if (enable)
+		val &=3D ~SQUELCH_ENABLE;
+	else
+		val |=3D SQUELCH_ENABLE;
+
+	return idt82p33_write(idt82p33, OUT_MUX_CNFG(outn), &val,=20
+sizeof(val)); }
+
+static int idt82p33_output_mask_enable(struct idt82p33_channel *channel,
+				       bool enable)
+{
+	u16 mask;
+	int err;
+	u8 outn;
=20
 	mask =3D channel->output_mask;
 	outn =3D 0;
=20
 	while (mask) {
-		if (mask & 0x1) {
-			err =3D idt82p33_read(idt82p33, OUT_MUX_CNFG(outn),
-					    &val, sizeof(val));
-			if (err)
-				return err;
=20
-			if (enable)
-				val &=3D ~SQUELCH_ENABLE;
-			else
-				val |=3D SQUELCH_ENABLE;
+		if (mask & 0x1) {
=20
-			err =3D idt82p33_write(idt82p33, OUT_MUX_CNFG(outn),
-					     &val, sizeof(val));
+			err =3D idt82p33_output_enable(channel, enable, outn);
=20
 			if (err)
 				return err;
 		}
+
 		mask >>=3D 0x1;
 		outn++;
 	}
@@ -612,6 +625,20 @@ static int idt82p33_pps_enable(struct idt82p33_channel=
 *channel, bool enable)
 	return 0;
 }
=20
+static int idt82p33_perout_enable(struct idt82p33_channel *channel,
+				  bool enable,
+				  struct ptp_perout_request *perout) {
+	unsigned int flags =3D perout->flags;
+
+	/* Enable/disable output based on output_mask */
+	if (flags =3D=3D PEROUT_ENABLE_OUTPUT_MASK)
+		return idt82p33_output_mask_enable(channel, enable);
+
+	/* Enable/disable individual output instead */
+	return idt82p33_output_enable(channel, enable, perout->index); }
+
 static int idt82p33_enable_tod(struct idt82p33_channel *channel)  {
 	struct idt82p33 *idt82p33 =3D channel->idt82p33; @@ -625,7 +652,8 @@ stat=
ic int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	if (err)
 		return err;
=20
-	err =3D idt82p33_pps_enable(channel, false);
+	if (0)
+		err =3D idt82p33_output_mask_enable(channel, false);
=20
 	if (err) {
 		dev_err(&idt82p33->client->dev,
@@ -681,14 +709,16 @@ static int idt82p33_enable(struct ptp_clock_info *ptp=
,
=20
 	if (rq->type =3D=3D PTP_CLK_REQ_PEROUT) {
 		if (!on)
-			err =3D idt82p33_pps_enable(channel, false);
+			err =3D idt82p33_perout_enable(channel, false,
+						     &rq->perout);
=20
 		/* Only accept a 1-PPS aligned to the second. */
 		else if (rq->perout.start.nsec || rq->perout.period.sec !=3D 1 ||
 		    rq->perout.period.nsec) {
 			err =3D -ERANGE;
 		} else
-			err =3D idt82p33_pps_enable(channel, true);
+			err =3D idt82p33_perout_enable(channel, true,
+						     &rq->perout);
 	}
=20
 	mutex_unlock(&idt82p33->reg_lock);
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h index =
1dcd2c0..5008998 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -56,6 +56,8 @@
 #define PLL_MODE_SHIFT                    (0)
 #define PLL_MODE_MASK                     (0x1F)
=20
+#define PEROUT_ENABLE_OUTPUT_MASK         (0xdeadbeef)
+
 enum pll_mode {
 	PLL_MODE_MIN =3D 0,
 	PLL_MODE_AUTOMATIC =3D PLL_MODE_MIN,
--
2.7.4

