Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E372C39F5
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgKYHSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:18:13 -0500
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:4686
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726715AbgKYHSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 02:18:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvJ9dHDMeIU2GCOWoR4V5asWPn1cR0Lqs0G8R7JDgO7y9FQQ9h7p07P2xI9w9y3A6aSBjC8t4bMr4RavqL83DSukLUFlciVUx3wVHeN06e3AvK2g5rMGfrc1nGqG8joawMK/4Fjxxb6hsL07f5tcx50yuCzmvZFDl9SvpRgjAbhby97gO5vOR+ngeuxI1HMuW3QGfac5jGKq8ScAPYDtabcs7t4CznF0zlkaN6Lavdn4BXRXU5skBLVFm/rWfpg21CcSsmrTfEP8QsOYbBSrYljz/fyuRMNS8Fb3PhrCIbbfM8VCQMkE7eZVPIfbPM1bL31cxGw8I/csIsntqIXmAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kH4V+RUd5MyZGy/907Cvi/EHSVBmMhjT7/WF68nKz8c=;
 b=ZuQjpwdNvC/4Yk/USxoEGo5139+9SQysgUx43sXBFPyTXHaxkjBLgCh4HAUtOI936AINYA2WNsO82Ofjzevl0+Tah+TTLS4YNq16X6laSRNmfRflSQx3Va6Ap2Ar30bKvmMMNGkDzg1GA6wE6HSYs28OBN56pxKxoNbR6Xsh9DCLUoOQaO7XZ/ChX5EWbpYQvaHoUgfzImpb/KsUlNf5ynFzg7bsdLDx4BxPjPxOVSpbt0a2Y/3vDj7JZ+ONd54GGPQmNdtFMLs/YaMw5V/C8zaV1dAdvd6wkhJmCJFD5xU/JlkRbekm3kWGrFU+66XG42UH52Teu1wy3i/N3pt7kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kH4V+RUd5MyZGy/907Cvi/EHSVBmMhjT7/WF68nKz8c=;
 b=QrZBU26aumsQ8UWAGV/K95OF9DQcLfaaSoBBgLXibI/FJXjGEq93aJWYZE5e3ln0NCBqXvYwTEAfnuhG269te3FLcXCQ0dVWKev10cH/EZ+gaEYBltFYVfL2Xi/VDpLGpFDDYcidtOg/+HlYDCuFK9ewG7+DEm4nxq6MxteMFWA=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6445.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Wed, 25 Nov
 2020 07:17:49 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3589.028; Wed, 25 Nov 2020
 07:17:49 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>
Subject: Re: [PATCH v4] dt-bindings: misc: convert fsl,qoriq-mc from txt to
 YAML
Thread-Topic: [PATCH v4] dt-bindings: misc: convert fsl,qoriq-mc from txt to
 YAML
Thread-Index: AQHWwXc4EjGvC2esXEeB1A2oO9x3vqnYczCA
Date:   Wed, 25 Nov 2020 07:17:49 +0000
Message-ID: <20201125071226.kcz6b6tkb2zgkg7z@skbuf>
References: <20201123090035.15734-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20201123090035.15734-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 50aa1c5e-5e9f-4c50-8a64-08d891123731
x-ms-traffictypediagnostic: VE1PR04MB6445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB644501FA8F55EFFF8D5A39BCE0FA0@VE1PR04MB6445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E7vF/ezFb6aFNPwQZhNnuw2lsRa6XL6wj/29ay8/893VOvXg2cy2HPGm9uefYrTSjXZ+8C/pFlEZ79Nb2HQgrkIsNZp+IXoHNzsSOl6vM1TS0SsK/Jj8M1+a9KlBuDU22kTpLLr9QlJHnU2RVqaBLZnBe6IQDhidpivpNXfcBkEEaZvMulAeD1mm6sBfy06D6QoVBYgMQLg6zRg7B806X4YWhZTlq6x6m8ZOdp/WFqg52mfWZ+SKJlrL5vYMmMKPriXqN7Z0s9OmZIuqPBB8NzKebray753+VKaRA+uifjQQpJenVADSrH1UGrmLCfugoRR4ICgmffzPIgBBCEVKeMyeMb4N2ORPu4+mTHmJi2Jk9n/KYLb1f4FUGVdE32tXrGCZ9BGfqTsLB5zvZxb8tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(136003)(366004)(346002)(376002)(39860400002)(71200400001)(6512007)(66446008)(66476007)(316002)(6862004)(8676002)(64756008)(5660300002)(6486002)(33716001)(186003)(66556008)(8936002)(478600001)(66946007)(26005)(44832011)(76116006)(86362001)(2906002)(6636002)(30864003)(83380400001)(4326008)(7416002)(6506007)(1076003)(9686003)(54906003)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fu5yeuW/hq8ROYWmaLY6oVzox9gSbawSQpLQeeBLrlF0E62YbyWEZQGRTAW8?=
 =?us-ascii?Q?ZmTGsR/xgPkXNIp+QUAKlNSBwbll78x6jro1+aEEsg5ojbdZ2Gc2VMuuFNc+?=
 =?us-ascii?Q?kyl9b59sLGbmIu/MNRdd7igI9pY9BR66/nDMuzGZvlsuZZescJITS8wuiwny?=
 =?us-ascii?Q?76unr7F5Xn5x2ZQ1qUAFpOFMimcpNkDsw7uwux1PsS9fEH8rQOcfvOpcqdMg?=
 =?us-ascii?Q?FTQV2BWxO9bOaml0FShqkl0L7ZdgTfxkWiMvbM6vBc+dMOX+YCIIlh3VCpoc?=
 =?us-ascii?Q?cpYp5t9CzxEZqIMCE/0j2RwTh8AfgnD9KFOATR2N6hrXzHyBOM7ldeYiqG+Y?=
 =?us-ascii?Q?OfE0P4PRDlFd8dZcJ56j2Q6kjAngkP2PXzETeNZGk+d9V4QvBe1weTAztfPr?=
 =?us-ascii?Q?EwfzgR5bzJtY/DlEQtHe4+qcvvFW6caCSqeHl6PfEfgPUX4WZtH+Np5fudhP?=
 =?us-ascii?Q?d7QqL/mYmvLDZSqpHzdTdDYuzU9HdB2TAkfvaVXSokipnKVkwU9zgNMjEgFT?=
 =?us-ascii?Q?RYSr5xVvm9t1zLHT9mOJv/GmgkNIU3M03iMjjoD19JWRuC7Ds8Yj27swOsyC?=
 =?us-ascii?Q?yCGEK4rZbX/qsk0E+NArX0cpmLlIRx/bth3FeYTXQGhhtSc1lAozgko3ddL8?=
 =?us-ascii?Q?QmT1BY5pTxmUbC21/o1qyo20CI4fUL/bMFjK4UHTvnZCQuS+cZE9uioT5hDd?=
 =?us-ascii?Q?LFOi0v7hgQ63kOmbeWU2MxRUpUPrAW1zshCuJ4Vi5g/5wJJ2bTq6vnrCTcD7?=
 =?us-ascii?Q?YKgSYzblt3hNqVX37zB0OEmvOhX3uAHpG2hge33LZ/T9teTx3xn9IGzYqUno?=
 =?us-ascii?Q?MeOhXjRSsMdRsRHTryPl0WealQF0r2v/Ihj2Nit5whjzMBMzXP1pfuLvF6nb?=
 =?us-ascii?Q?9N+21jh7IQw2Vy9QFVODGXugKUlOYViwCZPVrpgAju6s3WtJ7fDuhPOSX/zt?=
 =?us-ascii?Q?KOiuJv+X/1XEzOAxXC5i9vWo7epKV9Hq7QBUxqPV7C/07rNxNbSF5QhkHPci?=
 =?us-ascii?Q?qmdG?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4A644AF6AB4EF45A131FE4DE2433BAA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50aa1c5e-5e9f-4c50-8a64-08d891123731
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 07:17:49.3298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KLt69tp3ZOatrk5hI6IRwBznQ1/b9FmSUWIuf/65BWVwnT+8tW9bs5No97psbgrHpsj051pGpTUVypkoFBt9jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 11:00:35AM +0200, Laurentiu Tudor wrote:
> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
>=20
> Convert fsl,qoriq-mc to YAML in order to automate the verification
> process of dts files. In addition, update MAINTAINERS accordingly
> and, while at it, add some missing files.
>=20
> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>


> ---
> Changes in v4:
>  - use $ref to point to fsl,qoriq-mc-dpmac binding
>=20
> Changes in v3:
>  - dropped duplicated "fsl,qoriq-mc-dpmac" schema and replaced with
>    reference to it
>  - fixed a dt_binding_check warning
>=20
> Changes in v2:
>  - fixed errors reported by yamllint
>  - dropped multiple unnecessary quotes
>  - used schema instead of text in description
>  - added constraints on dpmac reg property
>=20
>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ------------------
>  .../bindings/misc/fsl,qoriq-mc.yaml           | 186 +++++++++++++++++
>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>  MAINTAINERS                                   |   4 +-
>  4 files changed, 193 insertions(+), 198 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.t=
xt
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.y=
aml
>=20
> diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt b/Do=
cumentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> deleted file mode 100644
> index 7b486d4985dc..000000000000
> --- a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> +++ /dev/null
> @@ -1,196 +0,0 @@
> -* Freescale Management Complex
> -
> -The Freescale Management Complex (fsl-mc) is a hardware resource
> -manager that manages specialized hardware objects used in
> -network-oriented packet processing applications. After the fsl-mc
> -block is enabled, pools of hardware resources are available, such as
> -queues, buffer pools, I/O interfaces. These resources are building
> -blocks that can be used to create functional hardware objects/devices
> -such as network interfaces, crypto accelerator instances, L2 switches,
> -etc.
> -
> -For an overview of the DPAA2 architecture and fsl-mc bus see:
> -Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overvie=
w.rst
> -
> -As described in the above overview, all DPAA2 objects in a DPRC share th=
e
> -same hardware "isolation context" and a 10-bit value called an ICID
> -(isolation context id) is expressed by the hardware to identify
> -the requester.
> -
> -The generic 'iommus' property is insufficient to describe the relationsh=
ip
> -between ICIDs and IOMMUs, so an iommu-map property is used to define
> -the set of possible ICIDs under a root DPRC and how they map to
> -an IOMMU.
> -
> -For generic IOMMU bindings, see
> -Documentation/devicetree/bindings/iommu/iommu.txt.
> -
> -For arm-smmu binding, see:
> -Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
> -
> -The MSI writes are accompanied by sideband data which is derived from th=
e ICID.
> -The msi-map property is used to associate the devices with both the ITS
> -controller and the sideband data which accompanies the writes.
> -
> -For generic MSI bindings, see
> -Documentation/devicetree/bindings/interrupt-controller/msi.txt.
> -
> -For GICv3 and GIC ITS bindings, see:
> -Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml.
> -
> -Required properties:
> -
> -    - compatible
> -        Value type: <string>
> -        Definition: Must be "fsl,qoriq-mc".  A Freescale Management Comp=
lex
> -                    compatible with this binding must have Block Revisio=
n
> -                    Registers BRR1 and BRR2 at offset 0x0BF8 and 0x0BFC =
in
> -                    the MC control register region.
> -
> -    - reg
> -        Value type: <prop-encoded-array>
> -        Definition: A standard property.  Specifies one or two regions
> -                    defining the MC's registers:
> -
> -                       -the first region is the command portal for the
> -                        this machine and must always be present
> -
> -                       -the second region is the MC control registers. T=
his
> -                        region may not be present in some scenarios, suc=
h
> -                        as in the device tree presented to a virtual mac=
hine.
> -
> -    - ranges
> -        Value type: <prop-encoded-array>
> -        Definition: A standard property.  Defines the mapping between th=
e child
> -                    MC address space and the parent system address space=
.
> -
> -                    The MC address space is defined by 3 components:
> -                       <region type> <offset hi> <offset lo>
> -
> -                    Valid values for region type are
> -                       0x0 - MC portals
> -                       0x1 - QBMAN portals
> -
> -    - #address-cells
> -        Value type: <u32>
> -        Definition: Must be 3.  (see definition in 'ranges' property)
> -
> -    - #size-cells
> -        Value type: <u32>
> -        Definition: Must be 1.
> -
> -Sub-nodes:
> -
> -        The fsl-mc node may optionally have dpmac sub-nodes that describ=
e
> -        the relationship between the Ethernet MACs which belong to the M=
C
> -        and the Ethernet PHYs on the system board.
> -
> -        The dpmac nodes must be under a node named "dpmacs" which contai=
ns
> -        the following properties:
> -
> -            - #address-cells
> -              Value type: <u32>
> -              Definition: Must be present if dpmac sub-nodes are defined=
 and must
> -                          have a value of 1.
> -
> -            - #size-cells
> -              Value type: <u32>
> -              Definition: Must be present if dpmac sub-nodes are defined=
 and must
> -                          have a value of 0.
> -
> -        These nodes must have the following properties:
> -
> -            - compatible
> -              Value type: <string>
> -              Definition: Must be "fsl,qoriq-mc-dpmac".
> -
> -            - reg
> -              Value type: <prop-encoded-array>
> -              Definition: Specifies the id of the dpmac.
> -
> -            - phy-handle
> -              Value type: <phandle>
> -              Definition: Specifies the phandle to the PHY device node a=
ssociated
> -                          with the this dpmac.
> -Optional properties:
> -
> -- iommu-map: Maps an ICID to an IOMMU and associated iommu-specifier
> -  data.
> -
> -  The property is an arbitrary number of tuples of
> -  (icid-base,iommu,iommu-base,length).
> -
> -  Any ICID i in the interval [icid-base, icid-base + length) is
> -  associated with the listed IOMMU, with the iommu-specifier
> -  (i - icid-base + iommu-base).
> -
> -- msi-map: Maps an ICID to a GIC ITS and associated msi-specifier
> -  data.
> -
> -  The property is an arbitrary number of tuples of
> -  (icid-base,gic-its,msi-base,length).
> -
> -  Any ICID in the interval [icid-base, icid-base + length) is
> -  associated with the listed GIC ITS, with the msi-specifier
> -  (i - icid-base + msi-base).
> -
> -Deprecated properties:
> -
> -    - msi-parent
> -        Value type: <phandle>
> -        Definition: Describes the MSI controller node handling message
> -                    interrupts for the MC. When there is no translation
> -                    between the ICID and deviceID this property can be u=
sed
> -                    to describe the MSI controller used by the devices o=
n the
> -                    mc-bus.
> -                    The use of this property for mc-bus is deprecated. P=
lease
> -                    use msi-map.
> -
> -Example:
> -
> -        smmu: iommu@5000000 {
> -               compatible =3D "arm,mmu-500";
> -               #iommu-cells =3D <1>;
> -               stream-match-mask =3D <0x7C00>;
> -               ...
> -        };
> -
> -        gic: interrupt-controller@6000000 {
> -               compatible =3D "arm,gic-v3";
> -               ...
> -        }
> -        its: gic-its@6020000 {
> -               compatible =3D "arm,gic-v3-its";
> -               msi-controller;
> -               ...
> -        };
> -
> -        fsl_mc: fsl-mc@80c000000 {
> -                compatible =3D "fsl,qoriq-mc";
> -                reg =3D <0x00000008 0x0c000000 0 0x40>,    /* MC portal =
base */
> -                      <0x00000000 0x08340000 0 0x40000>; /* MC control r=
eg */
> -                /* define map for ICIDs 23-64 */
> -                iommu-map =3D <23 &smmu 23 41>;
> -                /* define msi map for ICIDs 23-64 */
> -                msi-map =3D <23 &its 23 41>;
> -                #address-cells =3D <3>;
> -                #size-cells =3D <1>;
> -
> -                /*
> -                 * Region type 0x0 - MC portals
> -                 * Region type 0x1 - QBMAN portals
> -                 */
> -                ranges =3D <0x0 0x0 0x0 0x8 0x0c000000 0x4000000
> -                          0x1 0x0 0x0 0x8 0x18000000 0x8000000>;
> -
> -                dpmacs {
> -                    #address-cells =3D <1>;
> -                    #size-cells =3D <0>;
> -
> -                    dpmac@1 {
> -                        compatible =3D "fsl,qoriq-mc-dpmac";
> -                        reg =3D <1>;
> -                        phy-handle =3D <&mdio0_phy0>;
> -                    }
> -                }
> -        };
> diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml b/D=
ocumentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> new file mode 100644
> index 000000000000..f45e21872e4f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> @@ -0,0 +1,186 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2020 NXP
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/misc/fsl,qoriq-mc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +maintainers:
> +  - Laurentiu Tudor <laurentiu.tudor@nxp.com>
> +
> +title: Freescale Management Complex
> +
> +description: |
> +  The Freescale Management Complex (fsl-mc) is a hardware resource
> +  manager that manages specialized hardware objects used in
> +  network-oriented packet processing applications. After the fsl-mc
> +  block is enabled, pools of hardware resources are available, such as
> +  queues, buffer pools, I/O interfaces. These resources are building
> +  blocks that can be used to create functional hardware objects/devices
> +  such as network interfaces, crypto accelerator instances, L2 switches,
> +  etc.
> +
> +  For an overview of the DPAA2 architecture and fsl-mc bus see:
> +  Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> +
> +  As described in the above overview, all DPAA2 objects in a DPRC share =
the
> +  same hardware "isolation context" and a 10-bit value called an ICID
> +  (isolation context id) is expressed by the hardware to identify
> +  the requester.
> +
> +  The generic 'iommus' property is insufficient to describe the relation=
ship
> +  between ICIDs and IOMMUs, so an iommu-map property is used to define
> +  the set of possible ICIDs under a root DPRC and how they map to
> +  an IOMMU.
> +
> +  For generic IOMMU bindings, see:
> +  Documentation/devicetree/bindings/iommu/iommu.txt.
> +
> +  For arm-smmu binding, see:
> +  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
> +
> +  MC firmware binary images can be found here:
> +  https://github.com/NXP/qoriq-mc-binary
> +
> +properties:
> +  compatible:
> +    const: fsl,qoriq-mc
> +    description:
> +      A Freescale Management Complex compatible with this binding must h=
ave
> +      Block Revision Registers BRR1 and BRR2 at offset 0x0BF8 and 0x0BFC=
 in
> +      the MC control register region.
> +
> +  reg:
> +    minItems: 1
> +    items:
> +      - description: the command portal for this machine
> +      - description:
> +          MC control registers. This region may not be present in some
> +          scenarios, such as in the device tree presented to a virtual
> +          machine.
> +
> +  ranges:
> +    description: |
> +      A standard property. Defines the mapping between the child MC addr=
ess
> +      space and the parent system address space.
> +
> +      The MC address space is defined by 3 components:
> +                <region type> <offset hi> <offset lo>
> +
> +      Valid values for region type are:
> +                  0x0 - MC portals
> +                  0x1 - QBMAN portals
> +
> +  '#address-cells':
> +    const: 3
> +
> +  '#size-cells':
> +    const: 1
> +
> +  dpmacs:
> +    type: object
> +    description:
> +      The fsl-mc node may optionally have dpmac sub-nodes that describe =
the
> +      relationship between the Ethernet MACs which belong to the MC and =
the
> +      Ethernet PHYs on the system board.
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^(dpmac@[0-9a-f]+)|(ethernet@[0-9a-f]+)$":
> +        type: object
> +
> +        $ref: /schemas/net/fsl,qoriq-mc-dpmac.yaml#
> +
> +  iommu-map:
> +    description: |
> +      Maps an ICID to an IOMMU and associated iommu-specifier data.
> +
> +      The property is an arbitrary number of tuples of
> +      (icid-base, iommu, iommu-base, length).
> +
> +      Any ICID i in the interval [icid-base, icid-base + length) is
> +      associated with the listed IOMMU, with the iommu-specifier
> +      (i - icid-base + iommu-base).
> +
> +  msi-map:
> +    description: |
> +      Maps an ICID to a GIC ITS and associated msi-specifier data.
> +
> +      The property is an arbitrary number of tuples of
> +      (icid-base, gic-its, msi-base, length).
> +
> +      Any ICID in the interval [icid-base, icid-base + length) is
> +      associated with the listed GIC ITS, with the msi-specifier
> +      (i - icid-base + msi-base).
> +
> +  msi-parent:
> +    deprecated: true
> +    description:
> +      Points to the MSI controller node handling message interrupts for =
the MC.
> +
> +required:
> +  - compatible
> +  - reg
> +  - iommu-map
> +  - msi-map
> +  - ranges
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells =3D <2>;
> +      #size-cells =3D <2>;
> +
> +      smmu: iommu@5000000 {
> +        compatible =3D "arm,mmu-500";
> +        #global-interrupts =3D <1>;
> +        #iommu-cells =3D <1>;
> +        reg =3D <0 0x5000000 0 0x800000>;
> +        stream-match-mask =3D <0x7c00>;
> +        interrupts =3D <0 13 4>,
> +                     <0 146 4>, <0 147 4>,
> +                     <0 148 4>, <0 149 4>,
> +                     <0 150 4>, <0 151 4>,
> +                     <0 152 4>, <0 153 4>;
> +      };
> +
> +      fsl_mc: fsl-mc@80c000000 {
> +        compatible =3D "fsl,qoriq-mc";
> +        reg =3D <0x00000008 0x0c000000 0 0x40>,    /* MC portal base */
> +        <0x00000000 0x08340000 0 0x40000>; /* MC control reg */
> +        /* define map for ICIDs 23-64 */
> +        iommu-map =3D <23 &smmu 23 41>;
> +        /* define msi map for ICIDs 23-64 */
> +        msi-map =3D <23 &its 23 41>;
> +        #address-cells =3D <3>;
> +        #size-cells =3D <1>;
> +
> +        /*
> +        * Region type 0x0 - MC portals
> +        * Region type 0x1 - QBMAN portals
> +        */
> +        ranges =3D <0x0 0x0 0x0 0x8 0x0c000000 0x4000000
> +                  0x1 0x0 0x0 0x8 0x18000000 0x8000000>;
> +
> +        dpmacs {
> +          #address-cells =3D <1>;
> +          #size-cells =3D <0>;
> +
> +          ethernet@1 {
> +            compatible =3D "fsl,qoriq-mc-dpmac";
> +            reg =3D <1>;
> +            phy-handle =3D <&mdio0_phy0>;
> +          };
> +        };
> +      };
> +    };
> diff --git a/Documentation/networking/device_drivers/ethernet/freescale/d=
paa2/overview.rst b/Documentation/networking/device_drivers/ethernet/freesc=
ale/dpaa2/overview.rst
> index d638b5a8aadd..b3261c5871cc 100644
> --- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ov=
erview.rst
> +++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ov=
erview.rst
> @@ -28,6 +28,9 @@ interfaces, an L2 switch, or accelerator instances.
>  The MC provides memory-mapped I/O command interfaces (MC portals)
>  which DPAA2 software drivers use to operate on DPAA2 objects.
> =20
> +MC firmware binary images can be found here:
> +https://github.com/NXP/qoriq-mc-binary
> +
>  The diagram below shows an overview of the DPAA2 resource management
>  architecture::
> =20
> @@ -338,7 +341,7 @@ Key functions include:
>    a bind of the root DPRC to the DPRC driver
> =20
>  The binding for the MC-bus device-tree node can be consulted at
> -*Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt*.
> +*Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml*.
>  The sysfs bind/unbind interfaces for the MC-bus can be consulted at
>  *Documentation/ABI/testing/sysfs-bus-fsl-mc*.
> =20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b516bb34a8d5..e0ce6e2b663c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14409,9 +14409,11 @@ M:	Stuart Yoder <stuyoder@gmail.com>
>  M:	Laurentiu Tudor <laurentiu.tudor@nxp.com>
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> +F:	Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
> +F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
>  F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/over=
view.rst
>  F:	drivers/bus/fsl-mc/
> +F:	include/linux/fsl/mc.h
> =20
>  QT1010 MEDIA DRIVER
>  M:	Antti Palosaari <crope@iki.fi>
> --=20
> 2.17.1
> =
