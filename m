Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B37A3550B8
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbhDFKVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:21:35 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:58400
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236072AbhDFKVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 06:21:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=do8ubxbSib2nGMouE75H19ptdtWqoe50wq9AyoQIpeVg0vmjtlxU8Og7EEglTcCelx76H4g3RZW1Lg40opoAmfjDupadLG+5HpVpFDQaZ0MDLsjMcmGUSo8HRYHWSHyPmKV0rlGNP0gN7D6IR3EVU3e8zjsR2oc5XfxB8sFjOg0Z1potOqQZFVblHHtAdTeyuG9sI0AdA2BdZhenCm7tiknkyLBo+lZa4TowdCVJjK7CV1B8LQm47zzhYIUN7uDpa80XCTPGjlPsu4R35HHW9qkjCq2GBTBeDfrPNoXx/MVGoqdXDNezRXI11VByofVzZsWAaJ/xdPLQYrbPwcSh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUmmgMp0P1UGCRnlzkA+1jqd6Z2RRg3XnU7FOzxGHqE=;
 b=X5wQdrI9LKhBjCc/NgyoGt3MrEh4nM1GUGccTS6Id+ya79FHOtcU73RSTgYcTyS2/zPGZexQQ1dEQgC1hNVLUf8zukkUpmqiLmHrSRnXyiKWzt68fFzHphvpuQmCInRiwa7pCKLqNAuQzDv8B4foZAgn4KO5q1tpXhtU71SHzn4SSRB18Y0kEwuXw2yCtWc9Ak99oXUPtyk115HLWSIlO7Ku5vFNcs31Owt84hNxQyDHu3dqVM05M3sBugE1oWiATJUfZR6w9QDr0izZsBIYPAQAufDXNH9C06IfcRRtfH96MsVCDSQFZn3DbOthfPjHCbX+cuCyywHutAd//f102g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUmmgMp0P1UGCRnlzkA+1jqd6Z2RRg3XnU7FOzxGHqE=;
 b=NJn4PB9UHSZHE//+5SVxlPALQ6mwfhMMU+UxSk/xwg+TBeZrphpoWsLhMm4FDPYyGJxMQqIeoRdQN7CaDWDQRhw9cnuu9NMm/UnP2Jvlp+lH9BS5wYW1ddmNIZ2Ee9fzBquuLU2UbfLI1Fun9kfxAu+Bqv9K974PNBXydClG9iE=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6753.eurprd04.prod.outlook.com (2603:10a6:208:169::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Tue, 6 Apr
 2021 10:21:26 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::1552:3518:1306:f73%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 10:21:26 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Network Development <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Esben Haabendal <esben@geanix.com>
Subject: RE: gianfar driver and GFAR_MQ_POLLING
Thread-Topic: gianfar driver and GFAR_MQ_POLLING
Thread-Index: AQHXKssY4fCFUcBA20CMP36lSS5TUKqnQnXg
Date:   Tue, 6 Apr 2021 10:21:25 +0000
Message-ID: <AM0PR04MB675420152C3368821EBFF41E96769@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <ff918224-ce0c-9bdf-c5f9-932cb5d31e0d@prevas.dk>
In-Reply-To: <ff918224-ce0c-9bdf-c5f9-932cb5d31e0d@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5918208-493b-4fd3-3032-08d8f8e5bc1e
x-ms-traffictypediagnostic: AM0PR04MB6753:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB67533793AB7D40975659C2C196769@AM0PR04MB6753.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tPzkrWb9TBem4ZA/Xt8d0VjGLuV2OLnY63T/wmKcLOLv8ug46NoHZQx9HmZefwHT4yA1d3oDk5n7dF2ascccQD0YBCdqeOPzkYGeWhw219AwQLLaTEwsNsojnd4DxUqIW3QF19/El/YIr8vE8N2/1A2DG9MLaCGaIMu9MbboZMWlm6be+Ms3OzeGDfBlNLA2seMfHxqBP7+DUzoJWmgE7xpIn9Dldj6yfXGcmtkQJ39tZFVyFCnVTGK9ewk/Vdb0dqNst8rRXbS87i0XQtOcgm4Tf2gVQa4YMLm/hil9udSH4PaO/vXw4G9IkocLx9eJoWsrxeUnBF7m/zsK2B2IYVDwRxoB7EU4NDdRVm7Qr2IKlFpwT8NDtFkD1fMJAdvPIUuRl2rhN720D62GFQVA1yW+Z61YH5s+/6OT13EZpxba+L5ekCKjjEIcQsx4AzDd1sSfDpz1HxFRa8UwB/F39Lk/fa5X8g+ScAYT7+2nUO5jnIYAMQuxVXt8PrEN3mpCyXN/3EzzEQHcmyuKg9jDhW4p6E09o7ckWqgZoqqo5oRbHg68QWtY5+/sVN521AnhF4B636JLKXXSu37isb+PC1cwSKZuD/iTkfTSfTnSoP+w0PP0qh06h2riYzoJEyCGgB+4pTjSD95gBR901TkjiAFDvYRvCFmDDgAkG6UKcK4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(366004)(396003)(376002)(66446008)(6506007)(26005)(8936002)(66946007)(7696005)(64756008)(66476007)(86362001)(76116006)(8676002)(186003)(33656002)(6916009)(38100700001)(52536014)(44832011)(478600001)(9686003)(83380400001)(2906002)(71200400001)(4326008)(316002)(66556008)(5660300002)(55016002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1WMdoVCfrTnMxTuU1cC0Bm1kuG53CWetncN1t+Yt7TokzHStdFWKm8ze3nnY?=
 =?us-ascii?Q?T1Se0ntmDZFDEa4vpF5RHqz2eX1veV2nHoswcmSx7MIRj4z7/LrZzTEnci8H?=
 =?us-ascii?Q?g/pKmh6i4O93AmN07xLZgHRfhCjP1c9PuCZzHn+HP0/OomN72HmXXE+Fmmog?=
 =?us-ascii?Q?uRVuBCoNDSuvzjUnQ5K8ICrpCh0qZpbZcVtHfqQSEcO+CzoeGTr0DNUjrlMO?=
 =?us-ascii?Q?W9vnhbzlf8wD3+ytGzM4VFZekY+gOT8xoZzX0SHLf9K3lmPVMTVNZpUeHCmE?=
 =?us-ascii?Q?miYtW60ON0KPwJZ4qgBfe35kdyPQcbBur7lnRVCcBLcN57PqOHtjQEYBI1HU?=
 =?us-ascii?Q?eljCWR70MwUQGY/QBVFzVPCBLDhqAIKMzDUAp7AnmiPoqPuc1Utc9lqW1GYs?=
 =?us-ascii?Q?UVEBqZlV3Y7AhXmL9GjvNNPEEIHJzkKlUr6zuaIpez0G3vfb9QZbteiGW8aS?=
 =?us-ascii?Q?9sUQ3QK3rgboTjgGEIBmDOHdookidppjz3SDmCAOOgwJbsXVCS7WWrpZOUeF?=
 =?us-ascii?Q?EQDiUdqHSDhPIqVJgun1rcJdGGXe2nhjAtrtI+LgfgZ3WzntRP3pHyEBKzwQ?=
 =?us-ascii?Q?C4f7Ka0FUglaDW2IPRgkPWSM7ud3QkJvgxrmwbyDXQ2SnUdnGfKsNVveBu1r?=
 =?us-ascii?Q?J4/z/STyEeYnpflSeAM1OUwfmhwInyrBPmLUB/jNi4d+LkzjcGyIZ8/dgsFZ?=
 =?us-ascii?Q?maOPdlxZ34HmdsHwGBh/euKmgpmGbS6twC/xRHGeYVyMd1Osm51DRqUIWN0g?=
 =?us-ascii?Q?NEcDX+2ZHhWVVoVOWf9Ov27ur6UMqn7jfQApYz2ugnfVniXrjEsdqKSUsVtn?=
 =?us-ascii?Q?YyqKZez9DciwxQUGd69Z/KhUnYvLiupkKVM8zeVedk5K6UQNe2ynrg6T6DgB?=
 =?us-ascii?Q?7XvdfbaQxWV80N0q8f5ZJ1Qr3vk0xt00hGDRtKDXff4NKTjMMMfhPUC5mHEg?=
 =?us-ascii?Q?Liytyjg0+bZRtJbBCi7QbEWZREB5yvXcWxr9JXxpsS8FBvA7d8jG5TipHwco?=
 =?us-ascii?Q?JWEpefWl5dve2ivKAAX28wby+El/TT/KkHU+drJ90qae3zN4q2/DbZbBPs30?=
 =?us-ascii?Q?IKlAQIpq2l2PpV2YXUHcH1t9peFvUxbCPYP6WyrA9C9SRiVqlTMwTUHJVQ6E?=
 =?us-ascii?Q?evz8j9Q6M0kcLIUxMEHxKkFft2JbuZmCJEW514XzsG9wJu3G0yaooPo6U6/9?=
 =?us-ascii?Q?83XS3Hqiakaqgzw6lfftDYo9+MWRY1KyzNLQzXJTLJ2+OzmfO7fxgHR7yzCo?=
 =?us-ascii?Q?MFfdKICenQcrvQnQDrIKmBgRBhyZuzGQ7E0npml21MmkkFP3/w0GUqMPcOVn?=
 =?us-ascii?Q?sDWCvdem62pNgK2uTUQpuBaW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5918208-493b-4fd3-3032-08d8f8e5bc1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 10:21:25.8780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPQKS67f8CU8muZpjD1/cphAgblk6axInu2YI1hJ8CMEOdEbmSBUA8cs3jITro4V44pDitEvvHZXo3+RBF8cyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
>Sent: Tuesday, April 6, 2021 12:56 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: Network Development <netdev@vger.kernel.org>; Vladimir Oltean
><vladimir.oltean@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Esben
>Haabendal <esben@geanix.com>
>Subject: gianfar driver and GFAR_MQ_POLLING
>
>Hi,
>
>I noticed that gfar_of_init() has
>
>	if (of_device_is_compatible(np, "fsl,etsec2")) {
>		mode =3D MQ_MG_MODE;
>		poll_mode =3D GFAR_SQ_POLLING;
>	} else {
>		mode =3D SQ_SG_MODE;
>		poll_mode =3D GFAR_SQ_POLLING;
>	}
>
>i.e., poll_mode is always set to GFAR_SQ_POLLING, and I can't find
>anywhere that GFAR_MQ_POLLING is used (except for comments). So it
>seems
>that everything in the else branches of the "if (priv->poll_mode =3D=3D
>GFAR_SQ_POLLING)"s, including the gfar_poll_rx and gfar_poll_tx
>callbacks, is currently dead code.
>
>I'm wondering if this is deliberate, and if so, if the dead code
>could/should just be removed?
>
>FWIW, some quick testing naively doing
>
>        if (of_device_is_compatible(np, "fsl,etsec2")) {
>                mode =3D MQ_MG_MODE;
>-               poll_mode =3D GFAR_SQ_POLLING;
>+               poll_mode =3D GFAR_MQ_POLLING;
>        } else {
>
>results in broken network - ping answers the first packet, but then
>nothing after that, and ssh is completely broken (and if ssh is
>attempted first, ping doesn't work at all). This is on a ls1021a-derived
>board.
>

I think GFAR_MQ_POLLING should be finally defeatured. There was no
request so far to re-enable multiple Rx and Tx queues (more than one per CP=
U).
To support multiple Tx queues a different mechanism should be implemented,
that enables the extra queues via ndo_setup_tc instead of device tree prope=
rties.
I can prepare a patch to remove this dead code.

Thanks.
Claudiu
