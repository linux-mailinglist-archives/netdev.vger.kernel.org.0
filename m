Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9484D4A8C87
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbiBCTfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:35:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33142 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiBCTfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:35:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E6F461987;
        Thu,  3 Feb 2022 19:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFA3C340E8;
        Thu,  3 Feb 2022 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643916923;
        bh=ZeuQKl5CF+yJ40tipxsIt+kon36RXcg2heB8YowKaVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sqOwn9TN+nhH6PUcHrtyH2AP/oOV+C5oocttRBCzb5xxEpqE/ojB1dAsRdnRiML4S
         tUj9PNAmEqeF3qYVIJEP+GrftJTOH4kj+kLLjHyxj9ksyvG22NzweXkS8/6Vp5HgzU
         WmvLgkBuwOpVWrmrVTzgSJJQnB8LZX6kRcL80qjGhse7iwMLFaBX0k+ZvP3OBqhZjV
         wN0JmV7Kpybms2eQfuXMGJtM4Ex+Ml622hqN2zBKGKVEDDeO+kLA+RtcK/f1D0Z5Ms
         WCl/MohHJ0RoXWnu3MYKE85VS5QsdeeTD1Y0OnFlQjjkcmb6TxEvvB3G8CA5P/Ezmt
         wwdhPSR23ogyg==
Date:   Thu, 3 Feb 2022 11:35:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v6 net-next] net-core: add InMacErrors counter
Message-ID: <20220203113522.25ee482e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMzD94SNEPACnp+uniXVgRDWr9oukj-xnAoqyQQCE77GH_kqdg@mail.gmail.com>
References: <20220201222845.3640041-1-jeffreyji@google.com>
        <20220202205916.58f4a592@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMzD94SNEPACnp+uniXVgRDWr9oukj-xnAoqyQQCE77GH_kqdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 10:05:17 -0800 Brian Vazquez wrote:
> > If everyone disagrees - should we at least rename the MIB counter
> > similarly to the drop reason? Experience shows that users call for
> > help when they see counters with Error in their name, I'd vote for
> > IpExtInDropOtherhost or some such. The statistic should also be
> > documented in Documentation/networking/snmp_counter.rst  
> 
> Changing the Name to IpExtInDropOtherhost and adding the documentation
> makes sense to me. What do others think? I'd like to get more feedback
> before Jeffrey sends another version.

I'm not sure we reached the "everyone disagrees with me" point at least
not yet ;)
