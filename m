Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEC050836
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfFXKO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:14:58 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:8706 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727730AbfFXKO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:14:57 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OADjcZ003210;
        Mon, 24 Jun 2019 03:14:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=PGG92Jwe85r2s+rfBND0QCvpRuKfPpVJwCiRVOzdo1s=;
 b=a16f48n1BtRQOTUWsUL2yRW7a0ooVTs2CqXOPQ6GkIBuwt0gYlG9NQ7x97jVlA6BpsOP
 AGlrKVdNdnNnfXTKVkEAHgjNtV2nZ+FXFz4pG1/BJwCWA19NgiDkIg/zfoBrLX0FfJr7
 GwJef97Lcb2YnSMSD/B6/Kt1Ypbi6JZZeNSNQJBk9omp7mfVk0Icj9v1hchLtNHNpmXW
 +wGOynSWB4Qv9vXjW8aeUg57zGYUcq471B2h+cdXu0ln7dzIB0f+KfrqsKCnQWScX1oq
 c2LVU+T2IjO+LHf+6Dc9+v6KiZxtbBm02hugICcF/mpNUDeT3Xc7np0d0OvFSfuLGD1J xA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2055.outbound.protection.outlook.com [104.47.46.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtqe4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 03:14:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGG92Jwe85r2s+rfBND0QCvpRuKfPpVJwCiRVOzdo1s=;
 b=Bz2dtP77jSBDyT5McK5KdDWnry39I92YxD2hUARswVYPRcX6GUPEZOlBzZS0/lFRMgPm/fTo+28nqbs15eyGfsMBmbWcSYOQK8VjO2eOo8m7vCm2MRuzHCtkYzqgEweue88G7oPrpDm8EQCJ7BCyskXqlfKzfPNtGlSlbDG3NpI=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2520.namprd07.prod.outlook.com (10.166.95.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 10:14:42 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 10:14:42 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY interface
Thread-Topic: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY
 interface
Thread-Index: AQHVKaVHMt019Pka20mPugoFl8ah06apBQMAgAFRdiCAADaTgIAABQ5Q
Date:   Mon, 24 Jun 2019 10:14:41 +0000
Message-ID: <CO2PR07MB24699250A3773DE76B6D2E9EC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281781-13479-1-git-send-email-pthombar@cadence.com>
 <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
 <CO2PR07MB246931C79F736F39D0523D3BC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624093533.4vhvjmqqrucq2ixf@shell.armlinux.org.uk>
In-Reply-To: <20190624093533.4vhvjmqqrucq2ixf@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1kZjMzNWQxZC05NjY4LTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcZGYzMzVkMWUtOTY2OC0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIzNTA4IiB0PSIxMzIwNTg0NDg3ODc0NTAwNjMiIGg9IitWWGFGcXVGRmZpbGlsT3BUOFl1TTJvWjFrbz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93f675ba-10e0-4b8d-731b-08d6f88cc5fa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2520;
x-ms-traffictypediagnostic: CO2PR07MB2520:
x-microsoft-antispam-prvs: <CO2PR07MB2520A9D42387576D9314CFB9C1E00@CO2PR07MB2520.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(36092001)(26005)(7736002)(81156014)(81166006)(7696005)(99286004)(8936002)(55236004)(256004)(33656002)(305945005)(76176011)(6506007)(186003)(6116002)(74316002)(486006)(73956011)(6916009)(446003)(11346002)(3846002)(229853002)(476003)(6436002)(66066001)(478600001)(5660300002)(52536014)(55016002)(102836004)(8676002)(53936002)(71200400001)(71190400001)(4326008)(6246003)(78486014)(54906003)(25786009)(76116006)(2906002)(66556008)(9686003)(86362001)(66446008)(64756008)(66476007)(14454004)(66946007)(68736007)(107886003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2520;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LNPxW90ZkRdisnwEt//o9weqCqjmALzStdxmbKoaGfxSC9H4Q4LtBuicBAf9bjWo99ms1Anm23G030A9fBlIVSpaOCak39skqYebVusiC4BQzk3wN8F74WhntcnhLDIkAttl1YBuaXDvQ3N86Pg8Afoi7V8i0jRcudQhrA9gcZZ/0I2XJ+G3OaNuADFCL7NRq0FofpFDHViltYi9hkEe2uwQ0vjLBLLT/GqjQvmKzma2G96vDGEl4QZmE32G3oFILhLWaQT72BQJq3ncyE6TNHe2WWLnDjpNw82pI8QjGIALmN1XunS0qQrGXYN+JzyI6KM/CSsSV3RRJHdomv4mzl0OTVv0feGxcw9xK4Pr8AKv1CY+SZUa+k60lK1XwVQddUvYH39KWjZV/HGALeMwqRdkX/yle/0vUZucZ8en2mg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f675ba-10e0-4b8d-731b-08d6f88cc5fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 10:14:41.9197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2520
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240086
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >I still don't think this makes much sense, splitting the interface
>> > configuration between here and below.
>> Do you mean splitting mac_config in two *_configure functions ?
>> This was done as per Andrew's suggestion to make code mode readable
>> and easy to manage by splitting MAC configuration for different interfac=
es.
>No, I mean here you disable SGMII if we're switching away from SGMII
>mode.... (note, this means there is more to come for this sentence)
Sorry, I misunderstood your original question. I think disabling old interf=
ace
and enabling new one can be done in single place. I will do this change.

>> >This will only be executed when we are not using inband mode, which
>> >basically means it's not possible to switch to SGMII in-band mode.
>> SGMII is used in default PHY mode. And above code is to program MAC to
>> select PCS and SGMII interface.
>... and here you enable it for SGMII mode, but only for non-inband
>modes.
>
>Why not:
>	if (change_interface)  {
>		if (state->interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
>			// Enable SGMII mode and PCS
>			gem_writel(bp, NCFGR, ncfgr | GEM_BIT(SGMIIEN) |
>				   GEM_BIT(PCSSEL));
>		} else {
>			// Disable SGMII mode and PCS
>			gem_writel(bp, NCFGR, ncfgr & ~(GEM_BIT(SGMIIEN)
>				   GEM_BIT(PCSSEL)));
>			// Reset PCS
>			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL)
>				   GEM_BIT(PCS_CTRL_RST));
>		}
>	}
>	if (!phylink_autoneg_inband(mode) &&
>	    (bp->speed !=3D state->speed || bp->duplex !=3D state->duplex)) {
>?
Ok

>> >> +
>> >> +		if (!interface_supported) {
>> >> +			netdev_err(dev, "Phy mode %s not supported",
>> >> +				   phy_modes(phy_mode));
>> >> +			goto err_out_free_netdev;
>> >> +		}
>> >> +
>> >>  		bp->phy_interface =3D phy_mode;
>> >> +	} else {
>> >> +		bp->phy_interface =3D phy_mode;
>> >> +	}
>> >If bp->phy_interface is PHY_INTERFACE_MODE_SGMII here, and
>> > mac_config()
>> >is called with state->interface =3D PHY_INTERFACE_MODE_SGMII, then
>> >mac_config() won't configure the MAC for the interface type - is that
>> >intentional?
>> In mac_config configure MAC for non in-band mode, there is also check fo=
r
>> speed, duplex
>> changes. bp->speed and bp->duplex are initialized to SPEED_UNKNOWN
>> and DUPLEX_UNKNOWN
>> values so it is expected that for non in band mode state contains valid =
speed
>> and duplex mode
>> which are different from *_UNKNOWN values.

>Sorry, this reply doesn't answer my question.  I'm not asking about
>bp->speed and bp->duplex.  I'm asking:
>1) why you are initialising bp->phy_interface here
>2) you to consider the impact that has on the mac_config() implementation
>  you are proposing
> because I think it's buggy.
bp->phy_interface is to store phy mode value from device tree. This is used=
 later=20
to know what phy interface user has selected for PHY-MAC. Same is used
to configure MAC correctly and based on your suggestion code is
added to handle PHY dynamically changing phy interface, in which=20
case bp->phy_interface is also updated. Though it may not be what user want=
,=20
if phy interface is totally decided by PHY and is anyway going to be differ=
ent from what user
has selected in DT, initializing it here doesn't make sense.
But in case of PHY not changing phy_interface dynamically bp->phy_interface=
 need to be
initialized with value from DT.

Regards,
Parshuram Thombare
