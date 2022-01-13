Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040ED48D355
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiAMIEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:04:11 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:7478 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiAMIEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:04:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642061050; x=1673597050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kAYgdBkE7F64EMzrWFxZaAUZYaT/zKJGiCWjQBJ3D9A=;
  b=b8647n6nTYXE05HxhEmlg/4cDftK9zQOiDhlv+qzTHXs3Ikjqn8QGNIz
   eXpKuT4W/Qk4NoX09HTJ/i0y8HB5xcOAcKgmC9eF5bCIwn24jQKRYhJX2
   uWQeG/fkwBi1kQciHp+u1d1COD7yC0vNpiZGR6f0bphjI0MkBuFguoeJB
   35XlP0Gt2mApPcbVFYzO46KFHyq39Nl+qxgEVg4hl66UsG3X0hoaIGahr
   R0OQGKkdWaFaa3CCkQTwrSEUPBXLdDxD2VLM6n4f+ypM7CD475FcV90nw
   Z5TDqyU+QghdQ3d9LzzUO33RuRPfF41FyiUm8gsa6qFrGiIQYufwSlVdr
   A==;
IronPort-SDR: HwML2dBt9D41Q9a80o59sY1i0qhnchOlVkghiw3nmrIi9dcgGGt+Ip5NhdFDCKcWW3rdeoTjRB
 ZP+02LJhSzAm7tlf9m1QPKxXBrCL7bB9QJgQ3VPq2CMaqnsPnEJqgzDcfiO5BMejgmYOFlcCkz
 D7EkwaZ6uoDQFxfPDxW+nTQgtLFOMzUV6QgPKv3aJ/Wx9gJU+2B0zgqU/SKS2Id3fpc10mBxjE
 u0IC6RAItXm2BevtRcW996fmyKwYiC1iOjrIeIL2JBezW67NfpU9gO18De2T2u3AuXpfSOnXN1
 xOQ3YUtQCRseWpBpTWZNJlC2
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="82352610"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2022 01:04:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 13 Jan 2022 01:04:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 13 Jan 2022 01:04:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdrDb68OVZe6irrke6ML+hFwXPtb13fR/Txq1B5TnX7LZRZ7TMAXukuLHvZzlf9wOE0vzD9cemC+4xtKBYbWeoMwdih5TXULk5JMQz+m70aE/v09ySe+L2ppXvSZfgl8/Qq4SApMx+o8Oo5gnw264X3be+B+mA9hUjVGjnF9hyazvmNPnQ2H7ZAvtiuTNAHjcFx7pE5/wCAK9qU/NRQoEYMqZK1c5Vl5iWmhQWIS61FKpTUziFsfrpLeyOEq+BEeMuvrFiFmgVdZB/6kp0tyFK4Wy8vMM9OM5c8FNLH7jID/L8P6ucn3okixeLLctZBnLWRy4eS49NimdbgTgQS8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAYgdBkE7F64EMzrWFxZaAUZYaT/zKJGiCWjQBJ3D9A=;
 b=HV9MN03cBJhmSyJHxHoMPGYzmyl9tGFq8arxueBgJ/Zg3Ru6Usx+BUh49USSR7+GX7LQwkAHFlMLY0ILJdbDUkpCO+wgIe66fBt/xMKp0nNSIjvVmFRSfJj2vrYHiyEJ83+9T0NMxLIQiMesLlr8LjCMkV0+YPnMCzxUGYsJ3ENUEeugpDxUl6+tjRetz6YTAPY9ocumvD0Pb7OIrqXxmP/Hbuo4l0xbgY96Zjwghbbr0wBZkjPFBHYDzL4VqYLkGwPIBy0KiLVMOiae+hc8lMJdHj7Irev66PI6lCagOzgfzyxYJ84iINPdzybReQM1FdmRQQaoZNa3U27a5iTXfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAYgdBkE7F64EMzrWFxZaAUZYaT/zKJGiCWjQBJ3D9A=;
 b=bieaV2IGKnmzsIrgaNeEa+pJalwGZGg9V3GRiqlcHgMWrbvu39i+3aC5ZG1uSdbxr8ZBF3jz8C9zFEuZ0Cy63hmNQnfeicuwjCGXhlacTO+4Tk7Jv+9GYCaR/TnPdz1XP5V0doB2rKcBWDNhnX7iIiCJ9NB3nxjvICVxH7GvGbo=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:04:04 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::5cae:e802:4a48:bd0f]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::5cae:e802:4a48:bd0f%6]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:04:04 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <robert.hancock@calian.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Topic: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Index: AQHYCFQf+ogmKXtGzkKzdl2V3vDvkg==
Date:   Thu, 13 Jan 2022 08:04:04 +0000
Message-ID: <480dc506-5480-245a-97a9-9aaa51d81995@microchip.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
 <20220112181113.875567-3-robert.hancock@calian.com>
In-Reply-To: <20220112181113.875567-3-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5ba926a-16df-4af9-afd8-08d9d66b442a
x-ms-traffictypediagnostic: SJ0PR11MB4816:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB48165431EB8D53BC32B060F287539@SJ0PR11MB4816.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mGLxwd9qkSCSI5SOhO9x1TArfGA9+MToY6E9krdNSi2alfh9bshNl8aKUjf3dv6arwQo7aaNu7gkBcaiB4hjQfNHK4M5mE2/Sj5O/Xj9IYhmNOa986DC3/A7zJizIl28fKCN1Bv+YSuwTsun1bd9DtFYPFSuZHbDfrKyJixG6G+AGpDCdPF43Gf1l3qmU8Zi6u3XoU/mtuqsCRasdcQcAxpka/xS42Ahw+g8vlIKAyRS97DvjVuolTP8+nLL+y7/LddxhlsNhTHHnuWA4LAp+gDsMcdZcI0VUOT+m7VcehN9UelMTryB8iThepGCdpSeY4zTNLBvyfzOiF/mfAk0JBvsKR1No/ULcT4aLOdo4Jpl4g3ZicR2+JXZMYAZWSXbIwY3sNZtHW4QL61xq9jKPBRI22sTJxUNwTy6xySGd3veQs6hpizp/dewJudwa4XdTDhdnwFijMzt2BF0jLOvBNTYBeU1xu9P6ibXVzcl+Qi+7pUFSF5PevVwFSKFjZCHw6aNCNuKmwLWcbeh38tZ+uKtJ/tMt2vpCZdXU38S4YPoB7D6TwEh/btUm8y1ibVycWzmhP7IFxspVjQDT5sqpL5GLIYKvBFLTezxd7AhKDS4MJ/pnzpITN6hb93EEsy2zqyB66y5VlWheKBCIdz5m/HtjfGc4vRcTkrdJ6kl+lCCv9N53tLa60Izg4Ee8ap0l7WR7YWpc4k29xexR7DboiFIxpvcLptqkFmsRAx9Z7sOsaOWQGxEcHuJ5F0yNvhh4LWIMf6CrI9XDWMSBJJznA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(66556008)(64756008)(4326008)(86362001)(31696002)(122000001)(8936002)(66476007)(31686004)(76116006)(8676002)(66946007)(91956017)(38070700005)(38100700002)(6486002)(2906002)(83380400001)(110136005)(316002)(54906003)(6506007)(186003)(6512007)(26005)(71200400001)(53546011)(36756003)(508600001)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEh6eEptME9PUXBRL2FjdDhYMlNiME5yOTZWclBQZ2lsZGpycE1HTklEV25y?=
 =?utf-8?B?cXdKSk1IRlJuWHUzZ2V5clFZNGJSejI5eTZxcVpDYzJTUlU1QjgzRlkrRnJp?=
 =?utf-8?B?MVZMYXZUeFhJL0xHZXVVcWxDZUtjTjdhMy9BeWJaU0dKSXl2YVVTSkZzSW5Y?=
 =?utf-8?B?YmhwK3NpNWh6N244RDRpUjZCODd3QkFFb0ZPVGNkM2xYckk2UEdzQVYrSG5D?=
 =?utf-8?B?Rk1uZjVQM2N5NXgyRUROZkFrZDRJaUY5YXhoVTdRWXl2d3lhVFBGWERHMldB?=
 =?utf-8?B?dU96ZG9uOWZIOUh6TzZzVEZtcW1tVUkwcy9VR3p3b1g1SDh4b0krWnZ5c0hz?=
 =?utf-8?B?WUZXY3FJaWwvU3grMnhLa2dpcmpGOFFUOEtvcXBIS3REVmZ4NHFCcjBWRnoy?=
 =?utf-8?B?UmJSUkM3QjRTSEtBTjNJajFlZEhPcHNOVGFqS1FVb25icW1YcWZNTThJc1pF?=
 =?utf-8?B?c1g2ck1mUlRyQVdrZ05jemJ1ZitTL3NTdkJoUkZQL0lXZ0xuUThRUlljVWp3?=
 =?utf-8?B?MStMbGQ4SVBDcXZWdWh1TWlNSWJGMWp4WHhDc2tQbkNsRjdZa2hmWG1NcHlX?=
 =?utf-8?B?NnhmUW4ybGJMNzNMSVN3bnR2bXlncGpCSlQwNjk1OHlVSGVMZ2ZKZ0dGNStE?=
 =?utf-8?B?c3JpS0o2ekRGVFd6aHJPdDJTb0s4bFpkSFRrekc1N29qL0Rsa1hxWG1Gem9Z?=
 =?utf-8?B?Ny9SWk9ibHBPVjNYUFIrSmVWc01tZlMydTdybDVieFZ6eEtFSFRBVzFFU3M1?=
 =?utf-8?B?bkZzUmFNY1ZkL1QvUkxoVnBJelFTdWdLUnd0dFlUT1NOT0xlSGZvZmplVUM4?=
 =?utf-8?B?SW54QVdjMnhyYTM4VXZZREdHWGloSGhHTmh0dlZXVkRqL1A5bGliNmJlTVVh?=
 =?utf-8?B?ZjlLRVFaeXp5UzVqZ2hYWFllWXNCamhxMy9ScXNPUy9uek9mdmZMaHZYZi9n?=
 =?utf-8?B?dHN3ODV2bkZPN1ArZzhwSGhxRDVvb3FxUzUzenZzTHBSVG5qeTJqQXhkN2pS?=
 =?utf-8?B?YkRsaUdoeiszWHBWSENiSHJoNzVqdUlmUmdyWk1HL0RpYWl6bThwdnRnNVVa?=
 =?utf-8?B?WFF2MU9UbDJUei9saHdOV3pDUHpqRkJFYkszNWxnYXdPQy9YbjVRZXZNdWs0?=
 =?utf-8?B?STRzdWNuYmQweW96cXhmNHhPRk16MHh2YzhTRDNjcHFoU001cFR0S1VacTVR?=
 =?utf-8?B?Nkdxa210SGtwUWxleXlBSER5TGVnQnREdTJ6dHZSQ2tnZ2lVa3J4UzVDaE94?=
 =?utf-8?B?Y3lhVDNHUkZva3lySlA5VE95cExCZzJPOUpCeWdKaWhPU1IyRFlmMXZUK1c2?=
 =?utf-8?B?a3djMkxINGprdnFDMWM4Y0VmNHlBTFZkaERkSUFHK2VMQ3hoMDhsWGlFQity?=
 =?utf-8?B?UDk1OTRVKzVtUEhTTW1BWlJLekhBc2xoZExXc2RKdGxXeE5QVzJxVWRqelA5?=
 =?utf-8?B?VG5CaWUyQk8xRDk1Y24zbmJySEVXc3Bpc1k0ZXpYWkpCd3FlekZjMzJpS1hl?=
 =?utf-8?B?dXFIc00vY1IzeS9jVFhvc0Y4U3pYcm95RzN1dlZCOFVUK1VQeVdJMDNJajJj?=
 =?utf-8?B?OHlhSFdIUkJlZXBnczF0SExzOGJWNE9rOHl6eG5aV091cGNOVzZOaEhkZ2Vn?=
 =?utf-8?B?bHNBb0hKdGovb2owcVNQR3RCaE1YQmlwZjZhR2NCWnUwZnlSMWVLTENwMjFj?=
 =?utf-8?B?dFN5bk1peHdwRVNmSW1zMHlhWGt2K2xaL1Q4MUR0SURCNWNublk5OUJPYWZu?=
 =?utf-8?B?SkFIblBBNW1GNkdrcnY1eU0vWnRjN1BqSUdiNGF6UWUzb1gzWWdvVTVCZmtv?=
 =?utf-8?B?ZnhIYnNmNkx5REVjTWRoa1BpdG5aeFBEaExYVWN3WnQ1N3B1alZEeUtOaDdY?=
 =?utf-8?B?eFAzZnhFMHdUbzhIK3ozZmFjTDRzU0xTcDJwUlBQUXplQ2d6NWdzL2JSS0Zk?=
 =?utf-8?B?QUFOMkNxTEV0dnd3eFo4ODBpZ2hUQ1NtQTV1aGhYQm16REdQdk9CdUh1VnpW?=
 =?utf-8?B?VlBLZWJwZzA1MjV6VnlTTXlnWnZnd25yVW0zRUhXUnNVdHhHdnRRSUwwNFNv?=
 =?utf-8?B?SVA0Y1hBVDJiMUtOcWcxNVdlTmMvUnF2N3REVkZJT0Exblg3SE1NOC8vK00x?=
 =?utf-8?B?YVBGL1pxZjRnYkJkVXVIckViMTBBRWV2VkFuOWVBQmpOUklQdXp6amFkTEl2?=
 =?utf-8?B?RVYwQ1h6a3BTZEhIVVpSQ2NmQ21tMDdWenFnaFZFQ2p0MEwyenNWNHIwNFJL?=
 =?utf-8?B?NVcwMXEveGUrUWM1NkFsS2RzeHhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C1A74FE9CAEEC428E3AA28277E0FDD8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ba926a-16df-4af9-afd8-08d9d66b442a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 08:04:04.1565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFyrR1maRwWXvsBf+rMfOpch2Dan8t8TTx5/oopHlMfHP3q5RVu2gWOY/ZhTQTNCWRO9uyqbwPaKA1XX1sg97QHyD35xnCyStjJuFu3UnBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMDEuMjAyMiAyMDoxMSwgUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIEdFTSBjb250cm9sbGVycyBvbiBaeW5x
TVAgd2VyZSBtaXNzaW5nIHNvbWUgaW5pdGlhbGl6YXRpb24gc3RlcHMgd2hpY2gNCj4gYXJlIHJl
cXVpcmVkIGluIHNvbWUgY2FzZXMgd2hlbiB1c2luZyBTR01JSSBtb2RlLCB3aGljaCB1c2VzIHRo
ZSBQUy1HVFINCj4gdHJhbnNjZWl2ZXJzIG1hbmFnZWQgYnkgdGhlIHBoeS16eW5xbXAgZHJpdmVy
Lg0KPiANCj4gVGhlIEdFTSBjb3JlIGFwcGVhcnMgdG8gbmVlZCBhIGhhcmR3YXJlLWxldmVsIHJl
c2V0IGluIG9yZGVyIHRvIHdvcmsNCj4gcHJvcGVybHkgaW4gU0dNSUkgbW9kZSBpbiBjYXNlcyB3
aGVyZSB0aGUgR1QgcmVmZXJlbmNlIGNsb2NrIHdhcyBub3QNCj4gcHJlc2VudCBhdCBpbml0aWFs
IHBvd2VyLW9uLiBUaGlzIGNhbiBiZSBkb25lIHVzaW5nIGEgcmVzZXQgbWFwcGVkIHRvDQo+IHRo
ZSB6eW5xbXAtcmVzZXQgZHJpdmVyIGluIHRoZSBkZXZpY2UgdHJlZS4NCj4gDQo+IEFsc28sIHdo
ZW4gaW4gU0dNSUkgbW9kZSwgdGhlIEdFTSBkcml2ZXIgbmVlZHMgdG8gZW5zdXJlIHRoZSBQSFkg
aXMNCj4gaW5pdGlhbGl6ZWQgYW5kIHBvd2VyZWQgb24gd2hlbiBpdCBpcyBpbml0aWFsaXppbmcu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2Fs
aWFuLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFp
bi5jIHwgNDcgKysrKysrKysrKysrKysrKysrKysrKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgNDYg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9j
YWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IGEzNjNkYTkyOGU4Yi4uNjViMDM2MGM0ODdhIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTM0
LDcgKzM0LDkgQEANCj4gICNpbmNsdWRlIDxsaW51eC91ZHAuaD4NCj4gICNpbmNsdWRlIDxsaW51
eC90Y3AuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9pb3BvbGwuaD4NCj4gKyNpbmNsdWRlIDxsaW51
eC9waHkvcGh5Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiArI2luY2x1
ZGUgPGxpbnV4L3Jlc2V0Lmg+DQo+ICAjaW5jbHVkZSAibWFjYi5oIg0KPiANCj4gIC8qIFRoaXMg
c3RydWN0dXJlIGlzIG9ubHkgdXNlZCBmb3IgTUFDQiBvbiBTaUZpdmUgRlU1NDAgZGV2aWNlcyAq
Lw0KPiBAQCAtNDQ1NSw2ICs0NDU3LDQ5IEBAIHN0YXRpYyBpbnQgZnU1NDBfYzAwMF9pbml0KHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgICAgICAgcmV0dXJuIG1hY2JfaW5pdChw
ZGV2KTsNCj4gIH0NCj4gDQo+ICtzdGF0aWMgaW50IHp5bnFtcF9pbml0KHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9
IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOw0KPiArICAgICAgIHN0cnVjdCBtYWNiICpicCA9
IG5ldGRldl9wcml2KGRldik7DQo+ICsgICAgICAgaW50IHJldDsNCj4gKw0KPiArICAgICAgIC8q
IEZ1bGx5IHJlc2V0IEdFTSBjb250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIHVzaW5nIHp5bnFt
cC1yZXNldCBkcml2ZXIsDQo+ICsgICAgICAgICogaWYgbWFwcGVkIGluIGRldmljZSB0cmVlLg0K
PiArICAgICAgICAqLw0KPiArICAgICAgIHJldCA9IGRldmljZV9yZXNldCgmcGRldi0+ZGV2KTsN
Cj4gKyAgICAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgICAgICAgICBkZXZfZXJyX3Byb2JlKCZw
ZGV2LT5kZXYsIHJldCwgImZhaWxlZCB0byByZXNldCBjb250cm9sbGVyIik7DQo+ICsgICAgICAg
ICAgICAgICByZXR1cm4gcmV0Ow0KDQpJZiB1c2luZyBvbGQgZGV2aWNlIHRyZWVzIHRoaXMgd2ls
bCBmYWlsLCByaWdodD8gSWYgeWVzLCB5b3Ugc2hvdWxkIHRha2UNCmNhcmUgdGhpcyBjb2RlIHdp
bGwgYWxzbyB3b3JrIHdpdGggb2xkIGRldmljZSB0cmVlcy4NCg0KVGhhbmsgeW91LA0KQ2xhdWRp
dSBCZXpuZWENCg0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAgIGlmIChicC0+cGh5X2ludGVy
ZmFjZSA9PSBQSFlfSU5URVJGQUNFX01PREVfU0dNSUkpIHsNCj4gKyAgICAgICAgICAgICAgIC8q
IEVuc3VyZSBQUy1HVFIgUEhZIGRldmljZSB1c2VkIGluIFNHTUlJIG1vZGUgaXMgcmVhZHkgKi8N
Cj4gKyAgICAgICAgICAgICAgIHN0cnVjdCBwaHkgKnNnbWlpX3BoeSA9IGRldm1fcGh5X2dldCgm
cGRldi0+ZGV2LCAic2dtaWktcGh5Iik7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIGlmIChJU19F
UlIoc2dtaWlfcGh5KSkgew0KPiArICAgICAgICAgICAgICAgICAgICAgICByZXQgPSBQVFJfRVJS
KHNnbWlpX3BoeSk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnJfcHJvYmUoJnBk
ZXYtPmRldiwgcmV0LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJm
YWlsZWQgdG8gZ2V0IFBTLUdUUiBQSFlcbiIpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICBy
ZXR1cm4gcmV0Ow0KPiArICAgICAgICAgICAgICAgfQ0KPiArDQo+ICsgICAgICAgICAgICAgICBy
ZXQgPSBwaHlfaW5pdChzZ21paV9waHkpOw0KPiArICAgICAgICAgICAgICAgaWYgKHJldCkgew0K
PiArICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8g
aW5pdCBQUy1HVFIgUEhZOiAlZFxuIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICByZXQpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiArICAgICAg
ICAgICAgICAgfQ0KPiArDQo+ICsgICAgICAgICAgICAgICByZXQgPSBwaHlfcG93ZXJfb24oc2dt
aWlfcGh5KTsNCj4gKyAgICAgICAgICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIHBvd2VyIG9uIFBTLUdUUiBQ
SFk6ICVkXG4iLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldCk7DQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICsgICAgICAgICAgICAgICB9DQo+
ICsgICAgICAgfQ0KPiArICAgICAgIHJldHVybiBtYWNiX2luaXQocGRldik7DQo+ICt9DQo+ICsN
Cj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl91c3Jpb19jb25maWcgc2FtYTdnNV91c3JpbyA9
IHsNCj4gICAgICAgICAubWlpID0gMCwNCj4gICAgICAgICAucm1paSA9IDEsDQo+IEBAIC00NTUw
LDcgKzQ1OTUsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFtcF9jb25m
aWcgPSB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIE1BQ0JfQ0FQU19HRU1fSEFTX1BUUCB8
IE1BQ0JfQ0FQU19CRF9SRF9QUkVGRVRDSCwNCj4gICAgICAgICAuZG1hX2J1cnN0X2xlbmd0aCA9
IDE2LA0KPiAgICAgICAgIC5jbGtfaW5pdCA9IG1hY2JfY2xrX2luaXQsDQo+IC0gICAgICAgLmlu
aXQgPSBtYWNiX2luaXQsDQo+ICsgICAgICAgLmluaXQgPSB6eW5xbXBfaW5pdCwNCj4gICAgICAg
ICAuanVtYm9fbWF4X2xlbiA9IDEwMjQwLA0KPiAgICAgICAgIC51c3JpbyA9ICZtYWNiX2RlZmF1
bHRfdXNyaW8sDQo+ICB9Ow0KPiAtLQ0KPiAyLjMxLjENCj4gDQoNCg==
