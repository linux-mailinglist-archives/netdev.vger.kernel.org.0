Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7AC576AB3
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiGOX3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiGOX3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:29:17 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6420814020;
        Fri, 15 Jul 2022 16:29:16 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id ED7F9C01E; Sat, 16 Jul 2022 01:29:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657927753; bh=LRh8CqlPIRkzfgBybrqwK+yCpZ0l+gQTLXIpKVRcThc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLmDGkkDWDJnchH2Rg43JNu3FuIeKGtO1NGvEkSVcEqrlEmvMzCNNR3NZiiSiHF8t
         02U4B4S4hs/09u8bZAFCdJcdpK80mXxjuYzMTHlRNd8ehKC0ncq2l7txa2mXSipOHA
         vKRDBoS7QJXqDD548of3KipgdV0hCTtMwLqXz8pFIOQLSBMzzQrRBlQaShPZxDMFd2
         O2RP5uRo4eyS8wBfu8VErk927dDr8iysYknXvRxb5K0uec3sPOozv8eCkZBH0Nk36k
         H6igSTFRFDmow8PtfUnFmQOw+P9EpVa4WJvSWjrSbES/aIikaBExDaBjkxmrT6iFRO
         d3VirZ3wdV5tQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 277B7C009;
        Sat, 16 Jul 2022 01:29:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657927753; bh=LRh8CqlPIRkzfgBybrqwK+yCpZ0l+gQTLXIpKVRcThc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLmDGkkDWDJnchH2Rg43JNu3FuIeKGtO1NGvEkSVcEqrlEmvMzCNNR3NZiiSiHF8t
         02U4B4S4hs/09u8bZAFCdJcdpK80mXxjuYzMTHlRNd8ehKC0ncq2l7txa2mXSipOHA
         vKRDBoS7QJXqDD548of3KipgdV0hCTtMwLqXz8pFIOQLSBMzzQrRBlQaShPZxDMFd2
         O2RP5uRo4eyS8wBfu8VErk927dDr8iysYknXvRxb5K0uec3sPOozv8eCkZBH0Nk36k
         H6igSTFRFDmow8PtfUnFmQOw+P9EpVa4WJvSWjrSbES/aIikaBExDaBjkxmrT6iFRO
         d3VirZ3wdV5tQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b97f1b49;
        Fri, 15 Jul 2022 23:29:06 +0000 (UTC)
Date:   Sat, 16 Jul 2022 08:28:51 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v6 00/11] remove msize limit in virtio transport
Message-ID: <YtH4M9GvVdAsSCz2@codewreck.org>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
 <YtHqlVx9/joj+AXH@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtHqlVx9/joj+AXH@codewreck.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dominique Martinet wrote on Sat, Jul 16, 2022 at 07:30:45AM +0900:
> Christian Schoenebeck wrote on Fri, Jul 15, 2022 at 11:35:26PM +0200:
> > * Patches 7..11 tremendously reduce unnecessarily huge 9p message sizes and
> >   therefore provide performance gain as well. So far, almost all 9p messages
> >   simply allocated message buffers exactly msize large, even for messages
> >   that actually just needed few bytes. So these patches make sense by
> >   themselves, independent of this overall series, however for this series
> >   even more, because the larger msize, the more this issue would have hurt
> >   otherwise.
> 
> Unless they got stuck somewhere the mails are missing patches 10 and 11,
> one too many 0s to git send-email ?

nevermind, they just got in after 1h30... I thought it'd been 1h since
the first mails because the first ones were already 50 mins late and I
hadn't noticed! I wonder where they're stuck, that's the time
lizzy.crudebyte.com received them and it filters earlier headers so
probably between you and it?

ohwell.

> I'll do a quick review from github commit meanwhile

Looks good to me, I'll try to get some tcp/rdma testing done this
weekend and stash them up to next

--
Dominique
