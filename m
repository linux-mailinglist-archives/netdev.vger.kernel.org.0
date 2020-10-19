Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95520292258
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 08:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgJSGGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 02:06:01 -0400
Received: from mail-eopbgr100092.outbound.protection.outlook.com ([40.107.10.92]:41621
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgJSGGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 02:06:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fp838OD9WtkVP9eLKA/Iai2EMK1JFLM36ysKNL52X23WbY8Htt9saS43bsJ8rlEjsIFifjufGujwiHom3TBcn4cOHP6rK27fvOJMtSJBnSIjbgQiOj9IlZx7jInxTcNGrHe5xZFnX1yngc+czYSs8wcdTOt5Ql3oPEBZdMwftaw1xEGMW64af/wFwbWQpGGwleEiPHKrebGpNzBFaOzAfY8DG5ZzTPwZt3wIxvYQ46O7tnmxF8IOGDswrasa5xdEBcJMLK3RWkqlTmuz2zWTYNMQH/tSOJPDWgNp7pCJOMGM2WtoTXhiIUjFPY24YApsM5ZHsB5GJez9MKAY4TTt8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qeNcvlhCEwkGBuLD2qp0N/F8HuRUXeYqJ8mf3RwLJM=;
 b=RMNwiR8QsHJyxlJ2LXqoz87LjyobgPgiGmvgMtIMgNfpHOOfJkdSYo2rUaTzTKGa9pBA213TAHzvLokDj0Jy8ODzAxbYHgzPAoij8aldON3I580WReENl/uCVGDtPyOFn16dJXEoVCWzA7i7n+tO3NPmORisiq6bV241DV+M/mvxv+UxeCRbGe6ecR2sMfZ44SS/VkZGoqGBD3ZRflXKK7GT52orgNG2BaUlL1OFT1zkCCQizgxxVjEMz+C/q7IhgBSTLF8FGTruZ0isS11zGmh4EUj4ugwdzOt22RM16EpTwQwUyO0AKjfIFGu39Z2ShQtseCA/6G13zwm1g+Bwog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qeNcvlhCEwkGBuLD2qp0N/F8HuRUXeYqJ8mf3RwLJM=;
 b=qOAddpFqHQeM1MolmRwG/9tfNGC22701NTBP9L1CGVJptQZkbSO10BzzG6TwSBUimfQ4Z9m9BM0PLEPTCPAvNtuqVaUlgIkbyKPi9BbVf9oG0Zd7WFBP6dQOCbVmS94ksEHU5avNAXq3UlRBr4GZAqSR9W4N5A21G0ZjN3j42Uc=
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:ef::9) by
 LO3P265MB2106.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:10b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.25; Mon, 19 Oct 2020 06:05:57 +0000
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b]) by LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 06:05:57 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Joe Perches <joe@perches.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v5] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v5] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWpcZ65mM4/36TpU6KSYXahxubVameXJmAgAATXBw=
Date:   Mon, 19 Oct 2020 06:05:57 +0000
Message-ID: <LOYP265MB191823348BB322A96BBF9BA2E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20201016063444.29822-1-srini.raju@purelifi.com>
         <20201019031744.17916-1-srini.raju@purelifi.com>,<e59c0c575f9d9e1af8c6fdf2911cd9d028de257f.camel@perches.com>
In-Reply-To: <e59c0c575f9d9e1af8c6fdf2911cd9d028de257f.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.8.116.159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6d96af5-0833-46eb-ae33-08d873f50be0
x-ms-traffictypediagnostic: LO3P265MB2106:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <LO3P265MB2106E2C70C50EF09FBA16288E01E0@LO3P265MB2106.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HLwn0zlTLgWEjyBPm1V+4ERd6edJPB0NHReHuSLMX1nEFdY6f6p0P2TplKpgUdernwoV9UoxXwZX4L9dDrInCvV2iKmqyg4Q87M3bol2xnJvtXMlFZvnsIXFr/nO8tByavwXGNKGka8qwW1LIu1T/9GUS2JSCohT5v5Agf8ku0j4Z5+uolDiysxTCVkmhOok3B9aySzNCZc1YiA8wYTHQGOyX8qYN26SiBKRQY5apb/Mfv6evSpOgYYZDnPqi1uSnRRF0zFR18pniL/A3q9vtnaApOdWY9ZaamBbWT1dPMbxUD8vDyr7poaF3a2pzwjVjAIdKEI/vlzSGlWtI6iwNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(39830400003)(396003)(346002)(136003)(376002)(71200400001)(186003)(52536014)(4326008)(9686003)(64756008)(66446008)(91956017)(76116006)(66946007)(558084003)(66476007)(66556008)(8676002)(33656002)(7416002)(55016002)(2906002)(6916009)(5660300002)(26005)(86362001)(54906003)(478600001)(316002)(6506007)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: a3GqZKJNGzIbIfRGEseewX7jnSj1hfF+ommNtOL6uZkUGDE8lme3bM5ahjhFhot3os2L2RPk2Klb9+ADtQBqR6OTForChkf2dGjx8dqdXLZlpdt7eURr/dBV4cAQ8K49K1gTg5/7VKNS8+ZHctD7yuBw9ogz8r14Kyke4i+MF61r+wuQCmG0h0lOrymOaj6SZN+x9KKVg/xjF5Y9aS0aaHjwY7KA8AbAtsEt46R5lHUh6uMmjEWKMrDfxRTVGlu1MIusvTjp336ctxxZTSHFWfLCXDz6hvsscis6C3uMLZ9agSpzQw2TYAybUqysKMHE5+8b5j3X5RE+xMLkcPe4+j4wsNKpqx1XEMaES+ch+ztYxDpj5GpLZdoEOsoHhwcQHFjt4RdBp3m4LgaevtIudvtI4rX1kTyNdtQ4hwoa0J3eG0MABOHkjUux6MEUlzOsbaFQJ/hsxH3jTUNS/eSMUz84Rti9EbNnlX64WMnz4ypx6sye0SDhhUSf9nK8bxg3Coh7phjQDLavkoiXrDmcD116huDPc6CBlQo+QYvGuz4xzK8R2FxWBTz8ZSdwuq3jQd0/BJ0EZy9V++RIZJHo7v2BUtf9a1OBQ8c2JXufhEU1hqXd5vSqFtly7uplGSL0cRQiW+UTE9KxioOPXdukRg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d96af5-0833-46eb-ae33-08d873f50be0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 06:05:57.5380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FfbG/Kp+qyUP2jM4k4Jc2kNRUu5tuvx80DS9VZcZnb46rtpUN+lLPoSkNK3Lz3cHv714N2zFGYS9fXJwyKVrsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P265MB2106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
Mostly trivial comments:=0A=
=0A=
>> Ok Thanks, I will address them=
