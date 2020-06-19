Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48EE200646
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 12:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbgFSK2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 06:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732384AbgFSK2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 06:28:16 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A633C0613EE;
        Fri, 19 Jun 2020 03:28:16 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 66EA058743C1C; Fri, 19 Jun 2020 12:28:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 63D8460D220A6;
        Fri, 19 Jun 2020 12:28:08 +0200 (CEST)
Date:   Fri, 19 Jun 2020 12:28:08 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Christoph Hellwig <hch@infradead.org>
cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
In-Reply-To: <20200619074631.GA1427@infradead.org>
Message-ID: <nycvar.YFH.7.77.849.2006191217280.9730@n3.vanv.qr>
References: <20200618210645.GB2212102@localhost.localdomain> <20200619074631.GA1427@infradead.org>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 2020-06-19 09:46, Christoph Hellwig wrote:

>On Fri, Jun 19, 2020 at 12:06:45AM +0300, Alexey Dobriyan wrote:
>> Rename
>> 	struct notifier_block *this
>> to
>> 	struct notifier_block *nb
>> 
>> "nb" is arguably a better name for notifier block.
>
>But not enough better to cause tons of pointless churn.  Feel free
>to use better naming in new code you write or do significant changes
>to, but stop these pointless renames.

Well, judging from the mention of "linux++" in the subject, I figure 
this is the old discussion of someone trying to make Linux code, or 
parts thereof, work in a C++ environment. Since the patch does not just 
touch headers but .c files, I deduce that there seems to be a project 
trying to build Linux, or a subset thereof, as a C++ program for the fun 
of it. UML could come to mind.

Is it a hot potato? Definitely. But so was IPv6 NAT, and now we have it 
anyway.
