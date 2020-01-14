Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645C413AEF0
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgANQOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:14:30 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:41780 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbgANQO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:14:29 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1B4FB406C5;
        Tue, 14 Jan 2020 16:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579018468; bh=ANkLIcWK572m4euIqvA70RwL1TJCQd02P1eS11O8fwc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=QY0wpVGc/0cffrDd5uQaF+Sd1BkH6aEq+WyFiF60uki06V5UbB6zADLQH2J4A254j
         LYjdXUVJo9Z9osC6dsYRs0P8afVEmhkFsdM7Lx5H+loB3ZyA65ecGpaz8bAmhA/TJk
         xsPhAR6ZnT07KE5K1NftP0TegxVGnlUUeQUNiBYfLa19KkLbw+qXQeYdQC2eZKEGLp
         moI2DgwBRw0Pmz1zyMQuwkBksGPqfTQB0oFncMjMdg8epbob6ZwsB7Lpl9u+inyfar
         KUIqtP4y+YTxmI5OH3kyRMcOQkvm8nFwvtxjAdDJZ1TgBWR/okjxCd7VLH77W5YvWL
         hccna4M+0pAoA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5264BA007F;
        Tue, 14 Jan 2020 16:14:27 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Jan 2020 08:14:16 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 14 Jan 2020 08:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQ3wU0l6FrcnkiXLxxhyVMU9POPYrcCpRDUurbVlBg73yBo+FnTO/AWXuYh+7aILSV4GLAu8ADmu+tOVXx7D8YkeFM3c46IGo11ndop1rqVztpjaoCzB8lB8hgloXhW/etcPOr+v89Duiw81qJGe5dcl2Tj2xKdFUFfpN/qVYTNSUeiIyNlnlfHAV30vfiVla5JA3KzzICNOnCKVvKxIUveo/j9nDzNTv7MoBM01g6Vly0MkLczOjJDJ1eRj/tZdwz7GjGXnlKs5cKDTnw17q1MhjNGlaeuiAQOMcglhzmkhN5PsCzp10dYSfzGWm/WlP5STvIDn+ZqiA90o56kyZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANkLIcWK572m4euIqvA70RwL1TJCQd02P1eS11O8fwc=;
 b=XEbXd5sGeyNpPFr3xYuF+aCoQ/nWYFtl26vjo+/qJ+du0f6YTHW7+7G4oAjtktdzwe8GeAoR+qzHfpuLn+LyAcOuY8JyYtoeoTBUeK2LQ/D8ouGwKicqID4RQUVtk1R+Xui9j5aR/UvXAMkF1aGwMW2hSZ2aBbRZbxE67nN9G2jwHn90wurimNFWmjYUXqZ5yQPVJoZXotnuzcZcpQiX6U6zIBvyBZwAErE4K7phkHT3N+IYtdITcbLPCZ8GaBwyw+JpSZppx9tOntV/NCXyy3cLtrOIStruvXzrqWhaKlQkznLEFm7PR43xrrg003cYrNzFRxpT1pvpYsZIn2Kxrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANkLIcWK572m4euIqvA70RwL1TJCQd02P1eS11O8fwc=;
 b=hiTdlU8ZigTMyUjBAdcoZpXmvIM5W3P27WJ87boe7HD9Y3FlCZLyDcNco43Pb2m7187SaI+TLGLUeTQgwTrOewQQpnfacxdTC6xOY23mwClSzI8NQxQBc/OB0ekuu4lfDWarAUkdcj//D8xt9LjEMiLgU0uS/sVLjP2LRmp16+g=
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com (10.172.78.14) by
 CY4PR1201MB0069.namprd12.prod.outlook.com (10.172.77.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Tue, 14 Jan 2020 16:14:14 +0000
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::3977:e2ba:ce57:f79a]) by CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::3977:e2ba:ce57:f79a%5]) with mapi id 15.20.2623.015; Tue, 14 Jan 2020
 16:14:14 +0000
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net 4/4] ARC: [plat-axs10x]: Add missing multicast filter
 number to GMAC node
Thread-Topic: [PATCH net 4/4] ARC: [plat-axs10x]: Add missing multicast filter
 number to GMAC node
Thread-Index: AQHVyvUeEgWlF/s9XUGcbzZNh2Hp+qfqVPRw
Date:   Tue, 14 Jan 2020 16:14:14 +0000
Message-ID: <CY4PR1201MB0120587330B21F03600B4204A1340@CY4PR1201MB0120.namprd12.prod.outlook.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
 <b1abebaf6ac9a0176b82e179944a455fbf1d7a15.1579017787.git.Jose.Abreu@synopsys.com>
In-Reply-To: <b1abebaf6ac9a0176b82e179944a455fbf1d7a15.1579017787.git.Jose.Abreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYWJyb2RraW5c?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1lNjZkZWE5Ny0zNmU4LTExZWEtODAwMy04OGIx?=
 =?us-ascii?Q?MTFjZGUyMTdcYW1lLXRlc3RcZTY2ZGVhOTktMzZlOC0xMWVhLTgwMDMtODhi?=
 =?us-ascii?Q?MTExY2RlMjE3Ym9keS50eHQiIHN6PSIxMDA2IiB0PSIxMzIyMzQ5MjA1MjQ2?=
 =?us-ascii?Q?MzcwNzYiIGg9IlBBclVKc0tiWDc4M3ZTMCtrVUdDem1RSUtIOD0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUJRSkFB?=
 =?us-ascii?Q?Q1U0OFdvOWNyVkFab2tMck5veFVlZG1pUXVzMmpGUjUwT0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUNrQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBUlgyazFBQUFBQUFBQUFBQUFBQUFBSjRBQUFCbUFHa0Fi?=
 =?us-ascii?Q?Z0JoQUc0QVl3QmxBRjhBY0FCc0FHRUFiZ0J1QUdrQWJnQm5BRjhBZHdCaEFI?=
 =?us-ascii?Q?UUFaUUJ5QUcwQVlRQnlBR3NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1lBYndCMUFHNEFaQUJ5QUhrQVh3?=
 =?us-ascii?Q?QndBR0VBY2dCMEFHNEFaUUJ5QUhNQVh3Qm5BR1lBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVpnQnZBSFVBYmdCa0FISUFlUUJmQUhBQVlRQnlBSFFBYmdC?=
 =?us-ascii?Q?bEFISUFjd0JmQUhNQVlRQnRBSE1BZFFCdUFHY0FYd0JqQUc4QWJnQm1BQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJtQUc4?=
 =?us-ascii?Q?QWRRQnVBR1FBY2dCNUFGOEFjQUJoQUhJQWRBQnVBR1VBY2dCekFGOEFjd0Jo?=
 =?us-ascii?Q?QUcwQWN3QjFBRzRBWndCZkFISUFaUUJ6QUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHWUFid0IxQUc0QVpBQnlBSGtB?=
 =?us-ascii?Q?WHdCd0FHRUFjZ0IwQUc0QVpRQnlBSE1BWHdCekFHMEFhUUJqQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBWmdCdkFIVUFiZ0JrQUhJQWVRQmZBSEFBWVFCeUFIUUFi?=
 =?us-ascii?Q?Z0JsQUhJQWN3QmZBSE1BZEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQm1B?=
 =?us-ascii?Q?RzhBZFFCdUFHUUFjZ0I1QUY4QWNBQmhBSElBZEFCdUFHVUFjZ0J6QUY4QWRB?=
 =?us-ascii?Q?QnpBRzBBWXdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdZQWJ3QjFBRzRBWkFCeUFI?=
 =?us-ascii?Q?a0FYd0J3QUdFQWNnQjBBRzRBWlFCeUFITUFYd0IxQUcwQVl3QUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFDZUFBQUFad0IwQUhNQVh3QndBSElBYndCa0FIVUFZd0IwQUY4?=
 =?us-ascii?Q?QWRBQnlBR0VBYVFCdUFHa0FiZ0JuQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFC?=
 =?us-ascii?Q?ekFHRUFiQUJsQUhNQVh3QmhBR01BWXdCdkFIVUFiZ0IwQUY4QWNBQnNBR0VB?=
 =?us-ascii?Q?YmdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBSE1BWVFCc0FHVUFjd0Jm?=
 =?us-ascii?Q?QUhFQWRRQnZBSFFBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFB?=
 =?us-ascii?Q?QUFBQ0FBQUFBQUNlQUFBQWN3QnVBSEFBY3dCZkFHd0FhUUJqQUdVQWJnQnpB?=
 =?us-ascii?Q?R1VBWHdCMEFHVUFjZ0J0QUY4QU1RQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFB?=
 =?us-ascii?Q?QUJ6QUc0QWNBQnpBRjhBYkFCcEFHTUFaUUJ1QUhNQVpRQmZBSFFBWlFCeUFH?=
 =?us-ascii?Q?MEFYd0J6QUhRQWRRQmtBR1VBYmdCMEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFIWUFad0JmQUdzQVpR?=
 =?us-ascii?Q?QjVBSGNBYndCeUFHUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFB?=
 =?us-ascii?Q?QUFBQUFDQUFBQUFBQT0iLz48L21ldGE+?=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abrodkin@synopsys.com; 
x-originating-ip: [188.243.7.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 500d3da6-61d9-48a7-b798-08d7990ccc5d
x-ms-traffictypediagnostic: CY4PR1201MB0069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1201MB0069252302F80AD7D818F999A1340@CY4PR1201MB0069.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(39860400002)(376002)(346002)(199004)(189003)(86362001)(8936002)(66946007)(64756008)(66446008)(33656002)(66556008)(66476007)(55016002)(76116006)(52536014)(6636002)(6862004)(5660300002)(2906002)(478600001)(7696005)(4744005)(6506007)(53546011)(54906003)(8676002)(71200400001)(26005)(4326008)(186003)(81166006)(81156014)(9686003)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0069;H:CY4PR1201MB0120.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WgMrK8tGLAXOWLY+MjreUMlNnspER6mj9oMFeE1UM93Uc+H9FgvGd+LxsV+/G8mwhIhCO7XZyrsGWH2u4BiFuJtzQIoZ2uymiaKKEakX5NSgreVGKB3w+GvzopKqbsTSyDFhKtkQoaOOz/bba6EYpL4yeYD7lyVy1IO7DWfkNQ10DhCpt3XPryaKRbRVRmeJ93VmQQGGSbZnBml98ibuymGkJ2d36MwOT/InLPiUry+s8drWCY/CeVtEB7FUh6n5GRkyZtWf5r1/9wRxrpC/ILKMsb61lbJB1OJzHOIfsJfn+lqmv6mW2AO4BYlMLQhBcFJrHB4hesYw3L0KzRwVp5pwVAOUIAa3R/xOAhdMSJh2BeuNLuh/pRCt2zrqx96phIMqZHQrHrXPzA65PCn54F/8Ih3exvHXFWgD1o6ORh5PBXukuzka0EDQs394om3Z
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 500d3da6-61d9-48a7-b798-08d7990ccc5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 16:14:14.1916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1a7v2FKJDDvsqbIyJujV/uLJ0sNJyZSujfvRclRSnQl3GmluQ2r2nxK3DP7REC6fX++lXlE7lNtHdOURZgvkUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0069
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

> -----Original Message-----
> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Sent: Tuesday, January 14, 2020 7:09 PM
> To: netdev@vger.kernel.org
> Cc: Joao Pinto <jpinto@synopsys.com>; Jose Abreu <joabreu@synopsys.com>; =
Alexey Brodkin
> <abrodkin@synopsys.com>; Rob Herring <robh+dt@kernel.org>; Mark Rutland <=
mark.rutland@arm.com>; Vineet
> Gupta <vgupta@synopsys.com>; devicetree@vger.kernel.org; linux-snps-arc@l=
ists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH net 4/4] ARC: [plat-axs10x]: Add missing multicast filter=
 number to GMAC node
>=20
> Add a missing property to GMAC node so that multicast filtering works
> correctly.
>=20
> Fixes: 556cc1c5f528 ("ARC: [axs101] Add support for AXS101 SDP (software =
development platform)")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Acked-by: Alexey Brodkin <abrodkin@synopsys.com>

