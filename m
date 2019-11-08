Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F78F3E11
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKHCYu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 21:24:50 -0500
Received: from mail-oln040092254014.outbound.protection.outlook.com ([40.92.254.14]:3744
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbfKHCYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 21:24:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaqK/7Bs5ZhM34khOhn5qMKtgfaLyIz+dk14rCBJ/cjpR97dF4VdTQZ0oOlolX4NONI6uGvVsAbl+wO/rCaF7jxBMOqZl12ZwhVg7n8h8TtxjT1JiykP4t5t0tsh3BcsZllBbe58DsVazaxBxcAqf67BmLJbd7S1d7okUuhbDMZpcek+lEOgjVEIu1ABaTchAnYdb8h2OrHf7PeEN7hH50QbrHrrdHRSFXj5rj9x/+nVjmeK9CAzHZgMSvYTvyA9fRxY1OV0L9ATyvKvih28sEVqeVEFsVV5zK9MSlY85CHeCIjtasn8tTPN6zaqrV1+oFlWtR1RaEePMINUJWrwqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgwDb6rDrEGLUnUtrtDBNoPTYWCErMVkvlTZ686qTR8=;
 b=UDkohxITk1p2O0RAh2zdFQtkTU4RNtNnKkmOt+awqPMJZFfuoUOl5ALZ1gMCWtUl8E3IUoHgHfLe6Qa4TXroxj6Ih3PZIfGF1Hp4Od9QAwm5ikP/E4AoQrlfMgD/fP0Z5ltXtWdiaYxOfkoMImDXfa8q+sb+NYpN0YRmRM/YQ39E6querL1WPXpaH+3+xjDrCMGj8zFcf7PX8g/LO0S1OvnctvtLgWJVydndA/FxeJuHazcqunTbeeo01nNdL+caZ4byHprUAQtnFV8213EJVB/KUSXOEmYb5LoYWokmyvj5S1hsKjiwrQJY5vf6FzpsOg4Rb3p3fKKn7aSfk236Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HK2APC01FT036.eop-APC01.prod.protection.outlook.com
 (10.152.248.55) by HK2APC01HT149.eop-APC01.prod.protection.outlook.com
 (10.152.249.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.22; Fri, 8 Nov
 2019 02:24:44 +0000
Received: from PS2P216MB0755.KORP216.PROD.OUTLOOK.COM (10.152.248.56) by
 HK2APC01FT036.mail.protection.outlook.com (10.152.249.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2430.22 via Frontend Transport; Fri, 8 Nov 2019 02:24:44 +0000
Received: from PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
 ([fe80::44f5:f4bb:1601:2602]) by PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
 ([fe80::44f5:f4bb:1601:2602%9]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 02:24:44 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Possibility of me mainlining Tehuti Networks 10GbE driver
Thread-Topic: Possibility of me mainlining Tehuti Networks 10GbE driver
Thread-Index: AQHVlduusrLCB8qbpUuakWm6pLXSWg==
Date:   Fri, 8 Nov 2019 02:24:44 +0000
Message-ID: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SYBPR01CA0184.ausprd01.prod.outlook.com
 (2603:10c6:10:52::28) To PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:1c::13)
x-incomingtopheadermarker: OriginalChecksum:91A07AD40968D4C7A19990383DDEAD40DBCFCAF7C809B8C8371A3D9FF4D35EE1;UpperCasedChecksum:8128DE5F8F8D7FA317E13946924615DC695E88B75B47AFF69F4779704B099BA1;SizeAsReceived:7236;Count:47
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [/WVn2ORaCL6bpaudEioWrjn9acGDKHrL]
x-microsoft-original-message-id: <20191108022436.GA4601@nicholas-dell-linux>
x-ms-publictraffictype: Email
x-incomingheadercount: 47
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 7ea313a8-883d-49de-5aff-08d763f2d116
x-ms-traffictypediagnostic: HK2APC01HT149:
x-ms-exchange-purlcount: 2
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0o11pxi0LtqWhJHtNzw0yJ4yi5yXsnS7HDY3wFTC/PZKm0VEj6lRkdUoNVWZSQk8FWSKmXeXNhJrTRg28zXY4FCtVzYfPu2HVj4/7eLim0DWrHumo8LE4ofmRISd2Phprdf27cVwE9qyqFqqd6zRUJhh8mrpPcgdXIH7YJzJ1SwiJDEXQ7XlgaH16AdkPqXvSmn4nbYm6dae85YsErZwtAq/e/2ImzjyQ31senqSl6o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D2829C31F4825488DEBAD67B509C7E0@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea313a8-883d-49de-5aff-08d763f2d116
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 02:24:44.3660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2APC01HT149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

To start off, if I am emailing the wrong people, please blame the output 
of: "scripts/get_maintainer.pl drivers/net/ethernet/tehuti/" and let me 
know who I should be contacting. Should I add in 
"linux-kernel@vger.kernel.org"?

I just discovered that the Tehuti 10GbE networking drivers (required for 
things such as some AKiTiO Thunderbolt to 10GbE adapters) are not in 
mainline. I am interested in mainlining it, but need to know how much 
work it would take and if it will force me to be the maintainer for all 
eternity.

The driver, in tn40xx-0.3.6.15-c.tar appears to be available here:
Link: https://www.akitio.com/faq/341-thunder3-10gbe-adapter-can-i-use-this-network-adapter-on-linux
Also here:
Link: https://github.com/acooks/tn40xx-driver

I see some immediate style problems and indentation issues. I can fix 
these.

The current driver only works with Linux v4.19, I believe. There are a 
small handful of compile errors with v5.4. I can probably fix these.

However, could somebody please comment on any technical issues that you 
can see here? How much work do you think I would have to do to mainline 
this? Would I have to buy such a device for testing? Would I have to buy 
*all* of the supported devices for testing? Or can other people do that 
for me?

I am not keen on having to buy anything without mainline support - it is 
an instant disqualification of a hardware vendor. It results in a 
terrible user experience for experienced people (might not be able to 
use latest kernel which is needed for supporting other things) and is 
debilitating for people new to Linux who do not how to use the terminal, 
possibly enough so that they will go back to Windows.

Andy, what is your relationship to Tehuti Networks? Would you be happy 
to maintain this if I mainlined it? It says you are maintainer of 
drivers/net/ethernet/tehuti/ directory. I will not do this if I am 
expected to maintain it - in no small part because I do not know a lot 
about it. I will only be modifying what is currently available to make 
it acceptable for mainline, if possible.

Also, license issues - does GPLv2 permit mainlining to happen? I believe 
the Tehuti driver is available under GPLv2 (correct me if I am wrong).

Would I need to send patches for this, or for something this size, is it 
better to send a pull request? If I am going to do patches, I will need 
to make a gmail account or something, as Outlook messes with the 
encoding of the things which I send.

Thanks for any comments on this.

Kind regards,
Nicholas Johnson
