Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74508074B
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388871AbfHCQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 12:40:22 -0400
Received: from correo.us.es ([193.147.175.20]:36760 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388841AbfHCQkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 12:40:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5C18C39E2
        for <netdev@vger.kernel.org>; Sat,  3 Aug 2019 18:40:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A60C51150CB
        for <netdev@vger.kernel.org>; Sat,  3 Aug 2019 18:40:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9B699DA7B9; Sat,  3 Aug 2019 18:40:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57C90DA72F;
        Sat,  3 Aug 2019 18:40:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 03 Aug 2019 18:40:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.192.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 10BB14265A2F;
        Sat,  3 Aug 2019 18:40:16 +0200 (CEST)
Date:   Sat, 3 Aug 2019 18:40:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     hujunwei <hujunwei4@huawei.com>, wensong@linux-vs.org,
        horms@verge.net.au, kadlec@blackhole.kfki.hu,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Mingfangsen <mingfangsen@huawei.com>,
        wangxiaogang3@huawei.com, xuhanbing@huawei.com
Subject: Re: [PATCH net v3] ipvs: Improve robustness to the ipvs sysctl
Message-ID: <20190803164015.eiy4hanb27qyrjzz@salvia>
References: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
 <4a0476d3-57a4-50e0-cae8-9dffc4f4d556@huawei.com>
 <5fd55d18-f4e2-a6b4-5c54-db76c05be5df@huawei.com>
 <alpine.LFD.2.21.1907312052310.3631@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1907312052310.3631@ja.home.ssi.bg>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 08:53:47PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 1 Aug 2019, hujunwei wrote:
> 
> > From: Junwei Hu <hujunwei4@huawei.com>
> > 
> > The ipvs module parse the user buffer and save it to sysctl,
> > then check if the value is valid. invalid value occurs
> > over a period of time.
> > Here, I add a variable, struct ctl_table tmp, used to read
> > the value from the user buffer, and save only when it is valid.
> > I delete proc_do_sync_mode and use extra1/2 in table for the
> > proc_dointvec_minmax call.
> > 
> > Fixes: f73181c8288f ("ipvs: add support for sync threads")
> > Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> 	Yep, Acked-by: Julian Anastasov <ja@ssi.bg>

Applied, thanks.
