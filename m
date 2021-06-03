Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB1B39A406
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFCPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:12:46 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:33854 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhFCPMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622733060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaChTEMbRpN5pGsbYSZIAgE+6yaNuHl/SeJZ+zKEISw=;
        b=d55qvNKkTBQ/G40V8mLKNqPHfFLmOa8M7u5rdB1MdlJ7Kjj16B7tnvw4ObZxw7TlI+3AbF
        vsPMmD3xlEaaX13LK6ows3AMNJGAU/tQ64FDh+OVioTGTvGRFj3J3qoymPdoZlv7/R6Mtn
        h5MahYjplRtIywsbsv/QBbplBLQEasA=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-8v53kOUPPj2hXmLPtPqPRQ-1; Thu, 03 Jun 2021 11:10:34 -0400
X-MC-Unique: 8v53kOUPPj2hXmLPtPqPRQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB4838.namprd19.prod.outlook.com (2603:10b6:303:d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 15:10:32 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 15:10:32 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsCAhAAgABiiAA=
Date:   Thu, 3 Jun 2021 15:10:31 +0000
Message-ID: <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
In-Reply-To: <20210603091750.GQ30436@shell.armlinux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [27.104.174.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c39f87f-b0da-4946-8fea-08d926a1bb23
x-ms-traffictypediagnostic: CO1PR19MB4838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB4838F37BA75B819F71E4355ABD3C9@CO1PR19MB4838.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TO+phNldvHSVDLYdoCniOjP9zp49ic0GVCdL38mzPjtWO4YRXFEaeiDon2XHHMW+xi3Uy1VX2z50aSp1oyDRbVzat0AhMMkNsEU3iiMT4XZfYDCvS6PKHY+ikgTQrWRWrp8E8breHwMGNYyracS+0J1C+ztjRiITMixt9qdx8z2K7KMaZc1zbdcFP6D5142bPpmCQslCy2W+a/d08JfbldnH4VqkfoPQ5g0I9GOjPIEh5Vc0/h7WFLcOexYiKn6gDHa4LfsyaE2oTjF1f01B535ctWLym6dSbJH7kom57o2VFcmITT/imnVfDqu6p3qbVEKwcyQFKhrIP5otswRSyuzUOIZXsNNJvIbkJIM6yZmyhhAb9JxolQhB0NGjqTp9xs5gE2gUsn8oHRVELQabNbllr1BF/rcwauhal0LSCloQ7nhWlbDJOqz5N9e4+VNBCwQmDoXlzwe2im97H/2GAeWFdOtNrvbbW0nPnbitEiEAN3A0VhIqdxLGGrKedpznyw70C+sPbH6TciPVyst7Xuh/92n/mhv2ch73BwXdET5urOcJBPtt0rHQdSJKMZi0t8+FRIbrK5jn/xFDfut98myI9x0ZWYCqrKg/oZXdauJU5jhahUBin/5ecUbLXvcgS/p7fKhX6buQDZIdeEX1gg5R7LOkGo25LQnb5JZVREbRDG+XrH/62zm8PXPZpEaa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39830400003)(396003)(6506007)(31686004)(4326008)(66946007)(38100700002)(316002)(122000001)(91956017)(76116006)(6916009)(31696002)(36756003)(86362001)(6486002)(71200400001)(54906003)(5660300002)(478600001)(107886003)(26005)(6512007)(8676002)(186003)(2616005)(2906002)(66476007)(66446008)(4744005)(53546011)(64756008)(66556008)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?RzXITZeyblw9CZTt2eL7+jkNq3xt8MTT2IJlOiVxNcE5rqjcqi1kix8J?=
 =?Windows-1252?Q?H1l+aQp42num3XAPd3EqVoir06jbfuk+vlnE4/aZ68p19zboBLT+tMvB?=
 =?Windows-1252?Q?hNGrBYeH1bopuCNnnDbAvypSvkhfCXCtfA0sRvYjt4PqVwcmqiKYd8ST?=
 =?Windows-1252?Q?2aojUcn4xY6G1LCmJGkN6d88aZBC0bW8E8OMhQfQ8HltFHmlEf3i4Zn7?=
 =?Windows-1252?Q?VyA+5DDP8OXUa54Ro4VsHDOPJwPDZeUVF+NO0Yg8KuvHFXvn54wE54Ed?=
 =?Windows-1252?Q?f2g+kJ8+IMrgSMq6PdlpkP14X0e6qpcoYZatNow+nz2tgGbWnpySZk3u?=
 =?Windows-1252?Q?T4RWTkKgL+AXEEQ3BSkW0RDGcEzasdL01E8iakA3BjZvHNd1T7J40xFs?=
 =?Windows-1252?Q?CIOEm0QERilmbwn9NQpmOHfvPySPBsGqPsOOJ6qlCp7/B/R0H709O0Ir?=
 =?Windows-1252?Q?v6UATjbLToHKweztkYz6i2qFjmytk6sYHQ6Y/2rE1Jc3rMoPdKKNmVU8?=
 =?Windows-1252?Q?CMh6kqYFh3wZlf1jGdRLldu9mUWXWo5nvu/mt2PCdqZgS1cJEfcQ46Fs?=
 =?Windows-1252?Q?CygBzTCdpMNlFrlPHf1PDocc35HbbKU3o45BJ1MOwh4RM2dptM2e99c0?=
 =?Windows-1252?Q?OHtJd8XlCU4uTFekbO/Kn1FCimKX/mF1G8o/KPdOj51eY+xouQNRlj50?=
 =?Windows-1252?Q?SEAFte3+wIgUuadjqWGb2qcTvetSa6jrjsbmz+/et6W2gS24hvVPUCq+?=
 =?Windows-1252?Q?yidf7rcpiF7c5WHrT+zxstySJA4YQk0MxBsncmVi50rVO1HQo15njali?=
 =?Windows-1252?Q?s/9os4//tT0wTgXqSdEyk/aHnOCPNCFAGaEK1zATqo7xVHgiQCPeF0hl?=
 =?Windows-1252?Q?gxSCNsvp/UAlSblo3hXzz76b2U0xyyCVZHC6iRuO6GkLoN4gblo4C9Gq?=
 =?Windows-1252?Q?NbBhpYXrVErp/AJPoVnRnNX6rYCcvK9UUF8VXPBlbObz+wL0kYsrY/rk?=
 =?Windows-1252?Q?ROwBZAXRuRxL7yVTp5iOU7UppMk/p9MbD10AJjNtRU+SIK7OZ55cLoAg?=
 =?Windows-1252?Q?q/0MhZQNZAE+EKPPk3WUz7YaOt/r5/rUlMNl/O7Goitb6yqet+VhGvZK?=
 =?Windows-1252?Q?q90sa5GJb7ytk1TC+BxGpuGERQ7x6+4r3mM20ISA51V7AUqnf/ziCAby?=
 =?Windows-1252?Q?dXk7OsN0cJtLi0eTbNZ6/W/CAXXPN6GkLP/jDIWzt4a6Z6jsvdztEbXH?=
 =?Windows-1252?Q?L0XQRZirTwHSUYsSr4G8aeTEP7a0e1HukANghTWeQT0Tgl9Duy9mnMCf?=
 =?Windows-1252?Q?u0Jqxk5nXV0oYN1Y1oMFl1u0MG0zjt+0W5Za4X8a1WTjbUQsWS6XXbbU?=
 =?Windows-1252?Q?+GrJIhq/jvK4CxWA8A+mQPf2r4DTSndqCQsAT9yWyDcbonqPBtS19DfZ?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c39f87f-b0da-4946-8fea-08d926a1bb23
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 15:10:31.8337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TO/xRHcA7CCQ7H4vjfdyN7L20QTrsTL06TSpjxX8YESb/gROJgBKAxM+JVYHSBoxSqfPWFcc9NuNhHujvRzJWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB4838
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-ID: <76C81DA46997564F9BC4409878D77646@namprd19.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/2021 5:17 pm, Russell King (Oracle) wrote:
>
> > +static int gpy_config_init(struct phy_device *phydev)
> > +{
> > + int ret, fw_ver;
> > +
> > + /* Show GPY PHY FW version in dmesg */
> > + fw_ver =3D phy_read(phydev, PHY_FWV);
> > + if (fw_ver < 0)
> > + return fw_ver;
> > +
> > + phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_ver,
> > + (fw_ver & PHY_FWV_REL_MASK) ? "release" : "test");
>
> Does this need to print the firmware version each time config_init()
> is called? Is it likely to change beyond? Would it be more sensible
> to print it in the probe() method?

The firmware version can change in device with different firmware=20
loading mechanism.

I moved the print to probe and tested a few devices, found in some cases=20
it did not print the active version number.

So I'm thinking to keep it here to cover all scenarios.

