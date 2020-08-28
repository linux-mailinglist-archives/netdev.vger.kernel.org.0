Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7412556E2
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgH1IvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:51:04 -0400
Received: from mail-eopbgr1390059.outbound.protection.outlook.com ([40.107.139.59]:27872
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728706AbgH1IvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:51:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq2C4TdVCcMmbFTwTjtUDp6/SByJRZbgOTrx0u0luES75NH6GTy/th94pL87TBIwdVm6s2n9GBGeWfOmAhXXk5MfcxGduhaLKNSuHWWhkCXXMPwqt25f9BbL35jJaKjonH22mYwavC2TLhxf58GBxaViDG6UBx+9mi5N/FZC7zdgu3DvQcmlqk24Oi6wkUCd9pYC5ZWw5Ba9NDlg6OYaaF1ojZQaWl9B84A61DhvEuwzxVCihZ5O3FoIb9L63qBIjdxdZ/cd9XoTN5hxHSGxjTjVa18wh7ZXH2MkeokByYnQ7r+6dFgEMDFKiRIEz31pAuR5uZhmLispda/cBgQX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnjJHL0gxG5jZRt8tMBxxuGebXv8OYI/qmKpGwZX6UY=;
 b=l5VYHxEJRW/aMe4INpZv87vkJzNTJpDDw7OzuyG4AjX6lGtpSSfMiWysgaZ2mgvfMlAN2csem3UKs6ts0iN+ZxcMroyEO0flH6GJFljAbZeZk35o9q/QCvQIA9IxBniSWZ0LbKdPA+VwjGnU5Ub8UlUOZShbDJgylyr/jx2H7ZK+FHH3+iNbWxiH+RcqdKpF/8e7vAAbVBrwFXbmjrnyg97zkn4db5houFNFUrQqH9CMVJAlu0L+hdA2/EvesHrF6tEoIVS35JnlyioxxIY7UqPLIdBx/yWwCgCIKreqtgOElQWBnoylJci2b37dni2IzlepW+G1d161QHvnlahX2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=iisc.ac.in; dmarc=pass action=none header.from=iisc.ac.in;
 dkim=pass header.d=iisc.ac.in; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iisc.ac.in;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnjJHL0gxG5jZRt8tMBxxuGebXv8OYI/qmKpGwZX6UY=;
 b=NifT15rGmjkMtAcDx0p4NW0z3nRRBsi6uAskj3DhUmLBWVhjkNv5orsZRqBrKZGbZE731q99UsFDVI1DE9U4q33b193A1f2V9k1suXy70qNPi3BGaUfZIPOd61USZTgwKFCFjkDOTENniQN09wc9E68zz54sJ6OdcTjNLRwU1Eg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=iisc.ac.in;
Received: from MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:37::23)
 by MA1PR01MB2219.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:38::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 28 Aug
 2020 08:50:55 +0000
Received: from MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::b478:1d:994f:46c1]) by MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::b478:1d:994f:46c1%6]) with mapi id 15.20.3305.032; Fri, 28 Aug 2020
 08:50:55 +0000
Date:   Fri, 28 Aug 2020 14:20:53 +0530
From:   "S.V.R.Anand" <anandsvr@iisc.ac.in>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: packet deadline and process scheduling
Message-ID: <20200828085053.GA4669@iisc.ac.in>
References: <20200828064511.GD7389@iisc.ac.in>
 <c9eb6d14-cbc3-30de-4fb7-5cf18acfbe75@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9eb6d14-cbc3-30de-4fb7-5cf18acfbe75@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:37::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from iisc.ac.in (49.206.15.36) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Fri, 28 Aug 2020 08:50:55 +0000
X-Originating-IP: [49.206.15.36]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afba4db5-bca7-4ce1-c862-08d84b2f79d0
X-MS-TrafficTypeDiagnostic: MA1PR01MB2219:
X-Microsoft-Antispam-PRVS: <MA1PR01MB22199754B2B0395DB68B5742FC520@MA1PR01MB2219.INDPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0FKA3nWsh0y+C5Mi0xVG+VMvc+9UTvEphfjY/nu759CrTNCcM4+fWruOdSAi0iJAhI/LNRqry0mzKENaz1fuP7HNQVsBcZFM879t4tTwHN7Gip3E5W4jRXuWEr0vPp3HbBKtFOXstGAi5+oQLIRmo0UQ7aUmoy5dax0MCqA5DAOcRKack23I2fkhAJVXDTgJMqtjwHC7avipDXLI+o7Rp9/GdJvrbgWduHGD6Vy0tlePVFvDdex2iDE0Wuk9w3DfKaIuugQM+/lMyBwUf3cXnKpDR8qb1tTua6tVb378XsiTaCQ7ygrdx9hcwM8F8jkghOmrRfw1hhZ0DAwL9ij147oAN0jJp3G6keOkI1EVcZvtvRRPS8p8fwrBTrb/omRQ4J1WPEF55ZNDxh2Dz03Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(786003)(53546011)(5660300002)(55016002)(1006002)(26005)(55236004)(66476007)(86362001)(1076003)(478600001)(2906002)(66556008)(66946007)(6916009)(8676002)(52116002)(16526019)(316002)(7696005)(956004)(186003)(33656002)(83380400001)(2616005)(8936002)(36756003)(4326008)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F26y39M0jC4le0Aje6otejntk7Rh6/ztS6sDOsOI2FecnBGX+ar2okPF+h4KWjGxp7BCmND5hbdz6LdFnipZ0rejB/UYRNQgJxLq/tpNERV4I4wu0tjSd4jO/LJSL3IaAXxu5OKbSKs5UJkAsJh2ghMDjt2UVYTR2nYXQ2lq9jKQjbumBJ82Gm5TR0Jet089sOnEWyhxG0Rm0KRW3sFi5yp62BafMvj5RQV/gXT7Fx1RLSgBZvBz5W6PtDKuGEv0t3flSXc6vuHcswRgJpjtXinVrUw8eIDL9esCiTjwgQygM7Z03XOfvc8U0M4+c+hc/zLRZGHZe0YQxu6O/LjE9U2nmV9bDyYCi49VBbgX30WVbfS6FSb8ScyJepUL8JtmUE09G0iQZOyF2G7rwlECTJREXmFf2GycIEq3zfKs0YMDPcEeVhSZO37KkEwkSUEwVwhaEFUVpUucZJ3Q9h1HmfZO2VoDSLmqIt43xpzuTLkMh1j3edn1Pg/qLWft6+Ms9O4dDbaQSau3Q7pO3orMO3xHwMgaIqCWoco5ozbwEBN7cjL8KeI4gc/OQVUZnjE4DPDoqwqF/zXaozXRYwFSKeC+OvlmGFcasTFoRFeT0xF8nmIAyCahzfRdA5s6qqgI/zJkoqIkYMnIwQKbXlfj0g==
X-OriginatorOrg: iisc.ac.in
X-MS-Exchange-CrossTenant-Network-Message-Id: afba4db5-bca7-4ce1-c862-08d84b2f79d0
X-MS-Exchange-CrossTenant-AuthSource: MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2020 08:50:55.4655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6f15cd97-f6a7-41e3-b2c5-ad4193976476
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kx9Yom7Pr0pktsbU22pGp9lJQewBswCnj2aSAVaZ+h39ZfbVbx2ETWX8Az+g7yQ2HA1efQbCugOnUknvL1WJ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR01MB2219
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an active Internet draft "Packet Delivery Deadline time in
6LoWPAN Routing Header"
(https://datatracker.ietf.org/doc/draft-ietf-6lo-deadline-time/) which
is presently in the RFC Editor queue and is expected to become an RFC in
the near future. I happened to be one of the co-authors of this draft.
The main objective of the draft is to support time sensitive industrial
applications such as Industrial process control and automation over IP
networks.  While the current draft caters to 6LoWPAN networks, I would
assume that it can be extended to carry deadline information in other
encapsulations including IPv6. 

Once the packet reaches the destination at the network stack in the
kernel, it has to be passed on to the receiver application within the
deadline carried in the packet because it is the receiver application
running in user space is the eventual consumer of the data. My mail below is for
ensuring passing on the packet sitting in the socket interface to the
user receiver application process in a timely fashion with the help of
OS scheduler. Since the incoming packet experieces variable delay, the
remaining time left before deadline approaches too varies. There should
be a mechanism within the kernel, where network stack needs to
communicate with the OS scheduler by letting the scheduler know the
deadline before user application socket recv call is expected to return.

Anand


On 20-08-28 10:14:13, Eric Dumazet wrote:
> 
> 
> On 8/27/20 11:45 PM, S.V.R.Anand wrote:
> > Hi,
> >
> > In the control loop application I am trying to build, an incoming message from
> > the network will have a deadline before which it should be delivered to the
> > receiver process. This essentially calls for a way of scheduling this process
> > based on the deadline information contained in the message.
> >
> > If not already available, I wish to  write code for such run-time ordering of
> > processes in the earlist deadline first fashion. The assumption, however
> > futuristic it may be, is that deadline information is contained as part of the
> > packet header something like an inband-OAM.
> >
> > Your feedback on the above will be very helpful.
> >
> > Hope the above objective will be of general interest to netdev as well.
> >
> > My apologies if this is not the appropriate mailing list for posting this kind
> > of mails.
> >
> > Anand
> >
> 
> Is this described in some RFC ?
> 
> If not, I guess you might have to code this in user space.
> 
> 
