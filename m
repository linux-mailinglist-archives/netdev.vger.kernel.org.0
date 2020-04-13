Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B741A6829
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgDMO3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:29:44 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33744 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730781AbgDMO3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 10:29:43 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2E226C009C;
        Mon, 13 Apr 2020 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586788182; bh=VO15kNiZaDQe5Pszh7BE6EfL4+1jMkQTCFzzZhQ5YUk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=MKLByJ2TwqJvQGngpOhLBqFIdWu3iDLk9VE9iQ4LKSImmPnKY7Nf3SiabjXC+W69I
         kXMf3SG0jFwvdaNCwLlxb8xb+LYa+Jtqqm6zlD06vW2QDkVhNKytKCGv7l591nfGw4
         ASiHZkNDwEE4Gpunx1JEPq/ewhaDa2ohDdhkTL+whstmw1lUtusLErSrd1oYxZvSCc
         K3cp4sNHXsIXnsEWvAfxHdaElnUXqzBZifM5JtkTY17vzZT3IR6AbhoV1TEId1xcC8
         3mxwMjn8wQpI20ql76pi+57b6X958FF6l56DtN44XREvFEz+pX+4XSdRZ+Q3Y1B55i
         aEuOWpzDCn9eg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 91F67A0067;
        Mon, 13 Apr 2020 14:29:36 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Apr 2020 07:29:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Apr 2020 07:29:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkFqLrKMbI56ttv4c5mlLggKbdMdya+Klqt5Zb5H+9OXWlLan2FnAfHeUH2DjDYUG6sgRPVR21ZRkWlTgm/EuAim4RnJIjj6CV75sRYYtVr+uiq9fftzw/Biak/pAggOCv0q8Qcr967dx25+jyjygAhFZKiSCjLZQ7b1qz+0WTKKnWeGlYgGV124X5nvQdDszjgwXzVVegs27UWAe17UR2hHTf74FEUVIZzIaOvaHu6cLHhpD37rCh9snXzWGNMY+Vb9g/ToXE60l/qB7D0Ll59C3EerJQk7KZiF2niL2AJv5Oa7aYVkpIYYicYXvS5EIqNjej76xqy0BmeisbLFgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlfbqAROQkj6Fo8ryqN/xze/GVh72pWFbuLXKbLmerw=;
 b=StpXtRvMOtpk1vBLL3PnBNSqNQcz/JAEZGG/mlcW3rk2MKWncn90LebIQACDwcXOWL3ZoJFyj1+/eJEQnT65A6OuseM1k2PiwDRnmu5mN8cp1LbCkyEDEciBFLAafBDtcgAq6/j5FLXbnpG/Hj5N1QMeOPQOa7qIksGvmooChHQlFgzPyfSb6NpbKEB0ASWY/MiiVxrROIJFOB72u2+Bm9XBVADUGs2Pr/s9PZVzk6u+5hBsee0CL9YKCl5pXkM3Fw60VTVMkMNkv/ELMNTMao443rrIuWDMawNB4zGpZGHzfaUU1D78E/4p+XdL5vh+4Md1KFvvOOT2wJ5TB7rCKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlfbqAROQkj6Fo8ryqN/xze/GVh72pWFbuLXKbLmerw=;
 b=QMeRFhAVvNvJhVsZyfgMYvCqbLo6YeFWDWQl523uFuU4NPAcam8oS6C1PwskYURO+xtB11xud/mtP/TaC6PfEmH4y3d0LkM2Hu0O3DTV3oiICg0FNu1IOdo6JE3dNy1MNQETVITFX5y6o4m9T+lrFJVlEbc+CgwcBPzhVeFv7CM=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3538.namprd12.prod.outlook.com (2603:10b6:408:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Mon, 13 Apr
 2020 14:29:35 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 14:29:35 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: RE: [RFC,net-next,v2, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Topic: [RFC,net-next,v2, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
Thread-Index: AQHWDoZgVHd75nmJgUq/QPovrZ52nqh3IkAQ
Date:   Mon, 13 Apr 2020 14:29:34 +0000
Message-ID: <BN8PR12MB3266DAEBA9F314B0D1515B4DD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200409154823.26480-1-weifeng.voon@intel.com>
 <20200409154823.26480-2-weifeng.voon@intel.com>
In-Reply-To: <20200409154823.26480-2-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71100c3b-6ebf-4906-cc93-08d7dfb716ca
x-ms-traffictypediagnostic: BN8PR12MB3538:
x-microsoft-antispam-prvs: <BN8PR12MB3538415E591A45551659FBD7D3DD0@BN8PR12MB3538.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(366004)(136003)(396003)(346002)(39860400002)(66446008)(186003)(52536014)(76116006)(6506007)(26005)(2906002)(4326008)(66556008)(5660300002)(7696005)(64756008)(478600001)(66946007)(66476007)(8676002)(55016002)(9686003)(8936002)(71200400001)(86362001)(33656002)(4744005)(81156014)(110136005)(316002)(54906003)(142933001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcHmIUz2iw5H/9jjuosam0SRIlACPg1UFnURa2LJW5oU8G7FMDyWDpfDohgZs9oklr0Zx3t8engq9grEMLiSErskHz30U96ibrwFvwYxM/Fz3c0O4FAkNR4aUG2wPk2wxqa8u0NNf0Lo++kiYGLxSp7v9TCE+eGxRrVeI9OxTuH3sOJfXG/XKy4ngfjV361J9ibop1syzeENcqkmrLbRySxj8q1se+XHfA07qBTQl0LxKYq1BO5JSIFRBfOGEbvetMwVgxiKbTiB4/r2dkZve5pow9695nx954D7U2/lXpJVQZ/bcZbndntaJOVv71o4m93b3PUldtm9uH5Hut5bBvuuHRSTnlbDRBTAhAca8hwGbJL3Rafq2Oul8EP+sDsdQZccCbzdpRneAuswOezr2PrmVGiT/UtKu1tug2ZNeoazrkPYSeGVkj+dgEnqvPEtVWDh9T2TcKyDX1hP+kp+/I9VYFAOWJq7/fXRTudQ0Gu/TlFnBWIk59avqr/IMLmi
x-ms-exchange-antispam-messagedata: +sMX2D/JbbQe3EUark8RuGLBL01dllTZtg3OW36CwMzwNS36SlaU/8AWUO+S7Sr5MCcZEru52Lk9dOI+82IIPvDONHvVxC8zuZzmN+/tQr9fUdEAgqENC+JS4VihuHFVUBhA7I2Apq592a2ttWqD5Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71100c3b-6ebf-4906-cc93-08d7dfb716ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 14:29:34.9483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62l9KhgQ0wFBz5teWCk0kzCHWgqxuMVFhMecZT2y2DZ8veBkDbeXgmcCP3e9ReNYX8VMCwGEBII+eEGG6Vn7MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3538
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Apr/09/2020, 16:48:23 (UTC+00:00)

> diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
> index fbafb353e9be..89c8729bbe5b 100644
> --- a/include/linux/stmmac.h
> +++ b/include/linux/stmmac.h
> @@ -147,6 +147,7 @@ struct plat_stmmacenet_data {
>  	int bus_id;
>  	int phy_addr;
>  	int interface;
> +	int intel_adhoc_addr;

No, this is not right to add. Just use the bsp_priv field.

---
Thanks,
Jose Miguel Abreu
