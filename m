Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB06A56932D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiGFUUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiGFUUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B4B1E3DC
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 13:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F6CC620B1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0582BC341C0;
        Wed,  6 Jul 2022 20:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657138829;
        bh=c6QiCdISE1NdcEkQHwXP8KeavXttI26LFixoqrYBkjU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dI5KXpdeYJb6gfK34XFqR1IH5ZWg8Gtbn5y2GspkMQljnxhyFvaN8GrqmX+aVZHNs
         2zBGACXDNnebbTdBIhB1ONPbrlGHXo+B+GI85EW0I1T1OCu3l/bCbw6+9MqWfbWkqg
         YpgJXYnNlL29qNJ1+vbX8cOAL5+ia0iPj6RPeFPbjxMJ+jT4Ohl6smPFdCvyidKAdu
         Xbr755aBaQpZfLa6D4b6E19c4ezPvnUShv1QE5n6k7nXD7FET6KQa3PFb3Wmtj1C/U
         vXmcPIG3BVtK55n1Dd78jU2EwBexLn0IJKk13/Gw9fndiRNcFLrtrFyhJ3d5GQE7MY
         7ayhNnXPVEfhg==
Date:   Wed, 6 Jul 2022 13:20:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net 0/7] mptcp: Path manager fixes for 5.19
Message-ID: <20220706132028.32028102@kernel.org>
In-Reply-To: <a61724-7676-bf55-491a-9ea8599ca5a7@linux.intel.com>
References: <20220705213217.146898-1-mathew.j.martineau@linux.intel.com>
        <20220705180024.4196a2bf@kernel.org>
        <a61724-7676-bf55-491a-9ea8599ca5a7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 10:14:21 -0700 (PDT) Mat Martineau wrote:
> > Is it possible to CC folks who authored patches under Fixes?
> > Sorry if I already asked about this. I'm trying to work on refining
> > the CC check in patchwork but I'm a little ambivalent about adding
> > this one to exceptions.  
> 
> Yes, I do try to do that. Note that Geliang changed his email address, so 
> the check script flags his old address though he is cc'd. This is the 
> recurring source of most of those red 'fail' blobs in patchwork for MPTCP 
> series.
> 
> Does your script use the .mailmap file from the kernel repo? Maybe I can 
> ask Geliang about adding an entry there.

That my next TODO item. I'm planning to include a local alias map as
well because I have a suspicion that chasing people to update .mailmap
will be a hassle.

> (I did also forget to add my coworker Kishen to part of the series this 
> time, sorry about that)
