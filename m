Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C9C3E1CDB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbhHETis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237315AbhHETip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 15:38:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8652561102;
        Thu,  5 Aug 2021 19:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628192310;
        bh=/6LWnXW6m9roLRtF3lgoRi7tfJOpEuhkjmWxlGm2QjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MqurThVoECmbFsY/9qsn1xO8gvIK0aazTrRtUADbBBefWV42lZLL+6WZhNYrc1xMZ
         Eo2nWKcwaMfxqaumO4kokdm+WXJEOQVzYuQ/grtcloz4m2Xw6ayyDBfbACnrEPwBUd
         IfvpWXJT972doof2vw7yaHFyyzHhjiM/WKdzKS/Tt0aG4sMJT77X8lybWroaMORglf
         d58VjWfLSB1Z3j1RDrVvMSzk37UvwoxGNoml5hJ7O70pJCs+RPc2A3rqo+mDCG3oLK
         ZwrMhBmeb3/KmHHmIm5W8PjtfZVafK7w6X5lLu/MUOjPDwQ17kxFLShZyNM0o3l1Tr
         KzWZLueLNenoA==
Date:   Thu, 5 Aug 2021 12:38:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Networking for 5.14-rc5
Message-ID: <20210805123829.1f3a276f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <afa0b41f-bcb9-455e-4ea8-476ed880fbd2@infradead.org>
References: <20210805154335.1070064-1-kuba@kernel.org>
        <CAHk-=wi8ufjAUS=+gPxpDPx_tupvfPppLX03RxjWeJ1JtuDZYg@mail.gmail.com>
        <afa0b41f-bcb9-455e-4ea8-476ed880fbd2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 12:34:17 -0700 Randy Dunlap wrote:
> On 8/5/21 12:30 PM, Linus Torvalds wrote:
> > On Thu, Aug 5, 2021 at 8:43 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> >>
> >> Small PR this week, maybe it's cucumber time, maybe just bad
> >> timing vs subtree PRs, maybe both.  
> > 
> > "Cucumber time"?
> > 
> > Google informs me about this concept, but I'd never heard that term before.  
> 
> wow, nor had I.
> Thanks for the info. :)

Oops, I thought it was pan-European term, guess not.

For the record I meant peak vacation time when not much 
is happening because beach beats work.
