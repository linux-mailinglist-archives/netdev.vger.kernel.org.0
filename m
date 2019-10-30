Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE4EE9D3F
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfJ3OQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:16:07 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35748 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbfJ3OQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:16:07 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8A892C0C4F
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572444966; bh=i1d8imZo5vYM2Cy3TU45K00jW4FPEmATV+fjqao/MQk=;
        h=From:To:CC:Subject:Date:From;
        b=HaGFuYd5OVl+V/gbY4Buzf+8kpnEhlkugFsWMFg+72yorhIThRjFiGvtNO+rjKMZJ
         Vt902GwczE99qfUYE2LGWCqH8haWEoqSqpwU2wVcuAGA9fzY11xJOU76RankPpp4In
         IKtHixlkae5YkmShM8iuhhPlJT0MtMsS3U7y9OkCKBpf4AiQWkR6OUDv1i5qydjBsO
         GiBHxWi2GpQ7RNtsAxcEVmoFbXOyO9+FvaFi4MpUkHQ/bzowet4GtFREOxyuf0qOI4
         oVmNX+kP2FJCV5qJohKOPuDpE6FW0LrYaSbrdhWysqSqdh+BN2BNBiyCSL08bTPSgF
         1bUs8JyZl6Czw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4802AA0069
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 14:16:06 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 30 Oct 2019 07:16:01 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 30 Oct 2019 07:16:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUbP6Pl4d7jKp4btZGfwogi85d3GiIQ8G4AeUnvECYY7OL9WPX8Nh/UMcMY7PVzk5UDLHgowBUR2W8YoGCAEO/DPBlhFUIQfYotOCFlM2BagCEN9HazwbrMn5vDuZToPIvgKGHUZ0RNFgpajNe9qhuUR+gBU9khYi9orcpcgzO9HKyBRIQ3GpR3/LcfMHjO0m3I3aVzl61+sUjkrQvJwaYJQI7QtKkSFU0oZQEPBpcc71JX/i3zac/A2CPAojgHL2HA8IxymPhfOu1hD22Rqr4nBuLxr9XKjZ0sH5SK1Y/S+Jj6syLesYWvUbAlFp9V06Bq3yIwC/77U87zIT0aPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1d8imZo5vYM2Cy3TU45K00jW4FPEmATV+fjqao/MQk=;
 b=G9C6QjazKCzPbXeKK7ahCiXVAdKYWFpagOjI4MpOCWhz/iG+sl7luzhIceCkoMuusZq7voqlX9lVooGHS+hCDRe0/Vm3PBqElDv2SwTj2MsTYuR54gYFOP+UP1F+s00eutskuo/o9AYZm33I3FDIMu8GyStCGntn2i9Kp4RLcNno8d6EECxC948JCofagHa/99HjCCwWsWpw2vauU4SLnoj9mYc0mc/iSyM14hw4St4MnVHV0jB/L5DKim+WBNbkhS++jwJU8efwr5SHhRjFRbeOJv7tILgpgWtCR6Fin4rBhGXY6a1aOSgVJlHsFzNGOYseGXEArDVH+Kx32cSUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1d8imZo5vYM2Cy3TU45K00jW4FPEmATV+fjqao/MQk=;
 b=kfmQLy2MTRDFZSDxKHdkEOElsdmJP6OZ/3KwOCBVNlKWBtdY9PP+7a+90ZnYYQ9HL7cuaPGDCBt/8OzdkdZE1lEHkyifkw9JRjrJ9fF1jGM30wgMOgQqtF/JVrAHEm8z0AKJfyPGYyNuVaRfihkwxFFHAMTmiUQ3M5DlJ7kY7VA=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3092.namprd12.prod.outlook.com (20.178.212.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Wed, 30 Oct 2019 14:15:59 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 14:15:59 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>
Subject: USO / UFO status ?
Thread-Topic: USO / UFO status ?
Thread-Index: AdWPLBeus8XJlFS/Sue5aUntLc/tSw==
Date:   Wed, 30 Oct 2019 14:15:58 +0000
Message-ID: <BN8PR12MB326699DDA44E0EABB5C422E4D3600@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de46b051-ed68-4905-4390-08d75d43afd7
x-ms-traffictypediagnostic: BN8PR12MB3092:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB309204C9BC0D6F06EDAE179DD3600@BN8PR12MB3092.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(376002)(346002)(136003)(189003)(199004)(2501003)(102836004)(5660300002)(55016002)(107886003)(316002)(2906002)(5640700003)(478600001)(2351001)(33656002)(71190400001)(71200400001)(7696005)(86362001)(25786009)(52536014)(4326008)(6506007)(6916009)(6436002)(186003)(305945005)(66066001)(74316002)(66446008)(14454004)(7736002)(486006)(26005)(476003)(76116006)(99286004)(8676002)(6116002)(256004)(9686003)(1730700003)(81166006)(81156014)(4744005)(3846002)(64756008)(8936002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3092;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +6j0OJ1MaDR5e44KfiSlX8MxNMHXmXJx31qMk7hAaaMBiliPN3+HOBBkIRJlKg/1f+aZfZdP8y1PGJAU2MiZm9xIpxUfcB9PsXJUuN0ZFnYDt6siTQpdXUmVcQr4YYGGXCNUyBE/IoBieGfq3reqlbF+eaW5TsYCQtUkuvYnyhGI5r5qhdE3Ue5eP/BEfPfzNB3NGft3avKfVstFJzJXLtBr+C8pskgM1BwCHKQurf2n7RWGX69XvP2h7aD//LJUg/0lUJ6L0VB9wRYvhh74Q/QrXWAuxtNWYiDYp4mdbnBkq9Rjp+CA4aAy2i6VLVRvSDRDe4Bg4/ktI8VJC/U+oOxBLI4Gnm+zJWZChRpyYHQCIbDYSTdvjWuRikF5ekYnFvxen+ZejftUggV5hfdWhyV6L2814sBwh+EIwjVAIFaB6aKdTPFLgojH+PZuRVZM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: de46b051-ed68-4905-4390-08d75d43afd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 14:15:58.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7aWHdTB+CgSoi3s8O1RPWF007jsLauwCDfhrOM8Ft1ywgM4kdRKUlcqlW0yLKs0+p0Ctz89EvOXCxeINPgwoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3092
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

What's the status of UDP Segmentation Offload (USO) and UDP=20
Fragmentation Offloading (UFO) on current mainline ?

I see that NETIF_F_GSO_UDP_L4 is only supported by Mellanox NIC's but I=20
also saw some patches from Intel submitting the support. Is there any=20
tool to test this (besides the -net selftests) ?

---
Thanks,
Jose Miguel Abreu
