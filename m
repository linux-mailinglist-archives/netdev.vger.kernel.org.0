Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF46F1940BC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgCZOCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:02:35 -0400
Received: from correo.us.es ([193.147.175.20]:51292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgCZOCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 10:02:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74FB611EB91
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:02:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 680B6DA38D
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:02:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E034DA3A8; Thu, 26 Mar 2020 15:02:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3386FDA38D;
        Thu, 26 Mar 2020 15:02:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 15:02:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0C83C42EF4E0;
        Thu, 26 Mar 2020 15:02:30 +0100 (CET)
Date:   Thu, 26 Mar 2020 15:02:29 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipvs: optimize tunnel dumps for icmp errors
Message-ID: <20200326140229.emeplg75xszpd7rs@salvia>
References: <1584278741-13944-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <alpine.LFD.2.21.2003181333460.4911@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.2003181333460.4911@ja.home.ssi.bg>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 01:36:32PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sun, 15 Mar 2020, Haishuang Yan wrote:
> 
> > After strip GRE/UDP tunnel header for icmp errors, it's better to show
> > "GRE/UDP" instead of "IPIP" in debug message.
> > 
> > Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> 	Simon, this is for -next kernels...

Simon, if no objection, I'm going to include this in the next nf-next
pull request.

Thanks.
