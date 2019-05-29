Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474E32DEF9
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfE2N5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:57:10 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47562 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbfE2N5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 09:57:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hVz4l-0005Lc-JA; Wed, 29 May 2019 15:57:07 +0200
Date:   Wed, 29 May 2019 15:57:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 3/7] afs: switch to in_dev_for_each_ifa_rcu
Message-ID: <20190529135707.thwqw5ibitmwsnom@breakpoint.cc>
References: <20190529114332.19163-4-fw@strlen.de>
 <20190529114332.19163-1-fw@strlen.de>
 <20802.1559137779@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20802.1559137779@warthog.procyon.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> Actually, whilst thanks are due for doing the work - it looks nicer now - I'm
> told that there's not really any point populating the list.  Current OpenAFS
> ignores it, as does AuriStor - and IBM AFS 3.6 will do the right thing.

[..]

> On that basis, feel free to make it an empty list and remove all the interface
> enumeration.

Ok, will wait for others to comment before doing this in v2.
