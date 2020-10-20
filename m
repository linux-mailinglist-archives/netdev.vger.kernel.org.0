Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1314293F78
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408688AbgJTPWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:22:51 -0400
Received: from correo.us.es ([193.147.175.20]:52294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408668AbgJTPWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:22:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 245CC1761AF
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:22:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1661DE151C
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:22:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EE13DFF13A; Tue, 20 Oct 2020 17:22:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9491CFB388;
        Tue, 20 Oct 2020 17:22:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 17:22:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 655FA4301DE0;
        Tue, 20 Oct 2020 17:22:46 +0200 (CEST)
Date:   Tue, 20 Oct 2020 17:22:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     "longguang.yue" <bigclouds@163.com>, yuelongguang@gmail.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] ipvs: adjust the debug info in function set_tcp_state
Message-ID: <20201020152246.GA19962@salvia>
References: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg>
 <20200928024938.97121-1-bigclouds@163.com>
 <alpine.LFD.2.23.451.2009300803110.6056@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.23.451.2009300803110.6056@ja.home.ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:08:02AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 28 Sep 2020, longguang.yue wrote:
> 
> > Outputting client,virtual,dst addresses info when tcp state changes,
> > which makes the connection debug more clear
> > 
> > Signed-off-by: longguang.yue <bigclouds@163.com>
> 
> 	OK, v5 can be used instead of fixing v4.
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Applied, thanks.
