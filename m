Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08B917DD4E
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCIKXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:23:50 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:47478 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgCIKXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:23:49 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 70B32C04C1;
        Mon,  9 Mar 2020 10:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583749428; bh=T+Pi6ip1wH0ss7UHEC7/TCMLumJEs/2l8bZ3HzA8UZg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Y0ozmwGPSiFSAd3X/Q+P/e3AQOLtq/G7jVINUEyqi7le+s5ox/BlQWCSIJxWI9Mpt
         BeeUpWLZ11rrv32T75mbBU9mjzjpw1nWh/HaOBbF8y0IPlXCxKJ1juGJXrmsB2FHZO
         yn86IAdaL/7yHDcfddZodoxDnDxDzMVuuZ9SJvRRLicgTu4ntwML+vJbn3fha2Z8TH
         ImVArYDVFZxTrnJJC2BAzDMOR5EgkJu/xe7Z67RT/k8UOn1Pm3qKOlhc9KgxIF5X0F
         rCEcSoJ0W298YJTR8dmhM4+UErQLumfLKUDzfpAJMVmg0vvBZnJ8s3itVSMuefkhJy
         3gKhPkj5nnElw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 36C2CA0073;
        Mon,  9 Mar 2020 10:23:43 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Mar 2020 03:23:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 9 Mar 2020 03:23:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGBvO4Tm5Ziqvqemafi0cdwPt4lwygg9smCPA8lBK8IKqgP1RyRMdU8LdKWo3W0qTXHnsZw+4PA/sBHctCPqWP7IaLFIykKR5ILAs344ik/QW5M/lxgSt6uEv5mORh47BtNoRvEwllhVgNBdu4eKKOnUXsm9uzWX+DdPjhAYt+zc+mLxufnFVFK4XrvSSlg+fSttrqV2ECZQoiv43CwlR+JhXVlqnZdgcFueS8NBd63VUCJtWwMiUnhn6IecBeKb4oatLYKcssAi059t5YtNxNAtKaQTsOfR2nzmetRbgHQ9pmi5iaXEL3FWDslsgP+h6VYfI9FzGT75bFxIdIQ1Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+Pi6ip1wH0ss7UHEC7/TCMLumJEs/2l8bZ3HzA8UZg=;
 b=JA4VXIGAwKkrAydpI1nhsSxv42jwOnNb6in1cv7MOKYqGU5VLW+o8sqsYEh0NgzCieueQ2uInmna4byD1Ao9hk+HL2UmdHo36/bE3eMBXdxK2nohVoXU2/LMb0jsGq0XpDUZt5kxdkGsk79QH45lbknHjg8AMdLQto8Tl75zzPvwtAUvEgUgOlNhjQ4T4+UeqiL6Z7cc/ZWYiB3cJgTw83kyQoT/B+kQJlONRk0FKRMwRvTr7YfgYjnJmZoKnRo2DFUqvsEIKlZ2bcCB3a1pNhdwo1FAt6FthTOzuBQfnwIrwonlAtjbDafYxPcZ+GdMJ0Zhr9b+RXUMsC8u9TbyqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+Pi6ip1wH0ss7UHEC7/TCMLumJEs/2l8bZ3HzA8UZg=;
 b=G+Iu6l5Xm5In0I11svTaysqLTpxOT+eo2e6BFYAdWK0N1Zg/OU4b//qMWxAGUq+zPZ+0Pp4ibfVcHsPywlk81sggJSpuQI2xGzE6qhDW4gbWoWRLlhV4kYUhH6A1XWf/RpMZ/V9qV+WDk2ZJOhYVanOUrw1zm3GfeMoZNkFZFjk=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3235.namprd12.prod.outlook.com (2603:10b6:408:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Mon, 9 Mar
 2020 10:23:41 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 10:23:41 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>
Subject: RE: [patch net-next v4 03/10] flow_offload: check for basic action hw
 stats type
Thread-Topic: [patch net-next v4 03/10] flow_offload: check for basic action
 hw stats type
Thread-Index: AQHV9HVFN/JIjqGKAkyi9LUKP+sk+qhAD/MQ
Date:   Mon, 9 Mar 2020 10:23:41 +0000
Message-ID: <BN8PR12MB3266F1691CDDA4352EFC2684D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-4-jiri@resnulli.us>
In-Reply-To: <20200307114020.8664-4-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72f7b91f-7e2e-43af-7df9-08d7c413f085
x-ms-traffictypediagnostic: BN8PR12MB3235:
x-microsoft-antispam-prvs: <BN8PR12MB32356C09BFFA88F9EE0AC409D3FE0@BN8PR12MB3235.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(189003)(199004)(9686003)(55016002)(2906002)(478600001)(86362001)(8936002)(66556008)(66946007)(7696005)(6506007)(33656002)(76116006)(66476007)(64756008)(66446008)(4744005)(7416002)(81156014)(71200400001)(54906003)(81166006)(8676002)(5660300002)(186003)(26005)(316002)(52536014)(110136005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3235;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hm1k6VGUAQ/4SwftnRkgL04XU+k90unnVE3AH0Zh1ovwqXNsKoiF1HuqxQapIeAlUp8LR/GFyMm5B+/HgBc2pBegwdfUpJBlJrl7acHo1CNNYFT0jO2MhL5sA0DPqshV9cNRB54OirGaKriXaiK5wRhmByPPywjx3tfppbrlaWHZd3eILSoWZY01Q0v4CaD3hwRbd58PHdp4YaL+oOOQFd6iMIyYVEBzrO52xZpIKT2tv90NnVQcMQEHgv+aqcLqjHj6uXadGoPBWEosBhNAA26WSv4NLUD6pIzHpvYq7R9KUZDvabUh64CnzYhkuNB3tY0zBy8H0BrwxH3xBfr9rEMFUFl8zw+XqoJVwfpeQ7eedk2xml7s/ljoKkfwtO8C5S82ndtGWAR/eg5v2KNGxXtmBlOjQkU6puwawEcxEotWNLenzx2/txTmYhX5jvHE
x-ms-exchange-antispam-messagedata: ruh9sfH99QRdz51Sv+Xx3a2fAR8Wa4IXmlty7rewcdRIEfQo9k4Y9YtRRGLfvkj20dScJ+seW676WEqquAvtKnbGgygS/NVenFrVG6Rs02TLFzdLHGQexj4GCcuTjzg4sojP4MpLfdb+O0I66YDEqA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f7b91f-7e2e-43af-7df9-08d7c413f085
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 10:23:41.3078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBJnhU1x1T/deFMkjJofX8Ufg4ShsaxXJ5ITOYdgNabG4bwoofKqTdzl6y9cTfmW8W/rD00WGMSXrm5GOTLuGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3235
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mar/07/2020, 11:40:13 (UTC+00:00)

> Introduce flow_action_basic_hw_stats_types_check() helper and use it
> in drivers. That sanitizes the drivers which do not have support
> for action HW stats types.

Next time please cc driver maintainers because this broke L3/L4 selftests=20
for stmmac.

Not to worry, I already have a patch to send :)

---
Thanks,
Jose Miguel Abreu
