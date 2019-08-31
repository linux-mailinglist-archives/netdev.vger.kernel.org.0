Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7027AA4174
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 02:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfHaAwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 20:52:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbfHaAwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 20:52:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11525155075AD;
        Fri, 30 Aug 2019 17:52:42 -0700 (PDT)
Date:   Fri, 30 Aug 2019 17:52:41 -0700 (PDT)
Message-Id: <20190830.175241.133753202603242732.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830120704.6147-1-pablo@netfilter.org>
References: <20190830120704.6147-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 17:52:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 30 Aug 2019 14:06:59 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Spurious warning when loading rules using the physdev match,
>    from Todd Seidelmann.
> 
> 2) Fix FTP conntrack helper debugging output, from Thomas Jarosch.
> 
> 3) Restore per-netns nf_conntrack_{acct,helper,timeout} sysctl knobs,
>    from Florian Westphal.
> 
> 4) Clear skbuff timestamp from the flowtable datapath, also from Florian.
> 
> 5) Fix incorrect byteorder of NFT_META_BRI_IIFVPROTO, from wenxu.

Pulled, thanks.
