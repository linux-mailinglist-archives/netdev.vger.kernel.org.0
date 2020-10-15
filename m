Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BABB28F977
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391621AbgJOTav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:30:51 -0400
Received: from mail-eopbgr1410121.outbound.protection.outlook.com ([40.107.141.121]:10167
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391541AbgJOTau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:30:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvAsay6NWHYHrMpLESja5GxPd1jfyJ300o9O/wBgfM0FEkGmkJQdSlqXzrY1prmOY8ShQ+HWtjPK/o6gdk5WC85MCJdx94A6OzRhNffpL7axLsJve3IspczzXkZqkJJPpg9kFS+ZiOyMznzjaXaLMQ4pEfL+nl9gZyec8hs4icTDVJ6heqZ9CmtxkY355wu2hJ5C3FwJalwqHwRE9BF6ikvzchY1q1GWeO91cqbFfyBfcmgTvEEJj5v5tdo/RT4/vhywmLpjN8oitGFwgYALRb//oXJAYPODXp8wwnc1YqGrIyFUjjBvbgbJvD+BULTVTaBOSEcLHmhQ276jilOf6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZYri1Xp1Y+qMwSCkkBtWIZyvm3lSelof9qrs+z5kM8=;
 b=i7akx98aLamwHj6E+eARscMhQUnUilITYrrIRWXO1uK7ynlRdeJvDrvwEQkCHcE5KR78QHsQUuaiQRBkaQ3dzb4lIpd9l59emOHyLJGFML7S23tp2kYNOmInmkBsnDbfUKmg+6cJdKUk2E/EMD877S69eJNkmPuX+MWAH13EooMrRwUY8XoPaeM+CSMYdzFjjsM4cIMnxsWPusiM7CqgrUHSEAybaJFWugpKuek1jqa/7U1elT4TF+nSTg+udb64sy6bGaMNpCOUQQKG0cuOOyXlPvNBEuXCydv3ZQRBmoOe6modBnsRHxqVThNq6V7mCLlyccbDwAFQYij4MEseiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZYri1Xp1Y+qMwSCkkBtWIZyvm3lSelof9qrs+z5kM8=;
 b=dTGlx79xECh4Wwb+g5FGPAHPrfwL96G57ObAFakeXnXE2Z8oz6yzeVibyP21szFqwJsX9KKiJMXPUa8c5EolEtdjb/BhoOr1Fs7lynAPG73XvuVBsWy5DvOuA5R0Qk6H9f/uX/v0J/JijCCTM57jr0gcFsetXq3hGBVwfm8q1A8=
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com (2603:1096:603:32::12)
 by OSBPR01MB2583.jpnprd01.prod.outlook.com (2603:1096:604:17::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Thu, 15 Oct
 2020 19:30:46 +0000
Received: from OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae]) by OSAPR01MB1780.jpnprd01.prod.outlook.com
 ([fe80::b1fd:3bf0:af0d:56ae%4]) with mapi id 15.20.3477.021; Thu, 15 Oct 2020
 19:30:46 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 2/4] ptp: ptp_idt82p33: add more debug logs
Thread-Topic: [PATCH net 2/4] ptp: ptp_idt82p33: add more debug logs
Thread-Index: AQHWbNOFfZDtT11nNU+wHU0tO2aeC6mZea3Q
Date:   Thu, 15 Oct 2020 19:30:46 +0000
Message-ID: <OSAPR01MB1780733AA3B25A528A76F8F2BA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
References: <1596815868-11045-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1596815868-11045-1-git-send-email-min.li.xe@renesas.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: renesas.com; dkim=none (message not signed)
 header.d=none;renesas.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [173.195.53.163]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b87be427-dc0e-46b3-7e0e-08d87140d0bb
x-ms-traffictypediagnostic: OSBPR01MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB25831A35FB48B8B50FBA5F30BA020@OSBPR01MB2583.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:44;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iubQdiD1XIavTEeQFh0++IuTtzz9X8rwaAa7lX6qd3KeFloW5mqdvDN4/Wr4gOFWkhC91cIoUEbKIopA076mePxu2lW0H3U+4WK8fNpUxLpMnyZV4YNwHjtea4sA+AK6+WkDjQvDM9BBbrBAlsoQnJ/s7g+DcKFBu4xNU6EWSnnuVKdCdVxY2kFldkWamZFnRJYVHIgDWAGo8vVMpg0uBFo9sDfoN1J5yWOUho/bUUyqQWcHJxJw/nk50F97QwirqLTHkFnxCuZ+fid2sIQF6LaGJRnqAMwDvi7Fmh1BVrV9uF8tMxzR3WxLKYBPKIb06TgeOU/wfJCxPPra8S8wEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB1780.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(8936002)(7696005)(186003)(8676002)(55016002)(2906002)(9686003)(54906003)(66946007)(5660300002)(76116006)(316002)(110136005)(26005)(86362001)(64756008)(66476007)(66446008)(66556008)(6506007)(52536014)(53546011)(83380400001)(71200400001)(33656002)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vSusnYUAUsSGv9YnWmN2kGNU223jJX4QBAppvQvUWCd3nxj6a1uEP+/3+pjEvxTAlvc37mTya7dCSmDxOttAz2AxL1wX1sXoH3tumHm1w0MvYwB74uSQDX+BmJ3QzyViUj6dD6uKeNDZZ0Xc0zS+ZYQM+YjLF/kqWpfuxEV6xMD06iPbczJiseJz3r6te5WtMttpOdIVT5DYie0V6pEamV0wlYKw+MpjPSWaWKra8/r4NJaKVVA1eM1IsfanuH9vgCEdeCY9X2KlgmpbTZ0mYmjo9grklFvl6/JBn5en5VpiC+TiZcZUyW3UbfetM/wlgL0Taryv806bvDUSMnEvviEUETEwhChDo8LcPJaEvpPAlw/r9Ho8/Q3BSG6hB26ADAHlDiv8tdfplTiPl2RmJt5JA1IohIt2xwnmZRflpm2V70bDHBrSt8nhSLEPWOZeT4y1FJqFP8YE+uLsWVQd/H11UZ656t7JNfEMLgLEMsWGOzwBVOO6glNTXx2yT2AtOxDqRBcV61548Vgoa/mocJepcvGQ5lxu6G43CO2Xo+yNn05grjGX4ZfFC74x3vn2ZXKXQBff/YNJtr6eWdo1yD5pysb9R7Udu8ZfqHgswvBfFWMCZjdkG2gfgDM1hx+1Jkkb87KXiIOUuFEJohpNmQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB1780.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87be427-dc0e-46b3-7e0e-08d87140d0bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 19:30:46.5000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nPA8SUmKZRtSV+AdD7/fNpvsUAxhcEA7wofooDxVkB3Ph95W00vJ3X5MabAvJ/axuhHXDyQcKLYbHv4ee9T8lQ==
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
Subject: [PATCH net 2/4] ptp: ptp_idt82p33: add more debug logs

From: Min Li <min.li.xe@renesas.com>

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 88 +++++++++++++++++++++++++++++++++++++++++-=
----
 1 file changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c index =
bd1fbcd..189bb81 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -86,6 +86,7 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 	struct i2c_client *client =3D idt82p33->client;
 	struct i2c_msg msg[2];
 	int cnt;
+	char *fmt =3D "i2c_transfer failed at %d in %s for %s, at addr:=20
+%04X!\n";
=20
 	msg[0].addr =3D client->addr;
 	msg[0].flags =3D 0;
@@ -99,7 +100,12 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
=20
 	cnt =3D i2c_transfer(client->adapter, msg, 2);
 	if (cnt < 0) {
-		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
+		dev_err(&client->dev,
+			fmt,
+			__LINE__,
+			__func__,
+			write ? "write" : "read",
+			(u8) regaddr);
 		return cnt;
 	} else if (cnt !=3D 2) {
 		dev_err(&client->dev,
@@ -448,8 +454,13 @@ static int idt82p33_measure_tod_write_overhead(struct =
idt82p33_channel *channel)
=20
 	err =3D idt82p33_measure_settime_gettime_gap_overhead(channel, &gap_ns);
=20
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	err =3D idt82p33_measure_one_byte_write_overhead(channel,
 						       &one_byte_write_ns);
@@ -613,13 +624,23 @@ static int idt82p33_enable_tod(struct idt82p33_channe=
l *channel)
=20
 	err =3D idt82p33_pps_enable(channel, false);
=20
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	err =3D idt82p33_measure_tod_write_overhead(channel);
=20
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	err =3D _idt82p33_settime(channel, &ts);
=20
@@ -728,6 +749,11 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp=
, long scaled_ppm)
=20
 	mutex_lock(&idt82p33->reg_lock);
 	err =3D _idt82p33_adjfine(channel, scaled_ppm);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
=20
 	return err;
@@ -751,10 +777,19 @@ static int idt82p33_adjtime(struct ptp_clock_info *pt=
p, s64 delta_ns)
=20
 	if (err) {
 		mutex_unlock(&idt82p33->reg_lock);
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
 	}
=20
 	err =3D idt82p33_sync_tod(channel, true);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
=20
 	mutex_unlock(&idt82p33->reg_lock);
=20
@@ -770,6 +805,11 @@ static int idt82p33_gettime(struct ptp_clock_info *ptp=
, struct timespec64 *ts)
=20
 	mutex_lock(&idt82p33->reg_lock);
 	err =3D _idt82p33_gettime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
=20
 	return err;
@@ -785,6 +825,11 @@ static int idt82p33_settime(struct ptp_clock_info *ptp=
,
=20
 	mutex_lock(&idt82p33->reg_lock);
 	err =3D _idt82p33_settime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
=20
 	return err;
@@ -849,8 +894,13 @@ static int idt82p33_enable_channel(struct idt82p33 *id=
t82p33, u32 index)
 	channel =3D &idt82p33->channel[index];
=20
 	err =3D idt82p33_channel_init(channel, index);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	channel->idt82p33 =3D idt82p33;
=20
@@ -859,12 +909,22 @@ static int idt82p33_enable_channel(struct idt82p33 *i=
dt82p33, u32 index)
 		 "IDT 82P33 PLL%u", index);
=20
 	err =3D idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	err =3D idt82p33_enable_tod(channel);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	channel->ptp_clock =3D ptp_clock_register(&channel->caps, NULL);
=20
@@ -896,8 +956,13 @@ static int idt82p33_load_firmware(struct idt82p33 *idt=
82p33)
=20
 	err =3D request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
=20
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
=20
 	dev_dbg(&idt82p33->client->dev, "firmware size %zu bytes\n", fw->size);
=20
@@ -981,8 +1046,13 @@ static int idt82p33_probe(struct i2c_client *client,
 		for (i =3D 0; i < MAX_PHC_PLL; i++) {
 			if (idt82p33->pll_mask & (1 << i)) {
 				err =3D idt82p33_enable_channel(idt82p33, i);
-				if (err)
+				if (err) {
+					dev_err(&idt82p33->client->dev,
+						"Failed at %d in func %s!\n",
+						__LINE__,
+						__func__);
 					break;
+				}
 			}
 		}
 	} else {
--
2.7.4

