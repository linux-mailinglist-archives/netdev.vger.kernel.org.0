Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402232D09CC
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 05:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgLGErD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 23:47:03 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:8441 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgLGErC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 23:47:02 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcdb39c0000>; Mon, 07 Dec 2020 12:46:20 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 04:46:17 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.58) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 7 Dec 2020 04:46:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCS+2ZPxd7wdIKa/Q33GX4RseuMpgQ+IywyOEZBCI10o1v+K7NHLIASDU9AuV7PXyENfJk7EGq6exCHFj0p+jv/Nf+BrHtaQLo4pN6QOkZ23H/z0rgLHsoBNf074B1Qj6P+RUK/rNthidH6s+Pkf2OBE/82HIfQJma/sJJrN58PdOdxFag46coCZfDQhySELfaxL8AFbI5vz3AsUWClBM0hY2VXEJf7cyO7vlhKenRr8dRR8RzAgZs/6tXzy5GI308Ua/DVauXVbLI+cbT1A2xwcDLWzvJxyPsNZ7lzFqAXyiXsNcK7M1G87kReRR1eHbsGA9L3Fv9coUq9WYdcZnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N15RPja9ePWIIdQuqX8/BiZl8m9Jc0sazJ9XgxHiPS8=;
 b=grgM+C1vh6DzBDMgrXzeTGoMEJwJp7F10X3Tr6VLu35ofgD3M4oaQbIgrA3QAQO+f/TI0L7r29EVBDyOqKBcMfIKCXTxSxn8TljE7t9oV2ug37U1YRxIovicdekHAbMJ51f5CiBtEEDRxVSSKPzk4mD160SCGS9TsJWh+CFdUct4dnHh01KpBZdFw7fqwJu4ZwXTkKuZFAZ7Ewc+I6kL/Dwm/gMRcVoOVYWx/9StJIP44MxXy+TnDCCvg7uXA80+bYYnoyLJMwOTIr6YVE8fKJB5+16d7BNTlKFbQJZqZlJotTZs/AeDmaMxvrXeoyowKwgzsfaCU5siLNeQ5kf7ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2773.namprd12.prod.outlook.com (2603:10b6:a03:72::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 04:46:14 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Mon, 7 Dec 2020
 04:46:14 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v4] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v4] devlink: Add devlink port documentation
Thread-Index: AQHWyZ6W5Pc9bv0Emk6Xe437ZGSmIqno9s+AgAIatfA=
Date:   Mon, 7 Dec 2020 04:46:14 +0000
Message-ID: <BY5PR12MB43227128D9DEDC9E41744017DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201203180255.5253-1-parav@nvidia.com>
 <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8def60d-c73f-4a89-765b-08d89a6b0761
x-ms-traffictypediagnostic: BYAPR12MB2773:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB27738793DDEAF4AB3B38C403DCCE0@BYAPR12MB2773.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QSixjHA5s51ODc2AFZPpvtdaGJnUHzI3eG8Wq5qB2cKc2SgbAHmQN56MSd7LOSrGnGwpu0K8JawonNsdRPmz1VxzbY48SRKIfoCecmq2/6SFolx1c3yYzBGUopSPVZ+BST8NSu6Db9Srd34Khp7n5tW/o1xnLY7zWosbuCUFJGTTB3KHuBt3B3/kfQWfTpTV1mqTUFtP7RkAhJf16TY/ab8pjLCWbPEZk3QZdLV9gCwPs/lL0N0PQP1ltlL1PrOdUYA6Xl52GpDofWw6RG7rOwlKH8NWwyUlFPBNFLnN5D6PNAEKBhpMhJWFoYEUTv0/LxqTprf/pz8ofPBvBEStlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(6916009)(7696005)(186003)(107886003)(66476007)(64756008)(66946007)(54906003)(86362001)(76116006)(8936002)(71200400001)(66446008)(66556008)(9686003)(33656002)(6506007)(2906002)(8676002)(55236004)(5660300002)(55016002)(316002)(26005)(52536014)(478600001)(83380400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?496fFhCbD/eLose3BGS7opGEZaIRU6V4ZBeyFXBGghLjgee3r8pmlSQOJqps?=
 =?us-ascii?Q?GlEYtM9Yqa+eVLOmZSeLMTPXUFmyx9MR9KE06lXjOSS6n0eLOVIDKHL3axeV?=
 =?us-ascii?Q?pPCORsj7SK0CvPm2mDMB7/WSbWEwkPvGERnoPQh3MQLeQfYA3NIIJMfpcRXo?=
 =?us-ascii?Q?326F2In7odq9/IuH9f9IVWXUl1tCUvrveqjJqq2HOBtHi9R2x0z4Omp8A2MO?=
 =?us-ascii?Q?q/Yhk3P7FFecSvInE0P1sKdMfwN4vQpiCtg67jLZzDNU/ixNn0P8lkJHN0lw?=
 =?us-ascii?Q?o54ogoiQqbCUwSOFvD4VTIXnKtybg+Ln0CUjzIBHu6krPqI7bkf4edKbLISg?=
 =?us-ascii?Q?ae3uo2LZPVmA5u1HEtLM3Mk1KpTtbtLFcCSLBZQoFZMCmio2gGuCHepEm2nr?=
 =?us-ascii?Q?lbP2DYXT+EJJnqEcLGsN2KSWlAVjj5FlNMvNWbPRePguf4lVHBOwQUAlPguh?=
 =?us-ascii?Q?vlFNDQ4mG7nDSyAZg8lPHTRSRY3yGnoJCrTYEaxHyPDE4+62pg47OTV1GXYb?=
 =?us-ascii?Q?u8s0BpLGwACfPVh7Zta5D99HIcC9/G4OdZ2VR6f7DXJgWQbKG7KmFDa6vQ7R?=
 =?us-ascii?Q?kUxSxW/sqqixv6NyOjEHgmRG1hx39pCWnEcdb0qMRJBuSQtBpqXihfNKpJAt?=
 =?us-ascii?Q?fSK+88c0pJKPs2C0HS9UI1kbsyb7xLfE1xQfkZSf77uhRHUix69OIHowB2An?=
 =?us-ascii?Q?qFUrgqTx6LO5bhN/sNys5h5Nsqw+Qf6QO0wLeNMG1ffegZDa3sPcKA64Auck?=
 =?us-ascii?Q?+2s4JPPQtEHwcgVq592BKrDtBzWSEPMaiZcmKY0YRLd2IMnIkbVuVu5zq9UE?=
 =?us-ascii?Q?kKjg41/TlLoiSmF86x0f+sCnWJIfnIhFjOeuPc8G8zVGEB+Pf7GCWD8iPNd4?=
 =?us-ascii?Q?DYGtBgi8LWT4pwOmIud/oUzXHSgWMS/GuTjqfukevUADnYOulBmByHQ8GE9o?=
 =?us-ascii?Q?tMFHDXXzNyZhplLh+bK+9iSma4gRU+SyHhG3cikiFAk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8def60d-c73f-4a89-765b-08d89a6b0761
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 04:46:14.7099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jg+KQHPsdzaMgpt4Tywrn32mo0hqtWMhFIceZ9Acfmi3tPMxBe9Pi6TQscNUy9kVIp/KZsOr2IlwXd+Hy08Bsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2773
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607316380; bh=N15RPja9ePWIIdQuqX8/BiZl8m9Jc0sazJ9XgxHiPS8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=AqpSobkQftSoIdlXDE+w655PN+Kw9S9hFYhRBuoTctzoEjcreR0Y/KuhxvRY6T5Jt
         eyc/6ThAKdd8uPxFxYA3G6yp9WOCGT10UChcDuvFOOgmwIsZd2PQWQNXpPCbwWmAoG
         buehIj6hN5B5B6lxpgtGOaGdJ6htR1kp/trW2XMZDfvq8xU6GfrEk05NLkWVd5HxHP
         BBXy3NwwBbxOCBVDKIn8I0wLHQWFXNZ/UpjWBOW7Z5vxcO8jjYhMXm9DXISgqVyLj/
         V6C6igVrRThsski+EWPwdu6OxAUlnPUIlb7z58T+uJg60xF117GE1UZTvssMoG3MCB
         cxcQvyGvcDzPw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Sunday, December 6, 2020 1:57 AM
>=20
> On Thu, 3 Dec 2020 20:02:55 +0200 Parav Pandit wrote:
> > Added documentation for devlink port and port function related commands=
.
> >
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>=20
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +Devlink Port
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +``devlink-port`` is a port that exists on the device.
>=20
> Can we add something like:
>=20
> Each port is a logically separate ingress/egress point of the device.
>=20
> ?
This may not be true when both physical ports are under bond.

>=20
> > A devlink port can
> > +be of one among many flavours. A devlink port flavour along with port
> > +attributes describe what a port represents.
> > +
> > +A device driver that intends to publish a devlink port sets the
> > +devlink port attributes and registers the devlink port.
> > +
> > +Devlink port types are described below.
>=20
> How about:
>=20
> Physical ports can have different types based on the link layer:
>
Ok. will add.
=20
> > +.. list-table:: List of devlink port types
> > +   :widths: 23 90
> > +
> > +   * - Type
> > +     - Description
> > +   * - ``DEVLINK_PORT_TYPE_ETH``
> > +     - Driver should set this port type when a link layer of the port =
is Ethernet.
> > +   * - ``DEVLINK_PORT_TYPE_IB``
> > +     - Driver should set this port type when a link layer of the port =
is InfiniBand.
>=20
> Please wrap at 80 chars.
>=20
Ack.
> > +   * - ``DEVLINK_PORT_TYPE_AUTO``
> > +     - This type is indicated by the user when user prefers to set the=
 port type
> > +       to be automatically detected by the device driver.
>=20
> How about:
>=20
> This type is indicated by the user when driver should detect the port typ=
e
> automatically.
>=20
Will change.

> > +A controller consists of one or more PCI functions.
>=20
> This need some intro. Like:
>=20
> PCI controllers
> ---------------
>=20
> In most cases PCI devices will have only one controller, with potentially=
 multiple
> physical and virtual functions. Devices connected to multiple CPUs and
> SmartNICs, however, may have multiple controllers.
>=20
> > Such PCI function consists
> > +of one or more networking ports.
>=20
> PCI function consists of networking ports? What do you mean by a networki=
ng
> port? All devlink ports are networking ports.
>
I am not sure this document should be a starting point to define such restr=
iction.
=20
> > A networking port of such PCI function is
> > +represented by the eswitch devlink port.
>=20
> What's eswitch devlink port? It was never defined.
Eswitch devlink port is the port which sets eswitch attributes (id and leng=
th).

>=20
> > A devlink instance holds ports of two
> > +types of controllers.
>=20
> For devices with multiple controllers we can distinguish...
>=20
Yes, will change.

> > +(1) controller discovered on same system where eswitch resides:
> > +This is the case where PCI PF/VF of a controller and devlink eswitch
> > +instance both are located on a single system.
>=20
> How is eswitch located on a system? Eswitch is in the NIC
>
Yes, I meant eswitch devlink instance and controller devlink instance are s=
ame.
 Will rephase.

> I think you should say refer to eswitch being controlled by a system.
>=20
> > +(2) controller located on external host system.
> > +This is the case where a controller is in one system and its devlink
> > +eswitch ports are in a different system. Such controller is called
> > +external controller.
>=20
> > +An example view of two controller systems::
> > +
> > +Port function configuration
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > +
> > +When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
> > +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the networking port of
> > +a PCI function.
>=20
> Networking port of a PCI function?
>=20
> > A user can configure the port function attributes
>=20
> port function attributes?
>=20
> > before
> > +enumerating the function.
>=20
> What does this mean? What does enumerate mean in this context?
>=20
Enumerate means before creating the device of the function.
However today due to SR-IOV limitation, it is before probing the function d=
evice.

> > For example user may set the hardware address of
> > +the function represented by the devlink port function.
>=20
> What's a hardware address? You mean MAC address?
Yes, MAC address.
Port function attribute is named as hardware address to be generic enough s=
imilar to other iproute2 tools.

