Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CD122592
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 02:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfESAWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 20:22:25 -0400
Received: from mail.us.es ([193.147.175.20]:37246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbfESAWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 20:22:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51C0DFB448
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 02:22:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44AAEDA701
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 02:22:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28F9BDA709; Sun, 19 May 2019 02:22:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2B01DA704;
        Sun, 19 May 2019 02:22:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 19 May 2019 02:22:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AFB174265A32;
        Sun, 19 May 2019 02:22:18 +0200 (CEST)
Date:   Sun, 19 May 2019 02:22:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190519002218.b6bcz224jkrof7c4@salvia>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 04:27:29PM +0100, Edward Cree wrote:
> On 15/05/2019 20:39, Edward Cree wrote:
[...]
> Pablo, how do the two options interact with your netfilter offload?  I'm
>  guessing it's easier for you to find a unique pointer than to generate
>  a unique u32 action_index for each action.  I'm also assuming that
>  netfilter doesn't have a notion of shared actions.

It has that shared actions concept, see:

https://netfilter.org/projects/nfacct/

Have a look at 'nfacct' in iptables-extensions(8) manpage.
