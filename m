Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45CA1A6468
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgDMJBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 05:01:39 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:51714 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgDMJBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 05:01:38 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2F7BAC0361;
        Mon, 13 Apr 2020 09:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586768498; bh=F+gVWkweCnxiZLz06Z04S76+3XrQurR+AF1Y2DC3u90=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GSG1B60nBKQFt9cmUbhNOyq55SWQi0Pj9LRd4QKdnjDq8sM8Ua1iZT6WILInvwPXj
         DiYTwGvfZrM+qcjOyvJqO6GqLwsJPo5deN0zz93VbNoXqLOL5BBCqOtKuwniaDWzJN
         r09rEXAsB8vWn1e8x6MNgSYfIdBGnvuW5hAfBs15ZONSPOEjrWjM9SlKjgShaTbY3L
         c5IGJds612Duqz69hAYa3Me78leQ0Z9dHMyWnul0FL/XvzDgwXOk99nukqpETup8R4
         yzhHpXHkbbKFD7HX8KZP4+by4Cg5d/B0ly0qm9uVcXMzjoLHWSgbY6RcWSs4S66wQ7
         O/c35SmNwHMhA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3CF98A0067;
        Mon, 13 Apr 2020 09:01:35 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Apr 2020 02:01:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Apr 2020 02:01:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVIHIst+uXcTGTZN1DEWD0nVxzvuMZ9pSfz1iSTxcz+yZx6ifH/OPAMZ52T6Cj5LMwVtrWSw2jlR06eYI9ryqIorH/xPIsoOu55sGZE+rqkwaogr0QysZHF4IXJ78M8RUjnrjQGc3jd4b35t00jmTCNsykMT6fMmLylBnzF+xYuV2wzBy837r2FmhUESFOwGGXSsEJvfXEy5G7fmmaONRHWSyxeq2qOzvtcOtO9wJ6OrDWZbJoof9dpxEjrc1KGbJQxHqxRXlM/pQqXwdvBi7ABeBhGOaPs5WLAHw5EFP3RgFdzgWoHA6skjSxWAich13g8Q4Cg1Zct2R6ZbX/pXSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZcm5qclCPrFkIp7FKym8UeEDbOY+eB2tDnv8hEEzp4=;
 b=oGjHKcJwElQnsZks/eVcgq2/cFoAQdi1QVHttVDOLPE/m2TLZhgEriWzuvFllfljFPggOAal9RDBMVSSP5Vnnml6DGX8RF8mnGqNY/55/sw73tECj/vJbZ8DaamKiuc64621prFjrVDhIHTSA4j2BQU+b1+Bmp2lJvYf9mgl2HQ0g+OOCyhJnIiTw7c2CIrHLsOtDHirLtILqvYmFyLEzi1qWtkuJjd1LEgNgJA23muU4kv32EFT63Mg9r7ru/xdpaS8LZIw7D+s/1eeLPKn4TKHEesIMBX4waRNKv1Zymz4paanpsZWrXpCjp9BmpP9KAGsPmSoxTu+X+3kPS2vvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZcm5qclCPrFkIp7FKym8UeEDbOY+eB2tDnv8hEEzp4=;
 b=vmTXLgEOSxfBg0KEYvaHntVPV2/2VHE1BEDOziPk20yYcug3eAGDLAaCG+4jf/3uMQvVI3YnVO5GolWZV6PaiBC6YU6fvktYDbaosxpm5BcrADBMQv+LtWMWNyk+WLu4HpijubZFmMcRA4Tc2GIvZYE9uhgvKLL1PYtPuJ2b9Qo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3635.namprd12.prod.outlook.com (2603:10b6:408:46::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.18; Mon, 13 Apr
 2020 09:01:32 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 09:01:32 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Thread-Topic: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Thread-Index: AQHWEJDvA8zEZsFxqkWKpdmc7/rynqh2wgkg
Date:   Mon, 13 Apr 2020 09:01:32 +0000
Message-ID: <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200412060854.334895-1-leon@kernel.org>
In-Reply-To: <20200412060854.334895-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce465346-b527-41ff-d7b2-08d7df8942ff
x-ms-traffictypediagnostic: BN8PR12MB3635:
x-microsoft-antispam-prvs: <BN8PR12MB3635BEED5D576B5344482883D3DD0@BN8PR12MB3635.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39850400004)(396003)(366004)(346002)(376002)(136003)(71200400001)(6506007)(2906002)(4744005)(86362001)(7696005)(110136005)(478600001)(54906003)(55016002)(33656002)(8676002)(66946007)(81156014)(64756008)(76116006)(66446008)(316002)(66556008)(66476007)(52536014)(4326008)(5660300002)(26005)(186003)(8936002)(9686003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qEpu1EBaD+2kfHXffF+6hi3K3nyT68fuSmOEVCiUYrPGqnMDF4yokujJ2vFw2+HUodaXTgCQ6hHWkxVJl64C2Va1VPagXRCxtjZW59l7IcyhNINNJdtg3VSbl+l/1XCi6xJxajizBJTdL41JLqtxAWhr25MWBXo3ADUGgOaK4NtI+rEYoXxnDF7qASfRvjK+yxVsZkoKgzYugHVmwLK0m4QCX6J+yhfu1Tvu0MWQcDRAnxFgU2sp2RLQX3rO2XOxCSUjp6fX/a9Kyor9oBJuXiMEaN7VVYYN4y1dCyBhyITWeZUjxFDjEgxJjQONa6CP17p14naxUbCRn2YRxgfQWorNcFL95JVMggrrabHa9UD2bf/l8ZnwfTz22V7JwO6I43o6rXnPSounrbCvDI9TECvRZ3j3vkX/p/aj13Hw2BLWBNTFgtUCi8JhPoCG/nNa
x-ms-exchange-antispam-messagedata: ef1JcKLMVi+iEUnK7AWxHu6aUhNLsxdGBnebvDepNBBh+Ba3f569IpCLXXEmssghAwe5Htg7azcySV8IyWxcXZ0UEI/wKZCf7lOceb8XsBY805C1VRw+OlDmEVVKPz8aBCmpeK2T9C0XzZayFotdHA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce465346-b527-41ff-d7b2-08d7df8942ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 09:01:32.3281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DMjUPlsMcVq0TQkPosLDohd6pMo/8sBcrV9/aWCto7rqvtrWMhbL5yMmCog90DAtIt0bXU5Q9V32qo1cpebX7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3635
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Apr/12/2020, 07:08:54 (UTC+00:00)

> [  281.170584] ------------[ cut here ]------------

Not objecting to the patch it-self (because usually stack trace is=20
useless), but just FYI we use this marker in our CI to track for timeouts=20
or crashes. I'm not sure if anyone else is using it.

And actually, can you please explain why BQL is not suppressing your=20
timeouts ?

---
Thanks,
Jose Miguel Abreu
