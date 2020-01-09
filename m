Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7650B135D51
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 17:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgAIP75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:59:57 -0500
Received: from mail-eopbgr1320077.outbound.protection.outlook.com ([40.107.132.77]:33560
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730796AbgAIP75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 10:59:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXtF9N7JwZzQmGa91/V5Q2iZaNwtE7S5TIky+81sw+YzBp5SOpYjOKajfF4Ke8o+W/9AW+oOUVuegRur2wbXahkMH24fMenARkMxcrfdQJyANVJSM/nL4Pc3TlAkES9Jt7dU1arHYDPMm/3Voa6IwL2SDjaPp5ExeaWdmu+AIJCbyfip16rt6wfg3CbvKItFjqV6mvGBJX7LFPFmK45KWjbwc2THj5a1cfyOKN2h2w98RRmSFGT3qbb9jx0CL4N2tgk83gdKWWYzAeeewl2Yk593DejDB5TZatlKt0UHxN/UeO3TMO6mScwcd1IgHeCvQ2alwQyS/Cb1SJxo3WmT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzyTqtbOfq3Ig0yXTX1EWjydOU+uAenurCB81rAkFjg=;
 b=FBJOralaB8nWUA1ypg7Tdlg613ED6ygEvcnJJrJCWbW6L2rJUcE6di1SqajNSSYe+sq5kP4wWUTjYisX6Yh1YZOMePyejazm466oJVPXw58Hk0PV9BVxyLn6uj5jp+q9bZW8KAkShyS0MY4/kPHjSBzuuGk6q8/Y9Z8Gua+wpVyHWPytGFozybmJRXjeAttb1F18AthJ1U/JfU/7PoJ78cA8hT9lK/PiWAijeKYpzDZ+LD3wEFsUj2cwHIBwN4mqNQda9FumfklbZCTOFgPflDU3UfMfhiV5HyfoVRfwIObJrPTRmuwfYaSOWZAUb0TF81qZIvmUiqdFMnzn/Lk5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=teo-en-ming-corp.com; dmarc=pass action=none
 header.from=teo-en-ming-corp.com; dkim=pass header.d=teo-en-ming-corp.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=teoenmingcorp.onmicrosoft.com; s=selector2-teoenmingcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzyTqtbOfq3Ig0yXTX1EWjydOU+uAenurCB81rAkFjg=;
 b=Zdq09SwUd5FDv6v99ds2qxu+QyHW0FdD27P5rO94w7glwYvwikP7S5ekp3+gcNxRi9xkEcSq51jasEtUYFbXnCeHEIZ7/NxjurulPsQjsuO8mLnF/ndYP4egh6F3NwlS85RCyoVAxkXhW7AT/d+FckIp/oQrHs4h6RbqLYEQSFQ=
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com (10.170.143.19) by
 SG2SPR01MB0019.apcprd01.prod.exchangelabs.com (20.177.85.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 9 Jan 2020 15:59:53 +0000
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::81e9:67b1:74eb:2853]) by SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::81e9:67b1:74eb:2853%3]) with mapi id 15.20.2623.011; Thu, 9 Jan 2020
 15:59:53 +0000
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
Subject: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts as at 9
 Jan 2020 Thursday
Thread-Topic: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts as
 at 9 Jan 2020 Thursday
Thread-Index: AdXHBctbdu+lX36JRJ6X2VXk6dMnXQ==
Date:   Thu, 9 Jan 2020 15:59:53 +0000
Message-ID: <SG2PR01MB2141C9502536C2F56B7E591487390@SG2PR01MB2141.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ceo@teo-en-ming-corp.com; 
x-originating-ip: [2401:7400:c802:de67:f1ab:6fde:d925:5c0c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea28a02f-3cab-4b92-9a40-08d7951cf70d
x-ms-traffictypediagnostic: SG2SPR01MB0019:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SG2SPR01MB00195E50D95B68236952C6AF87390@SG2SPR01MB0019.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39830400003)(346002)(396003)(136003)(189003)(199004)(2906002)(316002)(5660300002)(186003)(52536014)(6506007)(81166006)(4000180100002)(81156014)(33656002)(66946007)(66446008)(66556008)(66476007)(8676002)(7696005)(64756008)(76116006)(8936002)(9686003)(55016002)(4326008)(107886003)(6916009)(508600001)(71200400001)(966005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:SG2SPR01MB0019;H:SG2PR01MB2141.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: teo-en-ming-corp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 88aLIE+TU3DrbzRKkezOMFvhjb/QCJUVfG63RlY5hv2QRY52TJqtlr4jtm8s+fjGDKk48p3Se6uFe4vNX1WoCFtv3F70FI5cvCXJx9kWfmfwk22/YE/nmFX6Fmewi46ePajDVtuSydlQ5GEmo9VwusFvMeISA5jpcudw4pZBNrBmdYqSGY3W6O1LTjRdAeDHy6CeWcjBWzndtvfC/PhiyiBzpRG8yBitom5P+VVKvUk1831qz4911FsplMzyktnS4Wa4WJtFBGKffOAScrF4KlaU5lTBWgnI8ydIwpJqVuYgLQedPKJ8Etoh7i+Hs4IVkpQlMWz2htUYlH/cWlXvZPAYnUqBJTQh7wQPtcdz/NE4uUIR+txjpT9etIITOTS46CuVgQMuxFHXpB/I9eAS4VCvP1kmlshA8Nl2qsLiiAuxx0VW8kbYVxuSgrY4mESW5sN9elL3j2ksjVNWwnwNqyEbNVWmwJBsYnS0QKNBZhNsLg9Ynwxla34G79J9fQDoO2xsJC76wSGlriKiaMw6+g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: teo-en-ming-corp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea28a02f-3cab-4b92-9a40-08d7951cf70d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 15:59:53.1052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b3f6ae-c453-4b93-aec9-f17508e5885c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rDw2grHFHC1KRt0ywU1ex2tOeZYfskO4EbBxYZuGFov//RaAkE14UcVXaV2aTfEIeFwnC0WhalBm9UIcaqS7r7K2Tceja6n/VVs5yEvzj10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2SPR01MB0019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SUBJECT: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts as at=
 9 Jan 2020 Thursday

In reverse chronological order:

[1] Application for Offshore Refugee/Humanitarian Visa to Australia, 25 Dec=
 2019 (Christmas) to 9 Jan 2020

Photo #1: Page 1 of Form 842 Application for an Offshore Humanitarian visa,=
 Refugee and Humanitarian (Class XB) visa

Photo #2: Front of DHL Express plastic envelope (yellow)

Photo #3: Back of DHL Express plastic envelope (white)

Photo #4: DHL Express Shipment Waybill

Photo #5: DHL Express Shipment Tracking Online Page, showing that my applic=
ation for offshore refugee visa to Australia=20
was picked up at 1619 hours on 25 Dec 2019 in Singapore and delivered to Ca=
nberra - Braddon - Australia
on 30 Dec 2019 at 11:10 AM Braddon, Australian Capital Territory (ACT) Time

Photo #6: DHL Express Electronic Proof of Delivery, showing that my applica=
tion for offshore refugee visa to Australia=20
was received and signed by staff Mohsin Mahmood at the Special Humanitarian=
 Processing Center,=20
3 Lonsdale Street, Braddon, Australian Capital Territory (ACT) 2612, Canber=
ra, Australia.

Photo #7: Page 5 of Form 842 Application for an Offshore Humanitarian visa,=
 Refugee and Humanitarian (Class XB) visa, bearing the=20
official stamp of the Australian Government Department of Home Affairs at N=
ew South Wales (NSW):=20
"COURIER RECEIVED; HOME AFFAIRS; NSW; 27 DEC 2019" and=20
"HOME AFFAIRS; NSW; 27 DEC 2019" at the bottom.

References:

For the above-mentioned seven photos, please refer to my RAID 1 mirroring r=
edundant Blogger and Wordpress blogs at

https://tdtemcerts.blogspot.sg/

https://tdtemcerts.wordpress.com/



[2] Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday

Photo #1: At the building of the National Immigration Agency, Ministry
of the Interior, Taipei, Taiwan, 5th August 2019

Photo #2: Queue ticket no. 515 at the National Immigration Agency,
Ministry of the Interior, Taipei, Taiwan, 5th August 2019

Photo #3: Submission of documents/petition to the National Immigration
Agency, Ministry of the Interior, Taipei, Taiwan, 5th August 2019

Photos #4 and #5: Acknowledgement of Receipt (no. 03142) for the
submission of documents/petition from the National Immigration Agency,
Ministry of the Interior, Taipei, Taiwan, 5th August 2019, 10:00 AM

References:

(a) Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday (Blogger blog)

Link: https://tdtemcerts.blogspot.sg/2019/08/petition-to-government-of-taiw=
an-for.html

(b) Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday (Wordpress blog)

Link: https://tdtemcerts.wordpress.com/2019/08/23/petition-to-the-governmen=
t-of-taiwan-for-refugee-status/



[3] Application for Refugee Status at the United Nations High Commissioner =
for Refugees (UNHCR),=20
Bangkok, Thailand, 21st March 2017 Tuesday

References:

(a) [YOUTUBE] Vlog: The Road to Application for Refugee Status at the
United Nations High Commissioner for Refugees (UNHCR), Bangkok

Link: https://www.youtube.com/watch?v=3DutpuAa1eUNI

YouTube video Published on March 22nd, 2017

Views as at 9 Jan 2020: 659

YouTube Channel: Turritopsis Dohrnii Teo En Ming
Subscribers as at 9 Jan 2020: 3.14K
Link: https://www.youtube.com/channel/UC__F2hzlqNEEGx-IXxQi3hA






-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link:=A0https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microw=
ave.html

***************************************************************************=
*****************

Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic
Qualifications as at 14 Feb 2019 and refugee seeking attempts at the
United Nations Refugee Agency Bangkok (21 Mar 2017) and in Taiwan (5
Aug 2019):

[1]=A0https://tdtemcerts.wordpress.com/

[2]=A0https://tdtemcerts.blogspot.sg/

[3]=A0https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----

