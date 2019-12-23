Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F10129371
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 10:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLWJAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 04:00:54 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:39290
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfLWJAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 04:00:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpz5VzHWIBQxHUdK6HH6GtI0MzVN4Gg2xsNX6Y9QpVm9oaJMq4C+vMK6HYRji/AC3dXWuptGq2AQzzC3AuZIqAYnE+iKbY9q5GtsKs7hbSxDoF+J6fAz1ca6M8muGPJRNDiKGcIuVwyj51YNxJjUdtA/fTV9eZzsEIZqLbiQLIDoS1m1zdRqaLBNcuPlvXDjgYP+6Wvv3keWl4puYFDe7+zX2kF/PhM84vCgncqtz9g98ChYA0nCCIE+1HlERiovHKpz6GuxafJE2eKBrGfnaN8T1CSuPNLm8UAQ51WgweeOUG/XWtmeyf0m9nzns1E71ntptaG0clNUYvglVVl5wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/aQqq4zi0FS0ACbmdtACrWnR/9703gnFctNHejqvIY=;
 b=QKlnfXv2UtuJwVMMJhk6tHEs/D0V2qMzXnVWbVc7hoiFuAKv87Oj39J9bfa5WvAMtWhMse7vKRhdR93vaBP/5u3xLTqjUzfjPHuo3/c4NCcLDuENN1gqz0d63afGztCl+Sdnh7baPYIh/G9H2VZXbza8XiV3Qd9BnPwzB32vgjvHZEQNIr72EIRqZfl+jU9523766sIwxFXHTM3uE0iF2Bie/lsMVCWZ0JZv6cfGE7sjMgjVPudXliKBhO3JnkGnIV+++YUMQps/z7GZFGzbzVhV0X7EMwNuBOCgzn4H2zRljyChmNW0dwrpPbHXyWEdl/ZypOGlDkQORDHitrcang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/aQqq4zi0FS0ACbmdtACrWnR/9703gnFctNHejqvIY=;
 b=RsRzvYGo6E0z2f2cEMlSAd+Xhau/oE2cOaNAk3VZGD8KBhDOn09FZvv4bz887ECatD/Xim4w/tojc6MhxXmOvHszMzQEKwBuJRdfr+w1KSBCa/dDnydTNGvYAzVlIgcnx0DMMn8SFr7/lcayES0j3qrAGMJQF2yAmssv6xQ55/I=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB6334.eurprd04.prod.outlook.com (20.179.28.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 09:00:50 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 09:00:50 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [RFC] obsolete references to
 Documentation/devicetree/bindings/net/ethernet.txt
Thread-Topic: [RFC] obsolete references to
 Documentation/devicetree/bindings/net/ethernet.txt
Thread-Index: AdW5b3hESqtZbbnjQOembQWO6V8MuA==
Date:   Mon, 23 Dec 2019 09:00:50 +0000
Message-ID: <VI1PR04MB5567BBD2827A5DDDFD0D82B7EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 136963e6-91d2-46a4-70ed-08d787869c01
x-ms-traffictypediagnostic: VI1PR04MB6334:
x-microsoft-antispam-prvs: <VI1PR04MB633468724337D7D76A00AE93AD2E0@VI1PR04MB6334.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(199004)(189003)(8676002)(55016002)(4326008)(81166006)(2906002)(8936002)(81156014)(478600001)(9686003)(4744005)(7696005)(6506007)(66946007)(66476007)(66446008)(76116006)(71200400001)(5660300002)(66556008)(64756008)(33656002)(110136005)(52536014)(316002)(186003)(54906003)(86362001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6334;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xgdb9M1BBHgK43ezUv+biOylrWuBYFyL2auEv0c+OzuaKjy+V8KHW8gUEEyXwultuSc8LHdfsu5XNeJC2m8XV7x8fK0gWfQM+V5y6ltmAec/cJS78OKAOskTuZ6C8wq/qUgangSVWYSnid2+9nlywW0Lja8i0HrjUw27oqKRI3zJIjabB8Uwb7RLfElI6CikO1ZgHNOzxNdyuNZlEcL/fat44fTeeDCZffLxVB94eg416We/bQSgLcIgIPkWTe1KbxefObwiQkZVhfRp095/jCV2kBYlLbrk7anP3RgBgU/f9DPPlxSuleoosXHAeau+ojSG/xLgo3naGZLwo6Vm3of0VA9kSa6OzAToqd9NMxRb0R2VzaKR3R/S9hRALrJlTJ/7kI+dYuv+ZMNyyYwO5/00eE0xUZscPBs7xFvDWR6z22Tlm3WKSPElDquc3L+7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136963e6-91d2-46a4-70ed-08d787869c01
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 09:00:50.7053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u5CnRw4RMAKnBKEXsS+/rHTPVm5JLQzVYvDjQWyR+MOzxsQuypgQjSnmECiD2NdZG+fSv0tuNml/37w9JzqHew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch removed the ethernet.txt content and added the information found=
 in
it in the ethernet-controller.yaml (Documentation/devicetree/bindings/net):

  commit 9d3de3c58347623b5e71d554628a1571cd3142ad
  Author: Maxime Ripard <maxime.ripard@bootlin.com>
  Date:   Thu Jun 27 17:31:43 2019 +0200

      dt-bindings: net: Add YAML schemas for the generic Ethernet options

      The Ethernet controllers have a good number of generic options that c=
an be
      needed in a device tree. Add a YAML schemas for those.

      Reviewed-by: Rob Herring <robh@kernel.org>
      Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
      Reviewed-by: Andrew Lunn <andrew@lunn.ch>
      Signed-off-by: Rob Herring <robh@kernel.org>

There are still many references to the previous ethernet.txt document:

  $ grep ethernet.txt Documentation/devicetree/bindings/net/ -r | wc -l
  96

Should those be updated too or it's enough to rely on the current content
of the previous ethernet.txt file:

  $ cat Documentation/devicetree/bindings/net/ethernet.txt
  This file has moved to ethernet-controller.yaml.

Thanks,
Madalin
