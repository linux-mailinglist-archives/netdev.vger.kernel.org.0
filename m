Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAEF1D348A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgENPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:09:15 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:31486
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbgENPJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 11:09:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJOl1rcYPXpyhPBtaiOkLx+6McHpp14c/geAseKclVsY90TPjXfaGrHKsxwpS9HqIA7BwpyAxfUZ1io9Oxu9JlmDh/iKkd9XzNvxFIAlDCNMkGtcwjd9dpOoLqSEUFhCtts0PjR+9D454336NwIu8yVvTjS+VBAqfMH2hej+2peyM8FTmZ+mL/S2yhBuyYEBH6dtH4QVSCNfrrLJlhFxoy/xbnqlWzdCS5s/BoHGUHyFC9UNWQhg3j6fJV05OP7bF0u5mKPk7+VJSF1hNsHrb//lnL/E/2r/4zuh+/XFaBh1krHGzlTzEx/Qnr55QhhqQgakhkauLuoZAWw9PDLhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1VZK4NqNI1gsbjzqqsbEPa9rpf72tu/TuSjivGJ8Jg=;
 b=GKXhjOiE0bVUXv5L0NKq7zfX7BeLCTQ0/mnaKJKeX0iBkCaHfofGRU9QH9r10HzA1NvSQyqaMqbNYYnvnCnrrP5kKV+dzeySzsAjmR3uxvy9hzbcnrsvJhu060vjtn9rQpiENSdJbLjVpQxY7jwyhIU2u30qeQ5O8lXOO8K5dsAyBDEH0hvHiYfEfIoNURknBQCeIT+kLHuwPE91RNUzaCnUwXFrnpm7qh3bBMxk7REjZ4QY2h3N3rl1rOCymmS7tFTHPyKYkP9dynWJM5rlIvi7Ivm1ZtzCan1435u2Iv4ydAsu+XT1MDQk6R0Jt4VX85S5r1X2+JdS6Z/qz9IV6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1VZK4NqNI1gsbjzqqsbEPa9rpf72tu/TuSjivGJ8Jg=;
 b=Em2tu9IQXwdqDqo3lmX7uHmZdtt6qfBMaWfFKdHpuC5tuFSErWYoKMy9byn4xlunQOXBWe6WRWyNs/7uEMMqlVV9pPQPegNLV3F2hIEIWtnJSMQBPBgqNT6+5HkYZptSYXbsVrVMS+DwABA21BA322PeXRbEr9LsQgAVGjllopQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB5486.eurprd06.prod.outlook.com (2603:10a6:803:96::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Thu, 14 May
 2020 15:09:09 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 15:09:09 +0000
Date:   Thu, 14 May 2020 17:09:01 +0200
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
Message-ID: <20200514150900.GA12924@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200514135325.GB18838@localhost>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: PR2PR09CA0018.eurprd09.prod.outlook.com
 (2603:10a6:101:16::30) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from orolia.com (2a01:e35:1390:8ba0:9b:4371:f8a6:4d92) by PR2PR09CA0018.eurprd09.prod.outlook.com (2603:10a6:101:16::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Thu, 14 May 2020 15:09:08 +0000
X-Originating-IP: [2a01:e35:1390:8ba0:9b:4371:f8a6:4d92]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63b66877-77b3-4b56-8b82-08d7f818c072
X-MS-TrafficTypeDiagnostic: VI1PR06MB5486:
X-Microsoft-Antispam-PRVS: <VI1PR06MB548661B8F668CE27B1A70A588FBC0@VI1PR06MB5486.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmJ/p6CplteI97VQuMFwQwDoSxGlhmyj7yuqLV9wdF3LYXIckYLHhSSsI2slOaBs7Y1lmz+p8tdHEV3MhgMkxFMFIduHUHMcEivFkB37HUHZB8Oszne7/5YeSuKRZk39puuRrdRtfpSJxNShCOmk+4RUdNW3AmzmTDM1Ennyr/F+DAZ76XKHl76ma6HCYeoU1j8QH0V15KFIJ0fKOp3DVsRkMh9ieq6ilj5Y0biQCa4tls+OJhfchWMyLLGIqZn2chIIOhLAgG/EvHM4VmsnznlQv1aibf1kuZUT6d4UI69se/nC8FMsvhKcpO4pE0wzPrU6ufyP6wc7heYuS096qYrJm2u8rbDf4IbJE6lHj96qiW4Mo8xI6aDGAt0tIYYLh0f7fXjpy7wqyP7649lvqZvIKknkj2+PaoatJKT7uqVLM3Qb+lZwWcwtVJRDdEPu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(8936002)(7696005)(33656002)(54906003)(16526019)(52116002)(1076003)(316002)(44832011)(2616005)(186003)(5660300002)(4326008)(36756003)(55016002)(478600001)(86362001)(6916009)(2906002)(8676002)(6666004)(66476007)(66556008)(66946007)(8886007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lVDsmESqQMXDW5RTK+OYOzFNwA1Avtgu24c3tfIAsaQ7ODp8kKqxcFY1wTaaiGBDjiccuA8nlHy/8N635I8Hy1XRU/+d/jYNCwgQH29ZqWHOXgozctzqGuazo2v/m+R625GZbOYPj60pybI9KRi+v/JSpGSUqykrC9C5PYYO5l7zx6SXnOOboe7lpFexb0rm8zLcqouMy6plzN1t/IVvO1G3Cm337+wP44j+JDCXWKhSYOWMPu89mTeSh5AQzyBccn+5nIDJ4LEqFiy3Oxojk+3gWqS98dZG4/89jXmngAl3/BZ5f5PU44dQDHskW9w7FlgBAL5F19Hwsx1WCtCuJ5MHLY40XEIV+ScGtlReEPrWzsOj4McCVrl8X+ngsq9tFWsRwf+6rEG3eNuVXpLmRgaTb9SbVcA2w3HCsWg0zMWLcNRGcE0Bkq3bZcddAfJAdkkVFW/NYK0DDdUONI1jwQcMC5ciBXUUrUs71mT4D/7GLGMWbY52uDXd75KIVMFBasg98nlM4npcC9E1mbacOOUnWmFKcHi0KRdDEdard9o=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b66877-77b3-4b56-8b82-08d7f818c072
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 15:09:08.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+5NTP+ktgaMmQidEuxa4GgfXm6b9Hij9yG/0P+LvMMjJVd2CjE/e1CkGHVmql2FtzPz6rC2gT3B4JfRCNz1HAov4z59q/1KFM4P7yNdlZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB5486
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/14/2020 06:53, Richard Cochran wrote:
> On Thu, May 14, 2020 at 12:28:05PM +0200, Olivier Dautricourt wrote:
> > This patch series covers a use case where an embedded system is
> > disciplining an internal clock to a GNSS signal, which provides a
> > stable frequency, and wants to act as a PTP Grandmaster by disciplining
> > a ptp clock to this internal clock.
> 
> Have you seen the new GM patch series on the linuxptp-devel mailing
> list?  You may find it interesting...
  
  I have not, but i'll look deeper in the way this use case is handled
  in this series..

> 
> > In our setup a 10Mhz oscillator is frequency adjusted so that a derived
> > pps from that oscillator is in phase with the pps generated by
> > a gnss receiver.
> >
> > An other derived clock from the same disciplined oscillator is used as
> > ptp_clock for the ethernet mac.
> >
> > The internal pps of the system is forwarded to one of the auxiliary inputs
> > of the MAC.
> >
> > Initially the mac time registers are considered random.
> > We want the mac nanosecond field to be 0 on the auxiliary pps input edge.
> >
> >
> > PATCH 1/3:
> >       The stmmac gmac3 version used in the setup is patched to retrieve a
> >       timestamp at the rising edge of the aux input and to forward
> >       it to userspace.
> >
> > * What matters here is that we get the subsecond offset between the aux
> > edge and the edge of the PHC's pps. *
> >
> >
> > PATCH 2,3/3:
> >
> >       We want the ptp clock to be in time with our aux pps input.
> >       Since the ptp clock is derived from the system oscillator, we
> >       don't want to do frequency adjustements.
> >
> >       The stmmac driver is patched to allow to set the coarse correction
> >       mode which avoid to adjust the frequency of the mac continuously
> >       (the default behavior), but instead, have just one
> >       time adjustment.
> 
> You can use the new ts2phc program (in the linuxptp-devel patch
> series, soon to be merged) by configuring it to use the nullf servo.

  My issue is that the default behavior of the stmmac driver is to
  set the mac into fine mode which implies to continuously do frequency
  adjustment, So if i'm not mistaken using the nullf servo will not address
  that issue even if we are not doing explicit clock_adjtime syscalls.
  
  Patches 2/3 and 3/3 are reponsible for preventing this.
> 
> Thanks,
> Richard
> 
> ATTENTION: This email came from an external source.
> Do not open attachments or click on links from unknown senders or unexpected emails.

Regards,

-- 
Olivier Dautricourt

