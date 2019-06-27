Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB43F58307
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfF0M6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:58:45 -0400
Received: from mail.us.es ([193.147.175.20]:42856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfF0M6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 08:58:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E085911EF4A
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:58:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D17EA10219C
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:58:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C611F6D2B0; Thu, 27 Jun 2019 14:58:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7009DA4D0;
        Thu, 27 Jun 2019 14:58:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 14:58:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A3CC64265A5B;
        Thu, 27 Jun 2019 14:58:39 +0200 (CEST)
Date:   Thu, 27 Jun 2019 14:58:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type
 flow offload
Message-ID: <20190627125839.t56fnptdeqixt7wd@salvia>
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
 <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
 <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
 <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
 <dce5cba2-766c-063e-745f-23b3dd83494b@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dce5cba2-766c-063e-745f-23b3dd83494b@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 02:22:36PM +0800, wenxu wrote:
> On 6/27/2019 3:19 AM, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
[...]
> >> Whats the idea with this patch?
> >>
> >> Do you see a performance improvement when bypassing bridge layer? If so,
> >> how much?
> >>
> >> I just wonder if its really cheaper than not using bridge conntrack in
> >> the first place :-)
> 
> This patch is based on the conntrack function in bridge.  It will
> bypass the fdb lookup and conntrack lookup to get the performance 
> improvement. The more important things for hardware offload in the
> future with nf_tables add hardware offload support

Florian would like to see numbers / benchmark.
