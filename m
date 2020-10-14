Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FFA28E1A4
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgJNNtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:49:23 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:61024
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbgJNNtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:49:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gy0d8pzoZPA36VqgKxYZ/tkkItq9vvVb4lZb6Iv0jn/EpM90u99z5yv2ZgayVSagMiOpp6CmX/ngXT/yDSzmvzb3VNmzKgOTdvsK1chueUFteJK0AuTz+tkDv6WPL1R9zmP1vTEWI1ar146I5+KSarypjAtGYij1JEO45DKfniU98JINgrnuPF0jn+qbZuVNEdRBvtm/qRAisQ166TIPQs8CIsqLnwW0gchFZHaXr69NvvX5Cu2dTOdlZw3+PAcb5vZq/ZEyXbcZXIViJh6i/PBSbEF8IFOWQpv9/1nxp6rg+pPxvoh4vyO7Ri4RLuJ+fY4kshGSaXAZTJwNJfpv4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hpyv1JvntTb93c+qrvdeuKGsflEK1eadGjK9HigqFcA=;
 b=LBHrXBPw/rdzuzLYjPdNBxBFuVvd89+jsoBrO94iR/RxyPG2io6ZX4Lo6rHYie1lSlR4WpcI90d4vOHnpo8ZkUmiQAeTbteyAgAJzv0kbcMQXAfzNnon/Zgp9z5zPzLGlAxgH9nWCYJKnzxrbDzsrlyeiJfFPQ7JqB6+q+bsEuhujEfdh9jk/0L3pC5vglhOhaFOZLzK+dSw+5fJBHuqemkCjv9wMKkYXr+KAzG6JSW3/jWrv8C5OH/uHqaqx7jLZZElMSqmSqdLc0IHxVNXmTBpuUM2efREbceBRNZISE9HLLw23s7O6Hq45A8XYzyIMwFu9oe8hm7PpSGuIULjDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hpyv1JvntTb93c+qrvdeuKGsflEK1eadGjK9HigqFcA=;
 b=eC6cB5tl7DEdsLdX9Jiju+xZpjKRa6Q2FlWWDU3dYc7gW2PW/r/UIXjYY7baiaFXDi/su31Erk+iyGGa0jxJF4PgIu+Y8xmhlcHeG7U7RRJ6ZBfMLs5mnJ2R66MaGWKXr/pxphzYtHvPf/2YhQF6KLFkyi39wgherAVCP1jlOj4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3357.namprd11.prod.outlook.com (2603:10b6:805:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 14 Oct
 2020 13:49:17 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.031; Wed, 14 Oct 2020
 13:49:17 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 01/23] dt-bindings: introduce silabs,wfx.yaml
Date:   Wed, 14 Oct 2020 15:49:12 +0200
Message-ID: <3929101.dIHeVNgAIR@pc-42>
Organization: Silicon Labs
In-Reply-To: <20201013164935.GA3646933@bogus>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com> <20201012104648.985256-2-Jerome.Pouiller@silabs.com> <20201013164935.GA3646933@bogus>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: DM6PR11CA0034.namprd11.prod.outlook.com
 (2603:10b6:5:190::47) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM6PR11CA0034.namprd11.prod.outlook.com (2603:10b6:5:190::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Wed, 14 Oct 2020 13:49:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c842df6f-3ce7-461c-a691-08d87047f189
X-MS-TrafficTypeDiagnostic: SN6PR11MB3357:
X-Microsoft-Antispam-PRVS: <SN6PR11MB3357B01F04F846FD90383B8893050@SN6PR11MB3357.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NoWHYRlSMV6kNiBHbxmJXASGr9QjStsLpSTgoZd8/inB7u8zQl9Q/G45JTMSptZ1wjlaGIT1LWU8Rmmo7z2I1FIfEyzTYBLPRo7BlujmAmVD9ZONE24iulHVLu4EPQ62Mn6O8lNlAjOrwzto8mwOKZFQu127vLsvMihIkwdaK0hfFNAqqbI50IJ6HUiZhm8hN/GXrdoxpEIHhtMyYAwdj+ucdH3MOwza8l2Nuan1nj9JFz/ey+d7IvLe3mbsSQqv1cHufgvuk7rCwx6vF+PVYDV+2DkB7gRO9v3WzcUAhHs6fdIpJesxDn/rtnqNla4T6uKWS1j8zk15uan2w4Ak8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39850400004)(66556008)(66946007)(66476007)(33716001)(6916009)(83380400001)(52116002)(86362001)(6486002)(8936002)(8676002)(5660300002)(6506007)(36916002)(4326008)(478600001)(956004)(316002)(26005)(6666004)(54906003)(6512007)(9686003)(16526019)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qjPVWzeJAIz4IzX9zP/L/vNRRWvnL0QVtb3olsTy3tXQ0qpgDcfbhq9aiCgDpQmeMEnx5C18+ogdYIoTrOtV2oJsIFjo7oOBT5GRKUF5fPs/4XwPkuA9H1DoXfRo0Ni3yCryBUOs/ZEOERrd6anedXFdDkdlEVXIhOPEO9wah6AGCjUFXYHR8l3VC8u2gHS38WlW21vSMIa8R4Dx6BYUoJsem7OQX+UvtYzE0zlRKRi2WaMSlgF6uF+FOLfPqT4KK9yQ1N0NrDZEUUc1JyN4i1rBCr22YZQkTVyZsoC9ma3NL16fkT2/pwpTMpTvUeGbl4AHu/jDX97KANn1jfKEa+KlLJPZxqD3lCGa1qL8N/LceFwnW7ag8+5D3jgdM0OnrgG5QWst+4g56V9SI1BNK3ugN59ZNMvMZ+BnjCcqwixlD9msEC/+1tC86Gk2i75anBe5aUFra+HqAp7GT3ayfiUQE4hIpuj+Q+fBNWG6GuuiYFkAJ+VmFqOJsGXommnknl56GEFmB6vnX9ba/l9HeAUWChRP3ES2nkPdGBnMznu28ctvRJ/S7mHdzMFDO+XynALrbLZ8Uic/omagGgSRUVRxmqAbe7onzFJ6rza5i/n+iQfV+3XK3YIQbvgzgX54yHpC/Mu10YtO4TTXQ87gRA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c842df6f-3ce7-461c-a691-08d87047f189
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2020 13:49:17.3982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vNisfYkgmddN/Oj4dbNb9pijpnb4O6RtZUx4oQkUPpo69T/8DbZZQ7bjz/3gO+d+azLXPSJEDet1OEa1jFPeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3357
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 13 October 2020 18:49:35 CEST Rob Herring wrote:
> On Mon, Oct 12, 2020 at 12:46:26PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
[...]
> > +  Note that in add of the properties below, the WFx driver also suppor=
ts
> > +  `mac-address` and `local-mac-address` as described in
> > +  Documentation/devicetree/bindings/net/ethernet.txt
>=20
> Note what ethernet.txt contains... This should have a $ref to
> ethernet-controller.yaml to express the above.
>=20
> You can add 'mac-address: true' if you want to be explicit about what
> properties are used.

Here, only mac-address and local-mac-address are supported. So, would the
code below do the job?

  local-mac-address:
    $ref: ethernet-controller.yaml#/properties/local-mac-address

  mac-address:
    $ref: ethernet-controller.yaml#/properties/mac-address


[...]
> > +  spi-max-frequency:
> > +    description: (SPI only) Maximum SPI clocking speed of device in Hz=
.
>=20
> No need to redefine a common property.

When a property is specific to a bus, I would have like to explicitly
say it. That's why I redefined the description.


[...]
> > +  config-file:
> > +    description: Use an alternative file as PDS. Default is `wf200.pds=
`. Only
> > +      necessary for development/debug purpose.
>=20
> 'firmware-name' is typically what we'd use here. Though if just for
> debug/dev, perhaps do a debugfs interface for this instead. As DT should
> come from the firmware/bootloader, requiring changing the DT for
> dev/debug is not the easiest workflow compared to doing something from
> userspace.

This file is not a firmware. It mainly contains data related to the
antenna. At the beginning, this property has been added for
development. With the time, I think it can be used to  have one disk
image for several devices that differ only in antenna.

I am going to remove the part about development/debug purpose.


[...]
> Will need additionalProperties or unevaluatedProperties depending on
> whether you list out properties from ethernet-controller.yaml or not.

I think I need to specify "additionalProperties: true" since the user can
also use properties defined for the SPI devices.

In fact, I would like to write something like:

    allOf:
        $ref: spi-controller.yaml#/patternProperties/^.*@[0-9a-f]+$/propert=
ies



--=20
J=E9r=F4me Pouiller


