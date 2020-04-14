Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454CA1A81AB
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437377AbgDNPLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:11:34 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37150 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436868AbgDNPLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:11:31 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03EF3kr3007845;
        Tue, 14 Apr 2020 17:11:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=o5lIOijZ0sBDI1z56uPx6r05q0wzqh69VOMPcYsYYzk=;
 b=TET6vAJBhoV6cQkC6NNV3nmXZSkyPqi/T3KqxtfXDzzyhwXjn7i24IujVy7CHIvbQEub
 l2JYjM3ld5bHY1R3iI5sCEMSBOMX3fteDFT7hHkwRNOm0TuxhBQcileaL7BgXdkPNHxo
 yO5jbqDjmcIIIuzruaPHWZXRp//AsR+3WiK9dmCwIM6aPcMIlBgdZu5v27k+t3TTxz+p
 xiI8vR06XEWSrFW/eClYUHeIE+ijgoHEEIzQX6d8aP8pOkinUYwYWokLL/cB2mwRUowi
 ElhW62kV0+on4+O9sH4dhWHdkw1QSjF/W5yRKlS2gYXKhGOaUFW9WM/jJtwtTumuLDon tw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30b5sjxe4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Apr 2020 17:11:09 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B4E1F100034;
        Tue, 14 Apr 2020 17:11:03 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 96CB12B2F95;
        Tue, 14 Apr 2020 17:11:03 +0200 (CEST)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG3NODE3.st.com
 (10.75.127.9) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 14 Apr
 2020 17:11:03 +0200
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1473.003; Tue, 14 Apr 2020 17:11:03 +0200
From:   Christophe ROULLIER <christophe.roullier@st.com>
To:     David Miller <davem@davemloft.net>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 0/2] Convert stm32 dwmac to DT schema
Thread-Topic: [PATCH V2 0/2] Convert stm32 dwmac to DT schema
Thread-Index: AQHWCcDK5mbO73L43EK/JlozUfUcxahn5iUAgBDCpAA=
Date:   Tue, 14 Apr 2020 15:11:03 +0000
Message-ID: <df446a1a-c651-caa9-6086-9d84b11f3159@st.com>
References: <20200403140415.29641-1-christophe.roullier@st.com>
 <20200403.161414.635525483978443770.davem@davemloft.net>
In-Reply-To: <20200403.161414.635525483978443770.davem@davemloft.net>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.44]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6C78A97C0A16440BDF6F6D6EEBB6B79@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_07:2020-04-14,2020-04-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkdlbnRsZSByZW1pbmRlcg0KDQpUaGFua3MsDQoNCkNocmlzdG9waGUuDQoNCk9uIDA0
LzA0LzIwMjAgMDE6MTQsIERhdmlkIE1pbGxlciB3cm90ZToNCj4gRnJvbTogQ2hyaXN0b3BoZSBS
b3VsbGllciA8Y2hyaXN0b3BoZS5yb3VsbGllckBzdC5jb20+DQo+IERhdGU6IEZyaSwgMyBBcHIg
MjAyMCAxNjowNDoxMyArMDIwMA0KPg0KPj4gQ29udmVydCBzdG0zMiBkd21hYyB0byBEVCBzY2hl
bWENCj4+DQo+PiB2MS0+djI6IFJlbWFya3MgZnJvbSBSb2INCj4gSSBhbSBhc3N1bWluZyB0aGF0
IHRoZSBEVCBmb2xrcyB3aWxsIHBpY2sgdGhpcyB1cC4=
