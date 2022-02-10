Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006DF4B11B2
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbiBJPaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:30:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243625AbiBJPaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:30:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB83248
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644507020; x=1676043020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p00F8iOSheAr2UYmpnTL719YVFSElgK9bSibnx9N95U=;
  b=Va/wfRldemFOPxROZI/oopmeGLPyET+xXp5oTFYhcc0uEie28QuRWhjz
   AP/2HQ/4vM11Z6Mo/YqD56nH9lulEsh84l7oJNxUBEbXFZy2m5mWfaUqM
   wISA2UGoT0+xnzJHiI3fZTo2dYW5ZLVyNaN/nLB19Y5RC32r1DcZ8+SBG
   sGWR5ZxiPATaGGbwdNTa+8Mm6Rp75jQ5/nZNuAUn0+GeqPkqmYlRdW+sF
   nrxrx+FuisoUEAXIyj+ab5KQmpTV7mlw/peiq0hPDX5PsnSEWmFAHx94C
   WfUpMO79F9AeqaWfJpC+KyuRjdOeGnpeIbnJOnikLrbzk2MgNkK/o9Tsg
   Q==;
IronPort-SDR: vBkuVmiCOSmZsqwJPUERQxlXkI+uIbDvlQD9rdLiHpJNNHw6SkpEfSloUsA+7Rd/3vJYXXzCUl
 sT22hDVr2bfQEyQ2fCU+CYPaM8dL6uPhvuuNyhQPL5y3gdT7uWmuLxYXuFkX3izJRigRvHHeR8
 Iw57Lt1f7KPOyGxTukzpc274vt8iIGGmtHQkAttl5h5JRLkCZ8QZXfnYEIOEwCtIN4xA8ESRgS
 HrxJO5ELZ98mwn43V3WwCw2ZBRM0dy1wFi9bfdK7QHWsepnsnRKo94pJNxYc3LywCxxX9kZz1P
 lLosVHBSVF3oo0HQKyUwCo07
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="153147553"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2022 08:30:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Feb 2022 08:30:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 10 Feb 2022 08:30:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8H6jLLIWEonMxjY1FUTKoqGvyUUD9KPhgX/w5KgtecREkz+BrpIaiW/n3Ic8XfXYMaVnstz75bKcCfl/LkbxhJxpqgXgXjNVa0XugvlQ7kL1lrPqrLh0kpiCOHHzszJTE+Dz5l3SrlqvZv2L4ef0RnsLEM1HWyjDm7lDeRdnxcuO4ufKcYlaD+1Nua2zThaWuni92OvpEsnbpgStXNWdbyXvCEaOG3iDXbt2eudSoT/ymollA7IW4KPDXe2AWBKpAktIWDSymr6nStKiGP2ZEsoKR9ysX/14Em7eL631LLH5rqfPokvNbue92Dqwi0SM6srQNI6S+PeElY/OxnV1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p00F8iOSheAr2UYmpnTL719YVFSElgK9bSibnx9N95U=;
 b=YWrSi1EGGdqHtQnWtFiCnLpYD/o1HxGm220TU1mvzRBgb0VJpyuSmcnk/+pl05K5EhlU9FhCUY7+JgXYIZvvdsk932oFNezb7qme845GeF4PbsHZUJxS15ozmpseSf9Myny8bl47zcQr1vUSa2zJ5PtJecuIqjj0m1pLwmumM7Ggf7SJMqlyhw+brgNvmja9QNDb0css6bd9vO/eN6QXhCTIkWdAuZ/MBDygY1tes9/9KoQv8Ek0Rs92GESwXdxYorYWDbHi9WRe9QNX0I1nfyzEiEGJ2MQBY8tuKPpihEo6Wmd1Cy2iahe/LGlYFf3rBHn7paOrKRvo9JMcjLWaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p00F8iOSheAr2UYmpnTL719YVFSElgK9bSibnx9N95U=;
 b=okgTpk6t1xJB3eHrEWpYXn58tN0a2K7cFb69M9Lzrcyd1TgL/6Zvc/6W63N0fMSVXwtfHNgdyjjbOAM2kdgq9wh2bdKdycCQtAc1LrVL4G8vmPmMa/Rry3CfxG7RR2t8ZZEq8kcOU6fNKqTa1+15YJM6Z3ZC5Gffxk0Pyp1uznQ=
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SA2PR11MB5132.namprd11.prod.outlook.com (2603:10b6:806:11a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Thu, 10 Feb
 2022 15:30:17 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::b9cf:9108:ae17:5f96]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::b9cf:9108:ae17:5f96%3]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 15:30:17 +0000
From:   <Prasanna.VengateshanVaradharajan@microchip.com>
To:     <enguerrand.de-ribaucourt@savoirfairelinux.com>, <andrew@lunn.ch>
CC:     <Vlad.Lyalikov@microchip.com>, <Sundararaman.H@microchip.com>,
        <Lars.Povlsen@microchip.com>, <Yuiko.Oshino@microchip.com>,
        <Allan.Nielsen@microchip.com>, <netdev@vger.kernel.org>,
        <David.Cai@microchip.com>, <Joergen.Andreasen@microchip.com>,
        <Scott.Kasten@microchip.com>, <Horatiu.Vultur@microchip.com>,
        <Nisar.Sayed@microchip.com>, <Arun.Ramadoss@microchip.com>,
        <Divya.Koppera@microchip.com>, <linux@armlinux.org.uk>,
        <Kavyasree.Kotagiri@microchip.com>,
        <Balaje.Rajasundaram@microchip.com>, <hkallweit1@gmail.com>,
        <Prasanna.VengateshanVaradharajan@microchip.com>,
        <john.oleary@microchip.com>, <Bryan.Whitehead@microchip.com>,
        <Raju.Lakkaraju@microchip.com>, <Ravi.Hegde@microchip.com>,
        <Woojung.Huh@microchip.com>, <Sukanya.Palanisami@microchip.com>,
        <Ronnie.Kunin@microchip.com>, <Tristram.Ha@microchip.com>,
        <Antoine.Sebert@microchip.com>,
        <Selvakannan.Murugesan@microchip.com>,
        <Steen.Hegelund@microchip.com>, <Sushovan.Ranjanroy@microchip.com>,
        <Bjarni.Jonasson@microchip.com>, <John.Haechten@microchip.com>,
        <Andre.Edich@microchip.com>,
        <Pandiselvan.Soundrapandian@microchip.com>
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Thread-Topic: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Thread-Index: AQHYHO267iebaZNvCk2PCKSscj7+r6yM7FiA
Date:   Thu, 10 Feb 2022 15:30:16 +0000
Message-ID: <42ea108673200b3076d1b4f8d1fcb221b42d8e32.camel@microchip.com>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
         <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
         <YgGrNWeq6A7Rw3zG@lunn.ch>
         <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com>
         <YgJshWvkCQLoGuNX@lunn.ch>
In-Reply-To: <YgJshWvkCQLoGuNX@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c8a1d49-fdbf-4248-626a-08d9ecaa3db3
x-ms-traffictypediagnostic: SA2PR11MB5132:EE_
x-microsoft-antispam-prvs: <SA2PR11MB51324C8760800BD9944B2D14822F9@SA2PR11MB5132.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hUdIERsts+EmYXTnWz/e2W7qFx9WwBvQJ3u37QF6LpHIpk6JGBcb/wm3qIUC5zlJ73/wPF3PA4kDIPz5T/Nka17qGEtpSa0/XQczn2fxvRTZ6O/vJa+6LZ4jm35FlhniZ7gCJ/S4DsSWVruGd6UwevlkSIuCsXQGDQ1Emh8HAAM2AHEfCMuBJnMSKtvi6gO1zuchxzMwYALI6CPYMMGHGP9LbU8yeXg0dzzB2eaIhjA0zpX/uMFrepafyEaJU1PRKFqRUCni0F3jdg8cm82SMcFHE0jThDdPquC2PL+3t40nIUJ7VeIylTXD3xqz4O5c+l1klhnRbOC42dPx7pIoxeAHqH4XsZdnljhsVaR5mO5n+WdN6oYFY24VhFBo45Dp9gSt/sv6gMjhBRp5OfsolCCbPS6+G0vCqVRHBiiO2Vppdey5wX9MHRbXur6axcBqyY2Up6aMsKz/EqUQEafN6tefsyH/aeF6gjVxblyHhaeQ+U3sYKTXlhCcz/r26IAT8jXkA+ngH8rZS8zE4YQzwdHNKPYBVLziqJoU95d8ti3myTPkZSUVMRUl/K9YdDZ7X/8CvbeIy7kMPf3U7Y/eT1XLuAcPfm9Tas8TQe/dT+mO2gVw74lvStOXfpuIeOm0/Q2UgJYyz/ODvgQyakhzp+dBYzy1RAV2u8OyVZmDVejSAn3uUoDhvrQ8N6e1YmOpNHA1BbwVwmsN8hI0JkHoqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(508600001)(316002)(71200400001)(26005)(186003)(54906003)(8936002)(36756003)(6512007)(6486002)(5660300002)(38070700005)(64756008)(66556008)(66476007)(66446008)(91956017)(2906002)(2616005)(122000001)(4326008)(6506007)(8676002)(83380400001)(38100700002)(86362001)(107886003)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWpyRlNjSkJYZmNFZlN6UnZRR0VEUHJvSGowYkNyYW5vOVNCdFVlUjVvSWlq?=
 =?utf-8?B?amZRT2Vpd0JiKy92N3k2SVpzUXJ5NG1DNDkzU1QvY291RGpBcXhmMVRhWFhK?=
 =?utf-8?B?ODd1SEFxbWFkc0JaeVVWOEU4Tnp6aTkyaHdZQWc1Q2NKcVF2TzdKUHVWYWhp?=
 =?utf-8?B?WjFCZFpCUURGa0lpOEdUTzRkUXo1bzhnVm9HdWxSdWNZNit2OHR0Qk9YU2JI?=
 =?utf-8?B?endjQyt5RDNyRnU0WGt2L3FQOHJRWFlMVGJrRTZaLzlCYm5Qemg0NmJlQlpO?=
 =?utf-8?B?amNxUzZRNkdpOUNQVkJkcU8rQkVkSWhWU0xyeHFVVS9PbnNyZHFERnEzMHBu?=
 =?utf-8?B?YTJ3WUpETWwvYWsyQjZTOU9Pd2hGWnQ1ci9TdkkvakppZVZvSVdKWmR1YWc4?=
 =?utf-8?B?QzRZazJNd1A1SjZhY3V1NzA1QmlWT2F1NHVLQnJ2cnlkQU52OGtEYVliYjdN?=
 =?utf-8?B?eUtCYkY4ZWdWK2g5VzdjNEZBd25tQmJSTTduQXNNeEVHRDhFL2dXR2hwWXRz?=
 =?utf-8?B?TGRHeEZ3YTJZUnlta21RWmt1S2xTZVloTG04TzAvRWpmdXU3UWVHdmxGZzhn?=
 =?utf-8?B?K2JLS3MwU2psU2lxanM3b3owN3dtR1ExME92SFU0dHZ0RVdqK1ZMZUovN3Jr?=
 =?utf-8?B?N2FLYmRuQnZSdUhRMnVLakxrdlNWK1BscVg3MTJqZWJkWmM0em5xam9jUWFC?=
 =?utf-8?B?QWZ0Ykt2QzBHMGJyRkozbkhsdlpyU1B4NS9QTFV2UnlBR2xIR3ZqdXF4RmR0?=
 =?utf-8?B?cVZQRWhSSGlvYXhIUng0dlBsRXNuMnhSanNMWFE0bGVTQUJERU9wVWtKK0Ft?=
 =?utf-8?B?UzJ5RUpvNzE3dVhYdXVMdjc4dXF1YzVrODBiU2VaemlFY3dPcmNTV283cUJC?=
 =?utf-8?B?TCtLeDJGem5sMEdMTW42UXlGL2lzVlZ0MjNuVHhtbmYwVkN2bkdIOVdFT0Zv?=
 =?utf-8?B?Z1Q2WjVkWW9XTTRjVFJSUndLR0I5SXY5Y29HaW54SGdUeWV2L3JwdG03c0Vy?=
 =?utf-8?B?bGE2RjUxdWNnVnJVYmZwSVhjUEJpQmUyMjFKbU5rSUQzYWdjZG9UN2pTeCs2?=
 =?utf-8?B?WjI2bDNwZWlMQkc2SWsyWU10WnEwUC9WV2dNbUdGMWVMUVByVlZVSjdEZUpY?=
 =?utf-8?B?QThORzFhRHNGRHR6RHFVditMVjlERXM3Y1NrMHkrRmNLVWRkTVV6aXpwOS9x?=
 =?utf-8?B?UlZyOEdYZ29MSXpVT3AvMmx3dVcxempqUm9aVHBHNlg1OUtramc0bnVNZlpT?=
 =?utf-8?B?ZHA1SzZzOTFydm9xVUk2YWNwb0hKZlhzTjRLdTkvbGJaSDdWUUtzcG1aVEpN?=
 =?utf-8?B?ZkpEWXlCMjRPeEhpcTEwdUMxS3VSekhwNnd6WXRpYk5nZ0tUMXRDc2JIN3JB?=
 =?utf-8?B?VUZiRSt5YUcrdUVlMFFBd0IyK1JyMHRJTjB1QVV0dlpkNEN5dGdyYnNqb3Rn?=
 =?utf-8?B?M21kYTdXUlkvbyt4d24reElZOGtPYjdSbjVWKzN0UDVFMEgzYXBSalkrSnMr?=
 =?utf-8?B?TkdxV2F5dFcvN2Q1UGZZZHdNRkt3eWJrMUQxeEJGbnF6VVNmcDBzMDl6Rytn?=
 =?utf-8?B?aStHSkNtYmhiWExvbUJSMVRDTjgzaXZaMEw1K21wWGpzSFdTQUo2Y3lVRlRr?=
 =?utf-8?B?bFUwS2RBL1ZGL0ZuQ3lMTGgrMHVCMTAwMGFheVpFNE5aeXpxczQxYi85dEFU?=
 =?utf-8?B?Z1pqSmRaS2YydVZmSnQxRXROeUNmSmdRamxDcnhJL3RiV0VUUWMwN041Rndl?=
 =?utf-8?B?L25rRmNPSFBicmJnOVNYYjBNRzBmSlhYRURqczRIUHUyQ3FSNW56V0NaZ0VE?=
 =?utf-8?B?Tm16MDhPUnhmMVd6T3ZaVnB4OEdvWERDYWRiOTRJS3BuejQ4M2pub3NiUzh4?=
 =?utf-8?B?WWdpWVJXYXVTdS9DRU1MazhuaDQ4SzVwenJYbkdVY0x5Uyt6MmRtREttSXVS?=
 =?utf-8?B?dUdQWk1YdUFjNjNSd0FDMzBPTC9lNWlsZjZUcWZ6OUVGOGU5ODhxTzhOeFJE?=
 =?utf-8?B?KzgyR1NUcmlycTRnRHYwQ2dQR09KdnMway82RlJkUW94KzVFSlVOMDluTjZM?=
 =?utf-8?B?d2xabVRHWUVYL2tCU2tuMXl6Y0hFL2JiL1JIVStUQ0NrN1N2NE4zR1dITTZH?=
 =?utf-8?B?cnFwSFZMY0IyRXV1dVJ4MlpROU9DdG83c25HS00ramFRNm1FL05UaythQ0RN?=
 =?utf-8?B?RGIyRDl0UEc3d2lLb3N4RGNWUk9iU0JXNE5NaVNPcUtWQm1VUFQyK1pqYjhH?=
 =?utf-8?B?NFE2akZ0c3dTU09seWkyd3Zoc3pwc1ZJVlFXaWlBUVB1aS9vZnJEV2dnd0I1?=
 =?utf-8?B?a3hFdzBnaDJHci81M1BNeG5oUHg5VjVnVjJsbk9yeDYrSGp2SURrQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C88AFBB4A065A947A4866592C673B588@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8a1d49-fdbf-4248-626a-08d9ecaa3db3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 15:30:17.1991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joCl5bTmEFgEZp5oB1m+jMXZIgmPDpqoG18LcYgCz5UM5pnL05SpCQOZE1DLiV1/xWZ/u6m7kFEDajDsRwyPK9ot36Vfo4OG3+IsBERtbnYpe+E9Z05A62rsTjIXcKzZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5132
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAyLTA4IGF0IDE0OjEzICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUdWUsIEZlYiAw
OCwgMjAyMiBhdCAwMzozODo0MUFNIC0wNTAwLCBFbmd1ZXJyYW5kIGRlIFJpYmF1Y291cnQgd3Jv
dGU6DQo+ID4gLS0tLS0gT3JpZ2luYWwgTWVzc2FnZSAtLS0tLQ0KPiA+ID4gRnJvbTogIkFuZHJl
dyBMdW5uIiA8YW5kcmV3QGx1bm4uY2g+DQo+ID4gPiBUbzogIkVuZ3VlcnJhbmQgZGUgUmliYXVj
b3VydCIgPCANCj4gPiA+IGVuZ3VlcnJhbmQuZGUtcmliYXVjb3VydEBzYXZvaXJmYWlyZWxpbnV4
LmNvbT4NCj4gPiA+IENjOiAibmV0ZGV2IiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4sICJoa2Fs
bHdlaXQxIg0KPiA+ID4gPGhrYWxsd2VpdDFAZ21haWwuY29tPiwgImxpbnV4IiA8bGludXhAYXJt
bGludXgub3JnLnVrPg0KPiA+ID4gU2VudDogVHVlc2RheSwgRmVicnVhcnkgOCwgMjAyMiAxMjoy
ODo1MyBBTQ0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAxLzJdIG5ldDogcGh5OiBtaWNy
ZWw6IGFkZCBNaWNyb2NoaXAgS1NaIDk4OTcNCj4gPiA+IFN3aXRjaCBQSFkgc3VwcG9ydA0KPiA+
IA0KPiA+ID4gPiArIC8qIEtTWjgwODFBMy9LU1o4MDkxUjEgUEhZIGFuZCBLU1o5ODk3IHN3aXRj
aCBzaGFyZSB0aGUgc2FtZQ0KPiA+ID4gPiArICogZXhhY3QgUEhZIElELiBIb3dldmVyLCB0aGV5
IGNhbiBiZSB0b2xkIGFwYXJ0IGJ5IHRoZSBkZWZhdWx0IHZhbHVlDQo+ID4gPiA+ICsgKiBvZiB0
aGUgTEVEIG1vZGUuIEl0IGlzIDAgZm9yIHRoZSBQSFksIGFuZCAxIGZvciB0aGUgc3dpdGNoLg0K
PiA+ID4gPiArICovDQo+ID4gPiA+ICsgcmV0ICY9IChNSUNSRUxfS1NaODA4MV9DVFJMMl9MRURf
TU9ERTAgfA0KPiA+ID4gPiBNSUNSRUxfS1NaODA4MV9DVFJMMl9MRURfTU9ERTEpOw0KPiA+ID4g
PiArIGlmICgha3N6XzgwODEpDQo+ID4gPiA+ICsgcmV0dXJuIHJldDsNCj4gPiA+ID4gKyBlbHNl
DQo+ID4gPiA+ICsgcmV0dXJuICFyZXQ7DQo+ID4gDQo+ID4gPiBXaGF0IGV4YWN0bHkgZG9lcyBN
SUNSRUxfS1NaODA4MV9DVFJMMl9MRURfTU9ERTAgYW5kDQo+ID4gPiBNSUNSRUxfS1NaODA4MV9D
VFJMMl9MRURfTU9ERTEgbWVhbj8gV2UgaGF2ZSB0byBiZSBjYXJlZnVsIGluIHRoYXQNCj4gPiA+
IHRoZXJlIGNvdWxkIGJlIHVzZSBjYXNlcyB3aGljaCBhY3R1YWxseSB3YW50cyB0byBjb25maWd1
cmUgdGhlDQo+ID4gPiBMRURzLiBUaGVyZSBoYXZlIGJlZW4gcmVjZW50IGRpc2N1c3Npb25zIGZv
ciB0d28gb3RoZXIgUEhZcyByZWNlbnRseQ0KPiA+ID4gd2hlcmUgdGhlIGJvb3Rsb2FkZXIgaXMg
Y29uZmlndXJpbmcgdGhlIExFRHMsIHRvIHNvbWV0aGluZyBvdGhlciB0aGFuDQo+ID4gPiB0aGVp
ciBkZWZhdWx0IHZhbHVlLg0KPiA+IA0KPiA+IFRob3NlIHJlZ2lzdGVycyBjb25maWd1cmUgdGhl
IExFRCBNb2RlIGFjY29yZGluZyB0byB0aGUgS1NaODA4MSBkYXRhc2hlZXQ6DQo+ID4gWzAwXSA9
IExFRDE6IFNwZWVkIExFRDA6IExpbmsvQWN0aXZpdHkNCj4gPiBbMDFdID0gTEVEMTogQWN0aXZp
dHkgTEVEMDogTGluaw0KPiA+IFsxMF0sIFsxMV0gPSBSZXNlcnZlZA0KPiA+IGRlZmF1bHQgdmFs
dWUgaXMgWzAwXS4NCj4gPiANCj4gPiBJbmRlZWQsIGlmIHRoZSBib290bG9hZGVyIGNoYW5nZXMg
dGhlbSwgd2Ugd291bGQgbWF0Y2ggdGhlIHdyb25nDQo+ID4gZGV2aWNlLiBIb3dldmVyLCBJIGNs
b3NlbHkgZXhhbWluZWQgYWxsIHRoZSByZWdpc3RlcnMsIGFuZCB0aGVyZSBpcyBubw0KPiA+IHJl
YWQtb25seSBiaXQgdGhhdCB3ZSBjYW4gdXNlIHRvIGRpZmZlcmVudGlhdGUgYm90aCBtb2RlbHMu
IFRoZQ0KPiA+IExFRCBtb2RlIGJpdHMgYXJlIHRoZSBvbmx5IG9uZXMgdGhhdCBoYXZlIGEgZGlm
ZmVyZW50IGRlZmF1bHQgdmFsdWUgb24gdGhlDQo+ID4gS1NaODA4MTogWzAwXSBhbmQgdGhlIEtT
Wjk4OTc6IFswMV0uIEFsc28sIHRoZSBSTUlJIHJlZ2lzdGVycyBhcmUgbm90DQo+ID4gZG9jdW1l
bnRlZCBpbiB0aGUgS1NaOTg5NyBkYXRhc2hlZXQgc28gdGhhdCB2YWx1ZSBpcyBub3QgZ3VhcmFu
dGVlZCB0bw0KPiA+IGJlIFswMV0gZXZlbiB0aG91Z2ggdGhhdCdzIHdoYXQgSSBvYnNlcnZlZC4N
Cj4gPiANCj4gPiBEbyB5b3UgdGhpbmsgd2Ugc2hvdWxkIGZpbmQgYW5vdGhlciB3YXkgdG8gbWF0
Y2ggS1NaODA4MSBhbmQgS1NaOTg5Nz8NCj4gPiBUaGUgZ29vZCBuZXdzIGlzIHRoYXQgSSdtIG5v
dyBjb25maWRlbnQgYWJvdXQgdGhlIHBoeV9pZCBlbWl0dGVkIGJ5DQo+ID4gYm90aCBtb2RlbHMu
DQo+IA0KPiBMZXRzIHRyeSBhc2tpbmcgUHJhc2FubmEgVmVuZ2F0ZXNoYW4sIHdobyBpcyB3b3Jr
aW5nIG9uIG90aGVyDQo+IE1pY3JvY2hpcCBzd2l0Y2hlcyBhbmQgUEhZcyBhdCBNaWNyb2NoaXAu
DQo+IA0KPiDCoMKgwqDCoCBBbmRyZXcNCg0KSSBoYXZlIGFscmVhZHkgZm9yd2FyZGVkIHRvIHRo
ZSB0ZWFtIHdobyB3b3JrZWQgb24gdGhlIEtTWjk4OTcgUEhZIGFuZCBhZGRlZA0KaGVyZSAocGFy
dCBvZiBVTkdMaW51eERyaXZlcikuDQoNClByYXNhbm5hIFYNCg0K
