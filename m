Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558F01B58B4
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgDWJ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:59:15 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:16009
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbgDWJ7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 05:59:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL4LRhSpYJsx1k6WfDOWLT6idzyWd+gQB6fdIGORWENoDfcGyWrKBsbj5r+pRMrHMvCgorzNUEC9Hh1qP3zKJQW8DqcNIavVJG2QI8xKCY/Epqc/jRx0SNvWbQH4eyn08DSkw9KL00tbn02MpjrsCHiZ8YGz5pmuQgIRctlFTFX2PjJ5qxFLfhvttFKHwADixS9BgkJD3ME7UupZAyEiXBcCQmollVP1xT3gErzxM38NSbWW+nBx7g12dYfUPp3etHgiEi5bZ/RGEg58Tri0M8tqlpsMfKnh4nYQlhFD4oJ8RS9eT4ZhH3oXUL1zjAKbTIAgHWjBbQ1UU2aOCIrgZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBY2AQGfa6K8poth3ZafVzXtTru3oH6q9Z8adhg843c=;
 b=gGN9XsMsTfIoqp/tip4dKU4Yu+ZZRYHQ6j01GNoGGUbKdjJe1zATZ41VSZ122iZJlEhrREpHmwYyPjBCBmMv5WKq1pu3A5Sh8g2Oc+uyuK9BwvO8OBGJa+syBHS1Fgaci0po9DGAgm5/MIZgObotUO13QI2H3PmUp6aJ8/HVDGX5sRBzc5bMGJbX3Nw+TGzyax7q/fhggjdPAqcD8otHIt/bzofxH6/51SQrrIAXE3J2C93g4bRmNtrQL86p7z8LxV9RdYxBLc1sMGFusKiwsa9jgX9jONdj3MkjaAFSJyxGx8z5rB4EQ/h8yFw2N+ocdLcvVYXvcbTJjhm2q1vRtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBY2AQGfa6K8poth3ZafVzXtTru3oH6q9Z8adhg843c=;
 b=YtT9AEbs1OKQ6/uWphGouzpC//H+aOBb97rmUmUUHEQ11Y5vaSV00MtQcECSXEfMOmvnnzWkYGEo65Xd/x5O5JB4gMzfEH5YEr7V9sRQtWFGuSWZi/3QxpbFO4wUBogpx0x4UWyH07hOSmBuOOw7L3BNaiZMEyGw9skMe+maHP8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3420.eurprd05.prod.outlook.com (2603:10a6:7:30::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 23 Apr 2020 09:59:10 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 09:59:10 +0000
References: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com> <20200422130245.53026ff7@hermes.lan>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2-next] tc: pedit: Support JSON dumping
In-reply-to: <20200422130245.53026ff7@hermes.lan>
Date:   Thu, 23 Apr 2020 11:59:08 +0200
Message-ID: <87imhq4j6b.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 09:59:10 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9fbfcd3-9a9a-4b88-3ff1-08d7e76cf869
X-MS-TrafficTypeDiagnostic: HE1PR05MB3420:
X-Microsoft-Antispam-PRVS: <HE1PR05MB342018EF36DF127227ACEEE4DBD30@HE1PR05MB3420.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(478600001)(316002)(5660300002)(81156014)(186003)(36756003)(8936002)(2906002)(4744005)(16526019)(6496006)(6486002)(66556008)(66476007)(6916009)(8676002)(86362001)(956004)(52116002)(4326008)(2616005)(66946007)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6JCxl5iu2FKvKOg2pZLgqDV9X3iiQNDS3isdTcC2DAyFROXlPsWNz4x7nrwjHgcXZmjuuX2qaTbWvt4nrd2Vfdk6EIja3g4vtdOn1TPahGD1IgZEPklI6ol0NlhELsj6NIdhe7I33uuq24IUoS4F/UlTKJfiYi/dilJQD1lfWu5aqrpo2q0NMrSn2auYIL3COn3Q8BBjHEqaixUy65PcfgUDB/pM16K4RClDe1ZgVeFDnzX6XRIxV3TBaenZzJ5wQg02Tfse3d1On6os82cFe5LClEp7fI1D52aOjLajzXbxDrO1TYyI5Pqa9siPfC6ox0f1e+l66Yb/MnZiSUI/M/G64ujxtQhI86SGqA8iFRiS3/Sq3ke/ITKxtF0Rec5NarYdr92gdKCCaIDcFYwHYMGqzinDr8IG6rjGWVP2cQUBHLK5D0l3SAn7Hf2h5eDx
X-MS-Exchange-AntiSpam-MessageData: D4+AoNKHQDdsDdd2Dqgvtw9xz5kk9Kw4vSGcecDxOFsOlW+a7Fr3es6C8zGQTHv0bsY+xVNkW/AvDTxl/rZEPB0+Mm8h9HZO0zTHctPIQtV+k6TTyJg2czOpQ1gDFiXFW3q+J0Bsn3jGiWMWClvMNw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fbfcd3-9a9a-4b88-3ff1-08d7e76cf869
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 09:59:10.8574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DU3ux9WfdTZ9qkgxc5ADgnYJASZJ62UdOud6jFPmQHDmfPxLCoddK9rSce9Uw0YmB+UdatFIh7szcP62pPWBGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Wed, 22 Apr 2020 20:06:15 +0300
> Petr Machata <petrm@mellanox.com> wrote:
>
>> +			print_string(PRINT_FP, NULL, ": %s",
>> +				     cmd ? "add" : "val");
>> +			print_string(PRINT_JSON, "cmd", NULL,
>> +				     cmd ? "add" : "set");
>
> Having different outputs for JSON and file here. Is that necessary?
> JSON output is new, and could just mirror existing usage.

This code outputs this bit:

            {
              "htype": "udp",
              "offset": 0,
              "cmd": "set",   <----
              "val": "3039",
              "mask": "ffff0000"
            },

There are currently two commands, set and add. The words used to
configure these actions are set and add as well. The way these commands
are dumped should be the same, too. The only reason why "set" is
reported as "val" in file is that set used to be the implied action.

JSON doesn't have to be backward compatible, so it should present the
expected words.
