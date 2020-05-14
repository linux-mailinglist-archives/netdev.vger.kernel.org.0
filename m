Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C171D34ED
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgENPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:20:53 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:40760
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbgENPUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 11:20:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvfqOXTAsWAJkzKquFrfWOTiHw3/bDpJR8hTyGFPTQ8giqpSMDhgVBPUC9oBh4jvkFd3kkHvK6rhMaJ9gZsF/wZVPj9mP81UQpTbrjRKEHp5yHooe+qek/Kx3Q/hXdVkj0Gqrv2LWzd8ujc310+Db6mFsvpgjXvQOEJsNtAaK3ha97SbNzMT2Ae/iEOG9/Ya8z3rmk/cd84mlf49OSWgDqS+pMM0Luctp9xVwIvYdcP9JSIsDBaTpHYlLQX0SVjOLiLfCMzBPqY7K+0u4UV5Y1cuV5AcExnIHLnyfzFUSTvsky47HKTeTkaZudChy/NgRq0ymEo4TVPWCu7Jj/HUHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Uuynnnd4CEzOLWd70+YS5PnN011Spn9AEwZzlO0UqA=;
 b=XSunp/hLcNa7co5hHUxbs7HLXPLCdln0i8TqOX1kyUEEUKpkTGTOT+KnskG7eDRRcSab1qlCdOUQd9472z9RoW1izZE8NmDNkTtWjV2+bOMU1UcfkhLlUVqRh8aNKwix0fXpGbRB6PzcBV8MGGEhsek1ECLsqvo3spj/pF/eKBWHrNNb2PcOqWr0dC7KypjR5Z8qVQF7+Z582ryiLp9IzDxV7Ciu74pGWOnDaxtnzrsnpR5og7vohdS8a+9+fb/hwGVjn39EaDFM2BvsM3O1C+TqdNBJHelxVcwNUbOjtCZM/Yy1Tmy6KxJw+1bazm29QtPeqd3Q2N+IjNI7WzBnxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Uuynnnd4CEzOLWd70+YS5PnN011Spn9AEwZzlO0UqA=;
 b=J631TzcIEfe13BsafZVrgPNeM+J33obofHrTP9P6UaC0xh4NlrhtW6nXdTVAVLVyKBg8SLH0eOkpBhoCUnln8E1KFz+TkXLpzegYBmrz/Pha4cfXpGvMXZiRc37vuCCnp+v8ezxXLh10UDARuvdw/MxtQg4IJuMMezthyRQ3Wcc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB4461.eurprd06.prod.outlook.com (2603:10a6:803:62::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 15:20:49 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 15:20:49 +0000
Date:   Thu, 14 May 2020 17:20:41 +0200
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] net: uapi: Add HWTSTAMP_FLAGS_ADJ_FINE/ADJ_COARSE
Message-ID: <20200514152041.GB12924@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514102808.31163-3-olivier.dautricourt@orolia.com>
 <20200514133809.GA18838@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200514133809.GA18838@localhost>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from orolia.com (2a01:e35:1390:8ba0:9b:4371:f8a6:4d92) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Thu, 14 May 2020 15:20:48 +0000
X-Originating-IP: [2a01:e35:1390:8ba0:9b:4371:f8a6:4d92]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c99651c-00ac-4a3d-6bcf-08d7f81a61ed
X-MS-TrafficTypeDiagnostic: VI1PR06MB4461:
X-Microsoft-Antispam-PRVS: <VI1PR06MB4461B9491042384DEB9274098FBC0@VI1PR06MB4461.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unnzvN9GzV+alRj/saXJNkyD9TZ41utzfUIJ/le7MUeXOGODzsJuMdq2Nw6ClwFjbn98Fns+zrs+Knyks8mJVAwi6hBlQgqeQdEmt0jB3AWlyMufvoNC0lEf/NNfPFM9eHqvv3qxmQ3S64ZnIQTMqX7jIpN0auW2zBIqa00JE9INKwevTJ51OkX82sLszA3diCaFn7o97GaeVSUYgvfRopTMVFkCRTS8hLImtRFasBuGIU+B6g8LFGr25dS1bM/eEumrJ3ZE8dnTBFGYgiAAGRaOL8f6hRJredTdMsfWDmOUIczEzOenBld+I7WgaBrzEMp96QwaRXF7uSuTZaZHnTc0Edlui7a6lK27wWqsXKiV4Onw+1xBvqqn/6miJ54lPutlohPpHPKogqboeO6825UI2upd/hjJJtVnnMAP/ZYzC4Z+61Z90Rc1ePPa+HwR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(346002)(366004)(376002)(396003)(7696005)(8936002)(44832011)(52116002)(66476007)(55016002)(54906003)(36756003)(66556008)(478600001)(8676002)(316002)(66946007)(4326008)(33656002)(2906002)(5660300002)(6916009)(186003)(2616005)(16526019)(6666004)(8886007)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hssvDJFHIy/73NDduJfPe+CQlUFs7z3z/sb5+DoohzH5oIQUV4cazfKNs+ivur+srbwOeisQT7mheyBsw5TAANfc+NUz8P1S5sijhkM6odmgT6UfgqaxX5HFs1bLY0S3uVx2UfOgJIG+BDOaVVN4TL7HRKRnL5ydvUeXtWNZxj8XAt1dZh+F9isOw52SxIQR7U6ql1djQftrP7E5frcifS+C3fzto4ZhWuqfq6cxACGdETzyEqSYcgi4OXyXdC6sUO97x+6Yfwmb2/uEcpsYchVSZXMzx6JP00C2ohZ9mlDyNC+zvOBey5qI9V2fommYuZA/BdthiEFTwPoVn2lVQpLLInlhmgV46NoiUyi5lGHzk9LM2rTpCKXoJoEkH/kRlWZS8DuJoG3IO8kftMYj48d/diGnaddGQ6UQqI2lCH+7ebG7PJTt1pe3R8KWH9D2uTqcsY/rh/Y/vvCEQ/tWHQTV4yfZjLKH7H21jilInQg67K4tmDuPcj/zoa2epjaWsoKifuAclzRE4RCZLw1WXeSYXsL1bR+BT8TW5hDbRTw=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c99651c-00ac-4a3d-6bcf-08d7f81a61ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 15:20:49.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPo5GJ6sKS6VimU5rU7aaagx1QK8EcWzxa5E3FdANtZJYy351ujp0g4DyUetQVVRrYW3vmzpkeLrhUDLHrbOrJUQUlmkAtfk+GOpVwZkuVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB4461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/14/2020 06:38, Richard Cochran wrote:
> On Thu, May 14, 2020 at 12:28:07PM +0200, Olivier Dautricourt wrote:
> > This commit allows a user to specify a flag value for configuring
> > timestamping through hwtsamp_config structure.
> >
> > New flags introduced:
> >
> > HWTSTAMP_FLAGS_NONE = 0
> >       No flag specified: as it is of value 0, this will selects the
> >       default behavior for all the existing drivers and should not
> >       break existing userland programs.
> >
> > HWTSTAMP_FLAGS_ADJ_FINE = 1
> >       Use the fine adjustment mode.
> >       Fine adjustment mode is usually used for precise frequency adjustments.
> >
> > HWTSTAMP_FLAGS_ADJ_COARSE = 2
> >       Use the coarse adjustment mode
> >       Coarse adjustment mode is usually used for direct phase correction.
> 
> I'll have to NAK this change.  The purpose of HWTSTAMP ioctl is to
> configure the hardware time stamp settings.  This patch would misuse
> it for some other purpose.

Hello,
 
Can't we consider this as a time stamp settings ?
I don't see where we could put those driver-specific flags.
That flag field was reserved for futher improvements so i found
it acceptable to specify that here.

This ioctl structure is used in the driver initialization
function which is reponsible for configuring the mac.
Adding an ioctl for that may be redundant.
But i'd like your opinion on that.

> 
> Sorry,
> Richard


Regards,

-- 
Olivier Dautricourt

