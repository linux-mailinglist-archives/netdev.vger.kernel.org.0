Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92DC4A9A9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbfFRSTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:19:50 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:5478 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727616AbfFRSTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:19:50 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5II4PmW012832;
        Tue, 18 Jun 2019 11:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=YMw/V/I9oyyPit7giNT9NpcB84wYmzqJAEX+3gJFpDQ=;
 b=DOg+OQo6DxRGpgotjPkuAlkRKBjufoakiCXz0zAHGaiOfnaszHkz/WD2p3MNYf2nnmMv
 g2TeUZpzKRNt0I782GsQnjU3JucVjFp4Lc1HfFaAgOPPDVevELSyLVHVNexl5ZDBgPfo
 abVBXlzQm/C9pDudfA7mNtPHuhLrkSN3L4EYUROxrTNUKyVPnznVahT0ohEDw9EBwSOr
 y8HEVPoa5/uNMxawlUTgqOVMO0T1IgnM9rNbEMjUQlVxdK9/1epcd+v8Ir0DqX541HUo
 PB0nxSFH7SAaYvETHxtD24S3WJdt6lFcnGiep3YWe3Xu5m55i46Gk7aercKgrk5d/D6b bw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2055.outbound.protection.outlook.com [104.47.50.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wd9dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMw/V/I9oyyPit7giNT9NpcB84wYmzqJAEX+3gJFpDQ=;
 b=cYlOxl1ls2Iufcq3ZtIhCavqbH5MpLXVI+15NBLY+BsHY+QVOfrLPWgVhe6w78FukIRl6kYaNN2L8IihacqZ5X7Pi7a/cwMyD0He2xVX8UG3jYqB49OLnbjXui78d1NppoCBnCUGyYUGCuyShj0ChnSzuaeMZDVmVXJtRWv3mv0=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2694.namprd07.prod.outlook.com (10.166.94.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 18:19:42 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:19:42 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH 6/6] net: macb: parameter added to cadence ethernet
 controller DT binding
Thread-Topic: [PATCH 6/6] net: macb: parameter added to cadence ethernet
 controller DT binding
Thread-Index: AQHVI9UHZrbi6r3AI0iDpHN7ZLNLD6af+PQAgAHD6QA=
Date:   Tue, 18 Jun 2019 18:19:42 +0000
Message-ID: <CO2PR07MB24692BDF7EB9971A339D3DF4C1EA0@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642512-28765-1-git-send-email-pthombar@cadence.com>
 <1560642579-29803-1-git-send-email-pthombar@cadence.com>
 <20190617152118.GJ25211@lunn.ch>
In-Reply-To: <20190617152118.GJ25211@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1hMWNhODMzYi05MWY1LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcYTFjYTgzM2QtOTFmNS0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxMTQ0IiB0PSIxMzIwNTM1NTU3ODkyOTAxNDEiIGg9Ik1VdGJlZHB2cWpSWVE5bGlSMXdNa1VOR21wcz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da535dc6-21a1-4b21-b6fc-08d6f41988c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2694;
x-ms-traffictypediagnostic: CO2PR07MB2694:
x-microsoft-antispam-prvs: <CO2PR07MB269437D28491E247C551B00BC1EA0@CO2PR07MB2694.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(346002)(376002)(36092001)(189003)(199004)(66556008)(186003)(6436002)(66476007)(6916009)(86362001)(66946007)(76116006)(4326008)(53936002)(66446008)(5660300002)(107886003)(68736007)(73956011)(64756008)(66066001)(4744005)(99286004)(3846002)(478600001)(6506007)(2906002)(76176011)(7696005)(14454004)(6246003)(26005)(446003)(305945005)(6116002)(476003)(9686003)(11346002)(102836004)(256004)(52536014)(229853002)(7736002)(55016002)(81166006)(81156014)(8676002)(486006)(33656002)(8936002)(74316002)(316002)(71200400001)(71190400001)(54906003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2694;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BE5a78T7JU2xT6cLcRFw0jB4JBgCdx81yjXXnmG7K00y7whz70d+jc7HaIlk4KtSrtS1Cgt2aWbXMaNn9gx1JNRVSoZSl6mNSGWKCE8q66Z0tBYv9ELMn57Vb4/RF6bO6Y9UUCk/5Sb0jlcCjwH4QP0LqRrNFrvhXoHArLbCxzsyYvSgx3ap7sfIW3sFUGcrHJqHe7xYHg6w4pOmabERd8CEc0flAEP7t3Wt22YSjaAv8uH0LxNXuuNP6z8tKIS4YHMDj2QqhVJQJ4jb5MXne3hV9mMd4T7Cl1Q0V7W9t27dua1HID6gfhBcVWbAu8AYbSFahM+ZoUZ6uCm66nhySQsSzfuRBpT/bjeK37hR/TVN7wZPyceVShZBxdc21PevbKyL4LSe/HcIo8RCWNGt7R5ndYrimm+U8Y3zyDV4N9c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da535dc6-21a1-4b21-b6fc-08d6f41988c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:19:42.4197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2694
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Sun, Jun 16, 2019 at 12:49:39AM +0100, Parshuram Thombare wrote:
>> New parameters added to Cadence ethernet controller DT binding for
>> USXGMII interface.
>>
>> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
>> ---
>>  Documentation/devicetree/bindings/net/macb.txt | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/macb.txt
>> b/Documentation/devicetree/bindings/net/macb.txt
>> index 9c5e94482b5f..cd79ec9dddfb 100644
>> --- a/Documentation/devicetree/bindings/net/macb.txt
>> +++ b/Documentation/devicetree/bindings/net/macb.txt
>> @@ -25,6 +25,10 @@ Required properties:
>>  	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
>>  	Optional elements: 'tsu_clk'
>>  - clocks: Phandles to input clocks.
>> +- serdes-rate External serdes rate.Mandatory for USXGMII mode.
>> +	0 - 5G
>> +	1 - 10G
>
Ok

>Please use the values 5 and 10, not 0 and 1. This also needs a vendor pref=
ix.
>
>       Andrew

Regards,
Parshuram Thombare
