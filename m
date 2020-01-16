Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBAB13FA19
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgAPT7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:59:44 -0500
Received: from correo.us.es ([193.147.175.20]:58342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbgAPT7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:59:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 738FD807E8
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:59:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6523CDA71F
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:59:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5A705DA716; Thu, 16 Jan 2020 20:59:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E3A9DA709;
        Thu, 16 Jan 2020 20:59:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:59:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3F58F42EF9E0;
        Thu, 16 Jan 2020 20:59:40 +0100 (CET)
Date:   Thu, 16 Jan 2020 20:59:39 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH netfilter/iptables] Add new slavedev match extension
Message-ID: <20200116195939.5ordyhfwfspspafa@salvia>
References: <20191217135616.25751-1-martin@strongswan.org>
 <83ada82dbc93439d794c2407e3c91dd1b69bcbaa.camel@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83ada82dbc93439d794c2407e3c91dd1b69bcbaa.camel@strongswan.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marti,

On Fri, Jan 10, 2020 at 05:34:12PM +0100, Martin Willi wrote:
> Pablo,
> 
> > This patchset introduces a new Netfilter match extension to match
> > input interfaces that are associated to a layer 3 master device. The
> > first patch adds the new match to the kernel, the other provides an
> > extension to userspace iptables to make use of the new match.
> 
> These patches have been marked as superseded in patchworks, likely due
> to Florian's nftables version that has been merged.
> 
> While I very much appreciate the addition of VRF interface matching to
> nftables, some users still depend on plain iptables for filtering. So I
> guess there is some value in these patches for those users to extend
> their filtering with VRF support.

A single xt_slavedev module only for this is too much overhead, if you
find an existing extension (via revision infrastructure) where you can
make this fit in, I would consider this.

Thanks.
