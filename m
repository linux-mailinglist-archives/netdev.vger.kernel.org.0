Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6FF6AF3D
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbfGPSwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:52:25 -0400
Received: from mail.us.es ([193.147.175.20]:35570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388374AbfGPSwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 14:52:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3123EBEBA9
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 20:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2083D115107
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 20:52:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15EC61150CC; Tue, 16 Jul 2019 20:52:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A77ABDA708;
        Tue, 16 Jul 2019 20:52:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 20:52:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 81A764265A2F;
        Tue, 16 Jul 2019 20:52:20 +0200 (CEST)
Date:   Tue, 16 Jul 2019 20:52:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kadlec@netfilter.org, fw@strlen.de, bfields@fieldses.org,
        chuck.lever@oracle.com
Subject: Re: [PATCH 2/2] net: apply proc_net_mkdir() harder
Message-ID: <20190716185220.hnlyiievuucdtn7x@salvia>
References: <20190706165521.GB10550@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706165521.GB10550@avx2>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 07:55:21PM +0300, Alexey Dobriyan wrote:
> From: "Hallsmark, Per" <Per.Hallsmark@windriver.com>
> 
> proc_net_mkdir() should be used to create stuff under /proc/net,
> so that dentry revalidation kicks in.
> 
> See
> 
> 	commit 1fde6f21d90f8ba5da3cb9c54ca991ed72696c43
> 	proc: fix /proc/net/* after setns(2)
> 
> 	[added more chunks --adobriyan]

I don't find this in the tree, if you split the netfilter part in an
independent patch, I could take it into the netfilter tree.

Or just keep it like this and ask David to take it.
