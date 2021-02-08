Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CED7312CF4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhBHJMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:12:37 -0500
Received: from mail-am6eur05on2111.outbound.protection.outlook.com ([40.107.22.111]:57441
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231330AbhBHJKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 04:10:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEfkVILw9Lujx96PfquCEt9xBKXi7ptCbAvbNE4YbuslwR78uCbLN37I5Fh+WUks/mXkOL7Qvv5AnAON9s6rUHKltEvVbxBKaSzT5awKII2DurLAIV3UCAlpyVaaY6oqlN1TLCtexuBqPQhzTb5HbQGGhhfHQ6cjdn+2U81WM8M2E1QdpTckT72rWtdbrECGyCjjNthaSEmjxP81WIg8csKNQwaXkdDLajWuuY94u4Z7w1xB/DikwSW2iSEZmCsq75/Q1OVESD+yQosOzdYYH5nGIXCxhUdd5+dRzMKRkTJiR6AdVkmtI4vEp7OtaI/PbN91TLj1Atatl0gssh+UNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCWiAM17MQWzCdDJKtsVsvBWs/K0B/ILGGtSbCOr8KA=;
 b=KW+s/APyM725vdNWfiT7K0UbzUgtdbBe4EKh4tg62rmkY2nbPCWqDizhOv1BFMZDFPMkIgzpKrxUgK3NTQrSeNTmBWLSTgMKBjTQLyUGbkoiH+Ln+WNy50Om1aSFAG1SSrD5NNzpvRqaFeagVYprU0dEJ7n33XVCHK36jbJYfbriRL5ZuBkG5CNmC6qwGyAxJ/91BB1ROmo3drzYeQkEMpZ46HQvS9FGwL+XM6+YQhLqt9MUYXee4CW6U3615yC+sKw4CPhN2pbZ8lpZ64/spHELbFQC02dK4cI/nu5KwO+La9LuOwDgE/Dmx0eLAfXar+Kvz5jXjzt9BS0PiHCxUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCWiAM17MQWzCdDJKtsVsvBWs/K0B/ILGGtSbCOr8KA=;
 b=fKa7Y9JcVounQxTNuKxQ/BqxWTjsixa70RsUMeMEGnGq+5dNNkG4xsWapOd99eV3npiGgRF3oxzHgPMzfah0ygbfUvEYHxl6mnMMbUqov7ImyzXRM3FvW5EC0rIgVb6Oo2CWcckr/93amRd36cxYQhiFjIyJ7l34K/i2+Ny36ro=
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com (2603:10a6:10:10f::27)
 by DB8PR04MB7081.eurprd04.prod.outlook.com (2603:10a6:10:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Mon, 8 Feb
 2021 09:09:42 +0000
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9]) by DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9%7]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 09:09:42 +0000
From:   Pierre Cheynier <p.cheynier@criteo.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Sokolowski, Jan" <jan.sokolowski@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Topic: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Index: AQHW9mMY04hDD4/GNkeljus5vphnq6o/gv8AgAUiwUSAAG7wgIABbtmAgAAHK7CAAAw2lIAAGsEAgAdUU2A=
Date:   Mon, 8 Feb 2021 09:09:42 +0000
Message-ID: <DB8PR04MB64608A64EA7B4ABAC3A15EE1EA8F9@DB8PR04MB6460.eurprd04.prod.outlook.com>
References: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <20210202083035.3d54f97c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM5PR11MB1705DDAEC74CA8918438EBA599B49@DM5PR11MB1705.namprd11.prod.outlook.com>
        <DB8PR04MB646092D87F51C2ACD180841EEAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <DB8PR04MB6460398CFCE47ADD5EE773E1EAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>,<20210203090842.22e5ccb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203090842.22e5ccb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=criteo.com;
x-originating-ip: [2a02:8428:563:1201:bbc1:d85b:63a5:7ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2a0729f-b632-4ce3-6147-08d8cc114570
x-ms-traffictypediagnostic: DB8PR04MB7081:
x-microsoft-antispam-prvs: <DB8PR04MB70817BB4BF173B2A1D468CBDEA8F9@DB8PR04MB7081.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1IHA4EHWFVrmA7OXYTVeT9gvkg0lI7FF752e50wETa0GhjjfRH2fvYYCweb3JnCNrIwmhK7qm+Bf96WOJ4a3aLZNB92TdFNXjde/knWOZBoNtMpDt7wAMCswikg0P812Tv7DI8cTqHa7Es+ZSwUxBeMpQwDramJokC464+OXTqaacb0vzNkCdPeqD4Ad818ObsSV0MMDQnEmoPyJMY9FbTzEelNN1VzQ1gmMacjNPVgCs9oUbhtqTBVRN2CU+lAyvIEPeSUBXLAu4yoEUhqzdWmViayu3YpUuPQDMdG4lF/TLxCSIbCv4Sxccic5/D8oxeie9rOUK/ueMpim5G5yy4A6qxDj9AdnPQ6EMwQQIAea5UPWAhaRS8TdsdyX3dJnyuvTJH6zjKzUVY8yPEL1CSQy0fikv8HNEy7Kb7HzsKZWi1lTbA9O7BcrqGhQznUiEh95rWbXH9kNqaUx1HPXrdZEIlBdSWjPakZjncgHz2JFT1V5xh5xb9mjRVqCPqqAeFf1tGGO3xNoo/LejSJfZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6460.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(376002)(396003)(366004)(52536014)(9686003)(55016002)(2906002)(8936002)(478600001)(186003)(316002)(33656002)(66946007)(91956017)(76116006)(66556008)(54906003)(71200400001)(66446008)(4326008)(83380400001)(5660300002)(64756008)(8676002)(4744005)(7696005)(110136005)(66476007)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?S9WmcW76STkCbvtEmOhEi1echKtKfIUYsjnXk5R9/9c5B21E+GxIgMvxOS?=
 =?iso-8859-1?Q?P9cTfZt1WImqLIF3hsRF+M/RdwCTZXiJljygoLxC608i+bhlpVCh8BklLw?=
 =?iso-8859-1?Q?IYsv+sQqQei19u3R3mDQaxVfGjJSBmlJNnBcTXTyAr5AOqz5vLvFPntNyu?=
 =?iso-8859-1?Q?drguzc0aXGZ84yCt8FpVLbNDvHrZJ4LDgC17SOa+Qr5v5pw+k5t4MDKrrp?=
 =?iso-8859-1?Q?KvLuBl/xa6l1LP3MWPN+5Xry3DMGONu9DOubB59Ub7fD/Km+LGRzg1FSVx?=
 =?iso-8859-1?Q?yw4EhNSci3eDUPp24nLTA5MoD+op8X/m+AacSocpyt99gRiwK52y6e6YYi?=
 =?iso-8859-1?Q?J07w9P9nJFlhiszl7IjGv9KCH48ikpuDIb9BvpqGBiTbOJ+QP8C+hnc6vO?=
 =?iso-8859-1?Q?BtTG8fHK8cAvuILhQVnj+zAw6J6C3O6NxQSYbyP/5cbNmXYCgiGqnSMXfe?=
 =?iso-8859-1?Q?PlZ7gzRFFo/NQ88HcA4pwKeplbXoEotvNZ81VGUacvnIoF2eYn7EjXudCp?=
 =?iso-8859-1?Q?hn7WJnBkKlM85dHR4FPKXKbhuz7cNjsti2x5umP6jVzg/gn9LiN5UUMR9R?=
 =?iso-8859-1?Q?T+kQ+220FdmgLgHYR5oUbf2DD21/JbArmJ/w2rgVR4nxczZfRJOX7KQc8k?=
 =?iso-8859-1?Q?sfB3U1p9sUXFrHWB3BN7moHSztqIC+1SPjKKFsH8LpW9OgWdCr5vgddRg0?=
 =?iso-8859-1?Q?LJtDsWqyOK+YH7/86SZ4xNKdaakANd4gbmRfBH2so1LKznNC6W1uhVMJJb?=
 =?iso-8859-1?Q?VimlptG/FEh+LNDc+0jEP5wYheXug8/JNamzgVOehCHBqv2B1kUKYPuZ4c?=
 =?iso-8859-1?Q?h0G/IP5CA5C7FhCCVYdXUXSAwX1SC790i4NQynrB0e/+bSL3vBB0h8U9bp?=
 =?iso-8859-1?Q?bNv8Sd/1I5SsKco3gVjdmiZMRkWu8jt11zq5CJSvhybTKU886xBu/JqWjO?=
 =?iso-8859-1?Q?OvLdW2/7IQETG8aSglsu5UF4SAcYvbjlik1Ihy0226NQS5ayxg/mBqzi8Q?=
 =?iso-8859-1?Q?0uuJPxRF8RM9y4aeovwdVdUJixept01n57/sv/Ev5NP7fLgXp+HPe2gW4u?=
 =?iso-8859-1?Q?Ul+IEydvk/D3kUG6fZlg2cCssXHCNDAr9Kky5BMCj0MAMg/C0YJbmquvAb?=
 =?iso-8859-1?Q?VtDwAcAgsy5cHn0SWAXQgylRDwS157FunKwZOMVIhR6lbOVN7u8K+8kuQY?=
 =?iso-8859-1?Q?yMS/uojxZeUx71ivk2TkpUHAQxVkrlxBHVByoJDiq3HGizW4beSvAtc8wY?=
 =?iso-8859-1?Q?gxYqWQaDMjXdaTeEdGsRLxXoATTX4f9t+iMJ6W6M4RLmrgs0Y1vzuBxjCM?=
 =?iso-8859-1?Q?wAaX13fcsznnfvZ+5SVTyNyryjtjowM/qeYg30fxTkDWP7v1K+2Kg5Ydue?=
 =?iso-8859-1?Q?NO7tznU3T0GXGZZWBXXubDmOtDFtKIt5zw7HeCrW8ZsCnkhD2xICE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6460.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a0729f-b632-4ce3-6147-08d8cc114570
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 09:09:42.2529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ds7I/gFxFjYDE6rV/5g0a3oWpku8Jqh/Yzy4EWjpRjMkSs5vbWRYTu773JbAzmsEen4pOw7A2yz5DPQ87QGew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
On Wed, 3 Feb 2021 18:08:31 +0100 Jakub Kicinski wrote:=0A=
> Yup! I'm pretty sure it's my conversion. The full commit quote upstream:=
=0A=
> =0A=
> 40a98cb6f01f ("i40e: convert to new udp_tunnel infrastructure")=0A=
> =0A=
> It should trigger if you have vxlan module loaded (or built in)=0A=
> and then reload or re-probe i40e.=0A=
> =0A=
> Let us know if you can't repro it should pop up pretty reliably.=0A=
=0A=
Not sure if this is under investigation on Intel side, I can help to test p=
atches=0A=
or provide more info if needed.=0A=
=0A=
--=0A=
Pierre=
