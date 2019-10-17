Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1568DDA876
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405474AbfJQJhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:37:52 -0400
Received: from correo.us.es ([193.147.175.20]:58184 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbfJQJhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 05:37:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B41FA0AEED
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:37:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23532DA4D0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:37:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1909EDA4CA; Thu, 17 Oct 2019 11:37:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4048B7FFB;
        Thu, 17 Oct 2019 11:37:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 11:37:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 647474251481;
        Thu, 17 Oct 2019 11:37:44 +0200 (CEST)
Date:   Thu, 17 Oct 2019 11:37:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH 0/6] [GIT PULL ipvs-next] IPVS updates for v5.5
Message-ID: <20191017093744.3dmcwnicf5r76yir@salvia>
References: <20191015073212.19394-1-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 09:32:06AM +0200, Simon Horman wrote:
> Hi Pablo,
> 
> Please consider these IPVS updates for v5.5.
> 
> As there are a few more changes than usual I'm sending a pull request
> rather than asking you to apply the patches directly.
> 
> This pull request is based on nf-next.
> 
> The following changes since commit f8615bf8a3dabd84bf844c6f888929495039d389:
> 
>   netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c. (2019-10-07 23:59:02 +0200)
> 
> are available in the git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git tags/ipvs-next-for-v5.5

Pulled, thanks.
