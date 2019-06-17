Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C0248CC1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfFQSoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:44:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37814 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728766AbfFQSoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:44:00 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 174B84000AC;
        Mon, 17 Jun 2019 18:43:59 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Jun
 2019 11:43:55 -0700
Subject: Re: [RFC net-next 1/2] net: sched: refactor reinsert action
To:     John Hurley <john.hurley@netronome.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <fw@strlen.de>, <jhs@mojatatu.com>,
        <simon.horman@netronome.com>, <jakub.kicinski@netronome.com>,
        <oss-drivers@netronome.com>
References: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
 <1560522831-23952-2-git-send-email-john.hurley@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <dbd77b82-5951-8512-bc9d-e47abd400be3@solarflare.com>
Date:   Mon, 17 Jun 2019 19:43:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1560522831-23952-2-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24684.005
X-TM-AS-Result: No-2.131800-4.000000-10
X-TMASE-MatchedRID: fgYTp5XatxbmLzc6AOD8DfHkpkyUphL9q3MsQB4M7MJs98Z8fG/6kfeH
        aPJtCROSlAKRBA/WCMpkXWktuhCgQigawIgP9cflOPqRT674Vr313XWfa1A1k5soi2XrUn/JxbG
        vmM9nj5NQSFbL1bvQAcK21zBg2KlfiN2nYwbbDKzycr1z7aIhr91yuyZpUy8Mhb3QCSGDmYj/og
        dUk8JQLvAdfn5DyOPDXC6uJnc/p0SsglkltB8xdGpozkualSTDO6clcnPxfVB+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.131800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24684.005
X-MDID: 1560797040-99u21mQYVgiv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2019 15:33, John Hurley wrote:
> Instead of
> returning TC_ACT_REINSERT, change the type to the new TC_ACT_CONSUMED
> which tells the caller that the packet has been stolen by another process
> and that no consume call is required.
Possibly a dumb question, but why does this need a new CONSUMED rather
 than, say, taking an additional ref and returning TC_ACT_STOLEN?

Apart from that, the series lgtm.

-Ed
