Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364EA2029B4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgFUIpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:45:35 -0400
Received: from nautica.notk.org ([91.121.71.147]:60585 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729509AbgFUIpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:45:34 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 0BA2CC01A; Sun, 21 Jun 2020 10:45:28 +0200 (CEST)
Date:   Sun, 21 Jun 2020 10:45:13 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Validate current->sighand in client.c
Message-ID: <20200621084512.GA720@nautica>
References: <20200618190807.GA20699@nautica>
 <20200620201456.14304-1-alexander.kapshuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200620201456.14304-1-alexander.kapshuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kapshuk wrote on Sat, Jun 20, 2020:
> Use (un)lock_task_sighand instead of spin_lock_irqsave and
> spin_unlock_irqrestore to ensure current->sighand is a valid pointer as
> suggested in the email referenced below.

Thanks for v2! Patch itself looks good to me.

I always add another `Link:` tag to the last version of the patch at the
time of applying, so the message might be a bit confusing.
Feel free to keep the link to the previous discussion but I'd rather
just repeat a bit more of what we discussed (e.g. fix rcu not being
dereferenced cleanly by using the task helpers as suggested) rather than
just link to the thread

Sorry for nitpicking but I think commit messages are important and it's
better if they're understandable out of context, even if you give a link
for further details for curious readers, it helps being able to just
skim through git log.


Either way I'll include the patch in my test run today or tomorrow, had
promised it for a while...

Cheers,
-- 
Dominique
