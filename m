Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6383E1D89A2
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgERUyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:54:01 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:48524 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1589835240; x=1621371240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oHivHCG3pNRPX7P/BbN1hY8rHtlIGFN+lVGSlZzGCcU=;
  b=rVXkup6anNTrsnv/B4U7UWKA2nxelRsSBEBtYQLdT0DSGS06ByOsuLLP
   vWC1tKUfWI2cghfadMv0sO8PbQjYDE+79Zfk3sCSp2/itW4ngIR8oqWbA
   /XnnqtsAoaNShKdmPf6OaLsmmtO329S8m4dSC7tTQrsiflC+zS5YzMDTR
   fm2pss3B7p8yXIz/XqjxDZjvymKyQUfZlnjCQYlgkmmo06mQqs5XMdVpP
   9tUizYyQCJVgtOEkVbtLPW41E09Z/d5CmjlwXmp8oSiaZi/+CER0L72bO
   qCmmm71ME5QnXk27KpWYV6GjseQH3Zkd8sPQ8AGv24+mXXoW6EJ1B5qx8
   Q==;
IronPort-SDR: Y6yV4dZU4zvEn9khHDtfGl9adPZ+IYl00VeGvhMEvhYk1Y2bth5WfiWrdq5CEtGa6Ze7G+MP3+
 cGAKHS8/JsMo26TLNgJvuFT86qpwd+5N+26GaYN4ZjupuLJhKAdUNIgFhyZ1B3IZjcUcZRz8Ey
 8jwiIK+dgIBKr9YFewqCs8/L8sB9H9dautMPFT4mjgGam2Pzo+VBQUrZ02r6vCupqZ6VKCcRwr
 8htzLBzt3fGnlI9s8zkySVHKcogU/MjpkQRCvJC7HVGKpbYE5FdidmQ4KNhOdTT/yEVALT1mq3
 xYw=
X-IronPort-AV: E=Sophos;i="5.73,407,1583218800"; 
   d="scan'208";a="80081737"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 May 2020 13:54:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 May 2020 13:54:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 18 May 2020 13:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRVAhXBRCTBv+wkXoEIh5J7mzsf2/4rWRvEkxYF+iIRAGmxVGGY0yKDmwkKBvEFmRwyzaTY1uQmKz5fwMY++/HRdwOoFZvZ7YMC3SaNInby75h5Ep0h7frmL9Ysog6WLL7JA3pQ+GLwwo2ycqWA48yGTu7fidSO/yUgyKnHYVdPxkbFopjyCCFfQhtPbKrBvzsxlifI4ekJiojeMCUzrr+hbnhWJgy/f4qUtPFXiyHuCM/mpZkdvY+guX2Z/c6IMctkrwTdfn6+lt1h7C4SUFx3euok2UBJLScCOTL/bXWxwDm4DS/8eFoARhn2I9++Ci3nPvEj7NXUklP25tpVEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHivHCG3pNRPX7P/BbN1hY8rHtlIGFN+lVGSlZzGCcU=;
 b=Hsu0FT4sl2BMBGHjh5Neg+xgPKLV5kMNDmB5w4R/hC1csUIXavzAvo1TzUTLbyO93BoG2f5PnjCWVXI+FsD9nArw1Wp6505rkAVzStv3zDRjOxcToZa87NhdobT2AatF++Sm7ukMxWFTQ+6V6gjQqQmgiqU8k26dwvD0bOmoQ1D+IN0EnUeXeiiMuv3IBafTxDtpXtgLVXKLpIPAGfbJMNmUlrW+W+wSW3doLjYlg7E5OqLAkWMNkUdnNYbyOAy1XH1wKhVn6WvIBokXXMzKlz5cRNem7gKXQprMXEKUVYnvUmQrxcd4yzA+EIRo8REz1S2DXGi0OTOrJ77lTJWIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHivHCG3pNRPX7P/BbN1hY8rHtlIGFN+lVGSlZzGCcU=;
 b=QyKo0hZU78MuN9Ytpv2E7qj7rPCVD1C+AvLOT5oVKtp8okdsOCan1X1s7oJ99zj+ngaWkHpBy42W92a+K5QS16C0ybQD3HWN+zLkowxN7Yri9k91sEGFknq1kemrIuWnOR1bllbPbR8qWny5lm79Bs5hX+BqC3tjfikgF7k01cE=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB4047.namprd11.prod.outlook.com (2603:10b6:208:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Mon, 18 May
 2020 20:53:50 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::c06c:6cb8:1212:e635]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::c06c:6cb8:1212:e635%7]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 20:53:50 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <rberg@berg-solutions.de>, <andrew@lunn.ch>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lan743x: Added fixed link support
Thread-Topic: [PATCH] lan743x: Added fixed link support
Thread-Index: AQHWK7euItT4wjmI40iuduJ/xUyGzKisnOkAgAAjswCAAZO6QA==
Date:   Mon, 18 May 2020 20:53:50 +0000
Message-ID: <MN2PR11MB36622C2487892C997C5CC4C4FAB80@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
 <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
In-Reply-To: <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: berg-solutions.de; dkim=none (message not signed)
 header.d=none;berg-solutions.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [68.195.34.108]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b91d80f1-48cf-4bd7-e7d4-08d7fb6d913b
x-ms-traffictypediagnostic: MN2PR11MB4047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4047212D4121982A3CE5823EFAB80@MN2PR11MB4047.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UEiHVzrO+Tx5MPvpAEfQ0bBigqVPo4z8cRyfT2QQkcb+Pj39o+MFQsQSoyt01QeNnmlyI7Sm7W5yC0drpH51/MYQXtg0rnSYcYUhyE25XL+qVGGAtjpHPmE6TC+PSfhlSpAMCpN0DZ6+1hXJd+Zmc20pczRn7rBzyyQY76HoY8MF97RJCgKo2SLqN2ComvPUPHEiDRnnm6sg6n7TRvBi0ANpWYOlnHGvh3h2SxL2FG7audFB7hqhEKJqqvl3maB+QtkUXcFaFXUp3v6xlf0bHWMX7TXbRKHQMcGiZzz+xaITyUH9JHGou43jazEeUwnFJMJ2UVr84FJubsmR+2LZI4vIVJGrNfkGN7vv+UNxbuT7f2Rt243T04gjH8l9lMdKz1FBBOmUBDEADAQWIdlTzPLb7mu/tgiJvtJ73jxla+e2LDT/hFtC7frWiQ5arA35
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(71200400001)(110136005)(478600001)(4744005)(7696005)(53546011)(6506007)(316002)(4326008)(26005)(33656002)(54906003)(66574014)(52536014)(5660300002)(2906002)(8936002)(8676002)(186003)(66476007)(66556008)(64756008)(55016002)(66446008)(66946007)(86362001)(76116006)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Zu2S7daf+CDYU2xsh3eKLwyQbK2kEQpiiE5t1J6rmJbdUEaor75WS5mpJpMZ07Ml/hCdq+G1K/C09inCN/nCEV38y79cRcdotES+FPyQtii9ipTJoDiYWzmY5upX7XB0N6l+MIJP81cTfrIqp2hYcRePVkIl9GhRXDHdWdR2HU+00nF7fHSG/UHYFdKgEpwgGt08Cw9OIEQF4Y4/d+IdXeOpI/4tQfegGfe38qD8tJOFaoPtYzDpi8HRBECRwS+jzL8Wlhk/yuAzOwHyk7BXV7twa1SmzdogVyY8idB4nasZuYd3aMFldfAbVpZ+IaZ68IjDcxH/cLNlKfbI+90WbL4N11ZOuX8z1ZprYshma719iP8DfYtfuTUC/wW2Tq5j1xz7qKat/30/eC2n+X6hiXygVAF3IFs1is373ZiPy+sGUY2kzOdtAvfjxoeWK+pWJYWPCVm945EirCRbLr48QG2zaslWxiX7Xngoo5KAOz8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b91d80f1-48cf-4bd7-e7d4-08d7fb6d913b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 20:53:50.0865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l0CK8QXFcF6bsT9tV8wDSX4zxBXhh6+P3BbOkbGBM+ftstL8LNexFbXEzvxCNkMG9z1Sm2qbghh0T2wq6S5piTGifYBFlwtW4IGb9dTw1DI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4047
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb2Vsb2YgQmVyZyA8cmJlcmdA
YmVyZy1zb2x1dGlvbnMuZGU+DQo+IFNlbnQ6IFN1bmRheSwgTWF5IDE3LCAyMDIwIDQ6NDUgUE0N
Cj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gQ2M6IEJyeWFuIFdoaXRlaGVh
ZCAtIEMyMTk1OCA8QnJ5YW4uV2hpdGVoZWFkQG1pY3JvY2hpcC5jb20+Ow0KPiBVTkdMaW51eERy
aXZlciA8VU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA8
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBr
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGxhbjc0M3g6IEFk
ZGVkIGZpeGVkIGxpbmsgc3VwcG9ydA0KPiANCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGlj
ayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUNCj4gY29udGVu
dCBpcyBzYWZlDQo+IA0KPiBUbyBFdmVyeW9uZTogSSBuZWVkIGEgdGVzdCBoYXJkd2FyZSByZWNv
bW1lbmRhdGlvbiBmb3IgYSBsYW43NDMxLzAgTklDIGluDQo+IG5vcm1hbCBtb2RlIChub3QgZml4
ZWQtbGluayBtb2RlKS4gSW4gcHJpb3IgcGF0Y2hlcyB0aGlzIHdhcyBub3QgbmVjZXNzYXJ5LA0K
PiBiZWNhdXNlIEkgd2FzIGFibGUgdG8gZW5zdXJlIDEwMCUgYmFja3dhcmRzIGNvbXBhdGliaWxp
dHkgYnkgY2FyZWZ1bCBjb2RpbmcNCj4gYWxvbmUuIEJ1dCBJIG1pZ2h0IHNvb24gY29tZSB0byBh
IHBvaW50IHdoZXJlIEkgbmVlZCB0byB0ZXN0IHBoeS1jb25uZWN0ZWQNCj4gZGV2aWNlcyBhcyB3
ZWxsLg0KDQpIaSBSb2Vsb2YsDQoNCkkgYmVsaWV2ZSBJIGNhbiBmaW5kIHRoZSBoYXJkd2FyZSBi
YWNrIGF0IHRoZSBvZmZpY2UuIEhvd2V2ZXIgYXQgdGhpcyB0aW1lLCBkdWUgdG8gdmlydXMgZmVh
cnMsIEknbSB3b3JraW5nIGZyb20gaG9tZS4NCg0KQ2FuIGhhcmR3YXJlIHRlc3Rpbmcgd2FpdCB1
bnRpbCB3ZSByZXR1cm4gdG8gdGhlIG9mZmljZT8NCg0KUmVnYXJkcywNCkJyeWFuDQoNCg==
