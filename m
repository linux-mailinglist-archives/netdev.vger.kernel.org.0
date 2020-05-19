Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88091DA440
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgESWGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:06:15 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:34445 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgESWGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1589925973; x=1621461973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8wUDUFcD2F0lXmK+1emXinBNH4uFDm2Ee41Bo5eWEns=;
  b=X/CCQOSioDxEidfW6zk3vqnbHOShZgsRCU1zShGkh23CdUpj69Gk+7LQ
   deouOWWJbwqQOUJ25b0UDL9PzNp6KZBvoHmO7CcP+uJy0lNisHn/Ppghh
   V3YeRG8xf3eCV6ud6J39vRv1oyDY/yFanvjtcxaIowDebDQGRExyMFrD/
   V9LOqCLr3kZP3lUMIi+SqpD4uwU7uEY6kGxgAGAWCWx3gyhkxQMQwHVJI
   Wx9IrYgHc1Qn+R2gPZz6xz43eq+flcSbvGJrzeCaG/6QPf8laGUuf6DOZ
   JQVDALpjVmS9sPI7hlfXtxn7+Q906ym2x89fvPSD6LPMUWh4kVsNH+KvS
   Q==;
IronPort-SDR: qzJ6Hv/1YBnsipQQqleCkoOqRe6fA2/YTPRkJZd6Rque5AFOomdFIz88xqN2fxwFjdT8+5MrSz
 jHxqMpVagknPR9WkDGVkbvgKLBDAYkujvbhzt2oPwChU0ytXZXYYgCLjE2HVvtCgQQAAu31+ij
 eNPMHo0I7q3tn06UQKA3MJFVcvKE2sPqueappkQHSs9iFGxBUMtAegni+Msk4vX3k/xE0o9w5v
 edbHxMfl6OEzCSK+eM7/i3x/2OppjaiCG9w6E3nieycfE9Nc1g6zZ1VuGUeffmeCcHneVz+4hv
 tLM=
X-IronPort-AV: E=Sophos;i="5.73,411,1583218800"; 
   d="scan'208";a="75795884"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 May 2020 15:06:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 May 2020 15:06:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Tue, 19 May 2020 15:06:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3zZMUgitvcWhE5eLmUggWXeg5ES4lEJ+Fu6rVBNo5dee8L2ryYthdKEA7EgN8uF3P9Xjp2jQEnVSRbqOzbclD6hclUC7wi+c12NF/LcExgolmOvQUkM6SP0zmzifaVJE5Uyb0GtahlTJIjzqgVKURvz3GlkCAVfa6e5pzLYWmTycwKdRg8jTYh5O6FtW4CKezSaiIcdGtxjBpq2KlyyrMKO2VFlZjnUq8XDe4b94zxQxkq32thIwLxpjxG7/WmbNDW94B2Z/ZpWLM6h4fND6OCrCKidFRRLmRX76MI77cWAL7b2i7mZhSfvvoHmq4O4VTrsvdmy98EQyEui8pGo9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wUDUFcD2F0lXmK+1emXinBNH4uFDm2Ee41Bo5eWEns=;
 b=RjS0vnv7eYi7j/uYFTkoJB5jhqGmw3fsFc69OBg8x3iZKzg1ioPv332/4zVHg/cRoBRJKLJ0ejOuGmpnAyiV2QTr8GcSgqJjKDayY7d1HZWFcthc9m0kZB6xuRbSN8bPsjMsc3aETApliWS7Y4qaXc6IURzu9BSLTwp3vQYo4BpqMJ84HVIB39Bm4WQ8mg/F4ssjKjsYKF7QiJ52K86FmBS9JeIqr6TxrsUi0Il+KifkECxSSW2m7R1U0kpYUCSIxpXD0IikIUS38ZjiwfNtkzmbSk+XyJrlyKToKj9du7lClGEfiJMTA+iDsLNonxP1pQfm7vIseMaomHNFGwMovA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wUDUFcD2F0lXmK+1emXinBNH4uFDm2Ee41Bo5eWEns=;
 b=uYNF8FTjogQTWhvDsMrRo0VHklF/GQX2RLRn81g70hHD7IM6wQ566QrGmJ/r1N3TxPSdph4pO9ZUThurImgVuND6VA5YkPN2Lv8pgXNOQzymvXtVI8TZbd0xRISw6ItSi6sukMWxU96BXcg2t+ItXgMXIkcWFaFJc+r1pIGfj+E=
Received: from MN2PR11MB4157.namprd11.prod.outlook.com (2603:10b6:208:156::21)
 by MN2PR11MB3645.namprd11.prod.outlook.com (2603:10b6:208:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Tue, 19 May
 2020 22:06:09 +0000
Received: from MN2PR11MB4157.namprd11.prod.outlook.com
 ([fe80::e118:600d:46bf:4280]) by MN2PR11MB4157.namprd11.prod.outlook.com
 ([fe80::e118:600d:46bf:4280%5]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 22:06:08 +0000
From:   <Ronnie.Kunin@microchip.com>
To:     <rberg@berg-solutions.de>, <andrew@lunn.ch>
CC:     <Bryan.Whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lan743x: Added fixed link support
Thread-Topic: [PATCH] lan743x: Added fixed link support
Thread-Index: AQHWK7eu/1knmPuQXEeZuXBI251S7KisnOkAgAAjswCAADPUAIABSdkAgAAR0oCAAVFygIAASKlg
Date:   Tue, 19 May 2020 22:06:08 +0000
Message-ID: <MN2PR11MB41574F0DBD273932271604C795B90@MN2PR11MB4157.namprd11.prod.outlook.com>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
 <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
 <20200517235026.GD610998@lunn.ch>
 <EB9FB222-D08A-464F-93C0-5885C010D582@berg-solutions.de>
 <20200518203447.GF624248@lunn.ch>
 <F241F806-3A08-4086-9739-361538FD246B@berg-solutions.de>
In-Reply-To: <F241F806-3A08-4086-9739-361538FD246B@berg-solutions.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: berg-solutions.de; dkim=none (message not signed)
 header.d=none;berg-solutions.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [68.198.153.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f835b54a-cdd5-401a-c65b-08d7fc40d5b7
x-ms-traffictypediagnostic: MN2PR11MB3645:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB364571990EDE7E290651D22595B90@MN2PR11MB3645.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: skCIQzuEYH6D6uUhVBC1mlTrN4/s9k5MHDLC2DjaMMm8sQwtM2iGLEuKK/XzB4k25gHuLQsXTz8ioW+oxXNwf/rmHWHDKKry2yIyu3a7hE44R3QksKYwbYS1v3hlXwLR7Lrdldfqkxncxn7aN7PW7BZfefd5d8Dq5J7hPF+56uBox5IQrETs6jmPXQu+rg5wshY1UfkE6VyoId1ZPYSPAa7juazUIVIYfNj/zw+0Jtx63FK304xDzYSakhPr2+Z3cYzk2cvl7NARL3HXO+FmVKZRN0/bdzWmHFd8wl5n38p/lUxZLrGJUVYKRP6euGldUCgLdGEiSm3zwv4mNoeJYEQ47JtjgGb8c+2cow80sQxqs98mHNH81DmDyBzPxocSzop/SuW6eSjfue01izKf0gKh0BP1ocaf6xTMwceOHp0a0OM+kgP+T+OpK+xTIYNA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4157.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(8936002)(71200400001)(52536014)(186003)(4326008)(86362001)(478600001)(8676002)(53546011)(26005)(66476007)(66446008)(66556008)(64756008)(6506007)(5660300002)(76116006)(66946007)(7696005)(2906002)(9686003)(316002)(110136005)(33656002)(55016002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: R38KufVPaWYpduQ8C8epSv6M8/YSLCyZHAZIsGOq7EDGy33ZiAW7N+Cpd14jNQkz2Gt3O2IElrVsGxhQLfEgTxcWrVSZ9C81jm3Zpt2uKZVXemngm6aGxv1IZGotMY/26ukCkcQ0wTBZFX8IXmiqFUbIyP0j8eF0lsWzrurDqR0enXLcsHYLs1cd3fj6MCwWvhpR2Vq35NpxVOdzgbPRd0wSLDYBeBQTGUIne9O6ricnSP3XLNXPq5SsqOar/9FYK6RCnKJ818UNae7egANmX2ynFTPNtbtSw8JL4+SEQmKS9O6kX2gGH4nQJb2XUfIaHk5KDFqjq/wXAJLuC8pAb+DAt7Usw1fqMtTISdUPlECxiNV6fUwTKxxPggV+Dt/sPDnszVoN+cnpwIYEg+i9lkvGLtqbv1u6qCLn/COh/MR2kDKTkHoWJ0pSYdKpgWEzDznT8WKOuIW+Hmms8xn1y3JsaAYg1LvuP3t5PBLmJho=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f835b54a-cdd5-401a-c65b-08d7fc40d5b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 22:06:08.9192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K27R6YnSJtfjHWChQCuSCpcyQHn3yVNBW89bkNxxakKWzTX8Pf746rCEkT4cSkAbDPumx7sj6sAEpjCfSLbRL/YQVd4MHCXOrZsXA1feDhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3645
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9lbG9mLA0KDQpZb3UgYXJlIGNvcnJlY3QgdGhhdCAiQXV0by1kZXRlY3Rpb24iIGZyb20g
dGhlIE1BQ19DUiBkb2VzIG5vdCBoYXZlIGFueXRoaW5nIHRvIGRvIHdpdGggdGhlIFBIWSBBdXRv
LW5lZ290aWF0aW9uIG9yIHdpdGggYWNjZXNzIHRvIHRoZSBQSFkncyByZWdpc3RlcnMgYmVpbmcg
ZG9uZSBieSB0aGUgTUFDIG92ZXIgTURJTy4gQXV0by1kZXRlY3Rpb24ganVzdCBhIHdheSBmb3Ig
dGhlIE1BQyB0byBhdXRvbWF0aWNhbGx5IHNldCBpdCdzIHNwZWVkIGFuZCBkdXBsZXggbW9kZSwg
ZGV0ZXJtaW5lZCBieSAqKipwYXNzaXZlbHkqKiogbG9va2luZyBhdCBzdGFuZGFyZCBSeCBSR01J
SSBzaWduYWxzIGFuZCBhdCB0aGUgc3RhdGUgKGhpZ2ggb3IgbG93KSBvZiBhIG5vbi1zdGFuZGFy
ZCAoYnV0IG9mdGVuIGF2YWlsYWJsZSAtIHRoaW5rIG9mIGEgc2lnbmFsIGRyaXZpbmcgYSBkdXBs
ZXggTEVEIGNvbWluZyBmcm9tIGEgcmVhbCBQSFkpICJkdXBsZXgiIHNpZ25hbC4gQXMgeW91IHNh
aWQgd2hlbiB1c2luZyB0aGlzIGZlYXR1cmUgdGhlIGRyaXZlci9NQ1UgZG9lcyBub3QgbmVlZCB0
byBkbyBhbnkgcmVnaXN0ZXIgYWNjZXNzIChleGNlcHQgbWF5YmUgYSBvbmUtdGltZSBpbml0IHdy
aXRlIHRvIEFEUCBpbiBNQUNfQ1IpIHRvIGtlZXAgdGhlIExBTjc0MzEgTUFDIGluIHN5bmMgd2l0
aCB3aGF0ZXZlciBzcGVlZC9kdXBsZXggdGhlIFBIWSBpcyBvcGVyYXRpbmcgYXQuDQoNClJlZ2Fy
ZGluZyB5b3VyIGNvbmNsdXNpb25zOg0KQVNEIHNob3VsZCBiZSBwcmV0dHkgc2FmZSB0byB1c2Ug
YWxsIHRoZSB0aW1lIEkgdGhpbmssIGJlY2F1c2UgaW4gYWxsIGltcGxlbWVudGF0aW9ucyB5b3Ug
dXNlIGEgTEFONzQzMSB5b3Ugd2lsbCBhbHdheXMgaGF2ZSB0aGUgc3RhbmRhcmQgUkdNSUkgUngg
c2lnbmFscyBjb21pbmcgaW4sIHNvIHRoZSBzcGVlZCBkZXRlY3Rpb24gc2hvdWxkIGFsd2F5cyBi
ZSBhY2N1cmF0ZS4NCkFERCBpcyBub3QgYSBnaXZlbiB3aWxsIGJlIHVzYWJsZSBpbiBhbGwgaW1w
bGVtZW50YXRpb25zIHRob3VnaCwgaXQgcmVsaWVzIG9uIHRoZSBleGlzdGVuY2Ugb2YgYSBzaWdu
YWwgeW91IGNhbiBpbnB1dCBpbnRvIHRoZSBMQU43NDMxIHRoYXQgd2lsbCBhY2N1cmF0ZWx5IHRl
bGwgaXQgd2hhdCB0aGUgY3VycmVudCBkdXBsZXggaXMgKDAvMTwtPmhhbGYvZnVsbDsgb3IgMC8x
PC0+ZnVsbC9oYWxmICBkb2VzIG5vdCBtYXR0ZXIsIHBvbGFyaXR5IGlzIGNvbmZpZ3VyYWJsZSku
IFRoaXMgaXMgbm90IGEgc3RhbmRhcmQgc2lnbmFsIHNvIGl0IG1heSBub3QgYmUgYXZhaWxhYmxl
Lg0KSSdkIHNheSB0aGVyZSBhcmUgdGhyZWUgY2FzZXM6IA0KCS0gSWYgdGhlIGR1cGxleCBtb2Rl
IGlzIHBlcm1hbmVudGx5IGZpeGVkIGluIHlvdXIgZGVzaWduLCB5b3UgY2FuIHVzZSBBREQ6IGp1
c3QgdGllIHRoZSBkdXBsZXggcGluIG9mIExBTjc0MzEgKGkuZS46IEtlZXAgdGhlIEFEUCA9MSBk
ZWZhdWx0IGluIE1BQ19DUjsgdGllIHRoZSBwaW4gbG93IGlmIGhhbGYgZHVwbGV4LCB0aWUgdGhl
IHBpbiBoaWdoIGlmIGZ1bGwgZHVwbGV4KQ0KCS0gSWYgeW91ciBkdXBsZXggbW9kZSBjYW4gY2hh
bmdlIGFuZCB5b3UgaGF2ZSBhIHNpZ25hbCBsaWtlIHRoaXMgYXZhaWxhYmxlIGluIHlvdXIgZGVz
aWduIHlvdSBjYW4gdXNlIEFERCwganVzdCBjb25uZWN0IHRoYXQgc2lnbmFsIHRvIHRoZSBkdXBs
ZXggcGluIG9mIExBTjc0MzEgYW5kIGNvbmZpZ3VyZSB0aGUgcHJvcGVyIEFEUCBmb3IgdGhlIHNp
Z25hbCBwb2xhcml0eSBpbiBNQUNfQ1INCgktIElmIHlvdXIgZHVwbGV4IG1vZGUgY2FuIGNoYW5n
ZSBhbmQgeW91IGRvbuKAmXQgaGF2ZSBhIHNpZ25hbCBsaWtlIHRoaXMgYXZhaWxhYmxlIGluIHlv
dXIgZGVzaWduIHlvdSBjYW5ub3QgdXNlIEFERC4gDQoNCkhvcGUgdGhpcyBoZWxwcy4NCg0KUmVn
YXJkcywNClJvbm5pZQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogUm9lbG9m
IEJlcmcgPHJiZXJnQGJlcmctc29sdXRpb25zLmRlPiANClNlbnQ6IFR1ZXNkYXksIE1heSAxOSwg
MjAyMCAxMjo0MyBQTQ0KVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCkNjOiBCcnlh
biBXaGl0ZWhlYWQgLSBDMjE5NTggPEJyeWFuLldoaXRlaGVhZEBtaWNyb2NoaXAuY29tPjsgVU5H
TGludXhEcml2ZXIgPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+OyBEYXZpZCBTLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIXSBsYW43NDN4OiBBZGRl
ZCBmaXhlZCBsaW5rIHN1cHBvcnQNCg0KRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5r
cyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZl
DQoNCkhpIEFuZHJldywNCg0KdGhhbmsgeW91IGZvciB0aGUgZXhhbXBsZSwgeW91ciBpbnB1dCBn
b3QgbWUgZnVydGhlci4gU29ycnkgaWYgbXkgZS1tYWlscyBtYWRlIHRoZSBpbXByZXNzaW9uIHRo
YXQgdGhlIE1BQyBpcyBzZW5kaW5nIE1ESU8gb24gaXRzIG93bi4gSXQgY2FuIGlzc3VlIE1ESU8g
YnV0IEkgYXNzdW1lIGl0IHdpbGwgZG8gdGhpcyBvbmx5IG9uIHJlcXVlc3Qgb2YgdGhlIE1DVS4N
Cg0KSSByZWFkIHRoZSBkYXRhIHNoZWV0cyBhZ2FpbiBhbmQgZm91bmQgd2hhdCBtaWdodCBoYXZl
IGNvbmZ1c2VkIHVzLiBUaGVyZSBpczoNCmEpIEF1dG8gTmVnb3RpYXRpb24gKFBoeS1QaHkpDQpi
KSBBdXRvbWF0aWMgU3BlZWQgRGV0ZWN0aW9uLCBBU0QgKE1hYy1QaHkpDQpjKSBBdXRvbWF0aWMg
RHVwbGV4IERldGVjdGlvbiwgQUREIChNYWMtUGh5KQ0KDQpNeSBjdXJyZW50IGh5cG90aGVzaXMg
aXM6IFdoZW4gUGh5LVBoeSBhdXRvIG5lZ290aWF0aW9uIGlzIGRvbmUsIHRoZSBBU0QgYW5kIEFE
RCBvZiB0aGUgTUFDIHdpbGwgaW1wbGljaXRseSBjYXRjaCB1cCB0aGUgbmV3IG1vZGUgb2YgdGhl
IFBoeSBvbiBhIGxvdyBsZXZlbCAoY2xvY2tzLCBwaW5zKS4gQSBkdW1iIHNpbGljb24gd291bGQg
bmVlZCB0aGUgTUNVIHRvIHJlLWNvbmZpZ3VyZSB0aGUgTUFDIGFmdGVyIE1ESU8gdG9sZCB0aGUg
TUNVIGFib3V0IGEgY2hhbmdlIGluIHRoZSBQaHkgbW9kZS4gQnV0IHRoaXMgdWx0cmEgc21hcnQg
c2lsaWNvbiB3b3VsZCBuZWl0aGVyIG5lZWQgTURJTywgbm9yIGFuIE1DVSB0byB1bmRlcnN0YW5k
IHdoYXTigJlzIGdvaW5nIG9uIG9uIHRoZSBidXNzZXMgOikNCg0KSWYgdGhpcyBoeXBvdGhlc2lz
IGlzIGNvcnJlY3QsIEkgc2hvdWxkIGNoYW5nZSBpbiB0aGUgZHJpdmVyIGFsbCBjb21tZW50cyB0
aGF0IG1lbnRpb24g4oCeYXV0byBuZWdvcmlhdGlvbuKAnCB0byDigJ5BREQsIEFTROKAnCwgYW5k
IGZ1dHVyZSByZWFkZXJzIHdpbGwgbm90IGJlIGNvbmZ1c2VkIGFueW1vcmUuDQoNCkNvbmNsdXNp
b246DQotIE1heWJlIEkgY2FuIGxlYXZlIEFTRCBhbmQgQUREIGV2ZW4gYWN0aXZlIGluIGZpeGVk
LWxpbmsgc2NlbmFyaW9zLCB3aGVuIGluIHRoZSBkZXZpY2UgdHJlZSBhbiBlbXB0eSBmaXhlZC1s
aW5rIG5vZGUgaXMgcHJlc2VudC4NCi0gQW5kIEkgbmVlZCB0byBkaXNhYmxlIEFTRCBhbmQvb3Ig
QUREIG9ubHkgaWYgc3BlZWQgYW5kL29yIGR1cGxleCBpcyBjb25maWd1cmVkIGluc2lkZSB0aGUg
Zml4ZWQtbGluayBtb2RlLg0KDQpJIG5lZWQgdG8gdmVyaWZ5IHRoaXMgaHlwb3RoZXNpcy4NCg0K
VGhhbmsgeW91IGZvciByZXZpZXdpbmcgYW5kIHNoYXJpbmcgdG9waWNzIHdlIG5lZWQgdG8gY29u
c2lkZXIsIFJvZWxvZg0KDQo+IEFtIDE4LjA1LjIwMjAgdW0gMjI6MzQgc2NocmllYiBBbmRyZXcg
THVubiA8YW5kcmV3QGx1bm4uY2g+Og0KPg0KPj4gSSBkb3VibGUgY2hlY2tlZCB0aGUgdmVuZG9y
IGRvY3VtZW50YXRpb24gYW5kIGFjY29yZGluZyB0byB0aGUgZGF0YSANCj4+IHNoZWV0IGluIHRo
aXMgZGV2aWNlIHRoZSBNQUMgZGV0ZWN0cyBzcGVlZCBhbmQgZHVwbGV4IG1vZGUuIEl0IHVzZXMg
DQo+PiBQSU5zLCB0cmFjZXMgY2xvY2tzIOKApiBBbHNvIGFjY29yZGluZyB0byBhbiBhcHBsaWNh
dGlvbiBub3RlIG9mIHRoZSANCj4+IHZlbmRvciBkdXBsZXggYW5kIHNwZWVkIGRldGVjdGlvbiBz
aG91bGQgYmUgZW5hYmxlZCBpbiB0aGUgTUFDIA0KPj4gcmVnaXN0ZXJzLg0KPg0KPiBJbiBnZW5l
cmFsLCB0aGUgTUFDIHNob3VsZCBub3QgcGVyZm9ybSBNRElPIHJlcXVlc3RzIG9uIHRoZSBQSFku
ICBUaGUgDQo+IE1BQyBoYXMgbm8gYWNjZXNzIHRvIHRoZSBtdXRleCB3aGljaCBwaHlsaWIgdXNl
cnMuIFNvIGlmIHRoZSBNQUMgDQo+IGRpcmVjdGx5IGFjY2Vzc2VzIHJlZ2lzdGVycyBpbiB0aGUg
UEhZLCBpdCBjb3VsZCBkbyBpdCBhdCB0aGUgd3JvbmcgDQo+IHRpbWUsIHdoZW4gdGhlIFBIWSBk
cml2ZXIgaXMgYWN0aXZlLg0KPg0KPiBUaGlzIGNhbiBiZSBwYXJ0aWN1bGFybHkgYmFkIHdoZW4g
TWFydmVsbCBQSFlzIGFyZSB1c2VkLiBUaGV5IGhhdmUgDQo+IHBhZ2VkIHJlZ2lzdGVycy4gT25l
IGV4YW1wbGUgaXMgdGhlIHBhZ2Ugd2l0aCB0aGUgdGVtcGVyYXR1cmUgc2Vuc29yLg0KPiBUaGlz
IGNhbiBiZSBzZWxlY3RlZCBkdWUgdG8gYSByZWFkIG9uIHRoZSBod21vbiBkZXZpY2UuIElmIHRo
ZSBNQUMgDQo+IHRyaWVkIHRvIHJlYWQgdGhlIHNwZWVkL2R1cGxleCB3aGljaCB0aGUgdGVtcGVy
YXR1cmUgc2Vuc29yIGlzIA0KPiBzZWxlY3RlZCwgaXQgd291bGQgd3JvbmdseSByZWFkIHRoZSB0
ZW1wZXJhdHVyZSBzZW5zb3IgcmVnaXN0ZXJzLCBub3QgDQo+IHRoZSBsaW5rIHN0YXRlLg0KPg0K
PiBUaGVyZSBpcyBubyBuZWVkIGZvciB0aGUgTUFDIHRvIGRpcmVjdGx5IGFjY2VzcyB0aGUgUEhZ
LiBJdCB3aWxsIGdldCANCj4gdG9sZCB3aGF0IHRoZSByZXN1bHQgb2YgYXV0by1uZWcgaXMuIFNv
IHBsZWFzZSB0dXJuIHRoaXMgb2ZmIGFsbCB0aGUgDQo+IHRpbWUuDQo+DQo+ICAgICAgIEFuZHJl
dw0KPg0KDQo=
