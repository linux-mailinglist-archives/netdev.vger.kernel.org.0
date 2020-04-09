Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE441A3B35
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgDIUSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgDIUSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 16:18:20 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD8220757;
        Thu,  9 Apr 2020 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586463500;
        bh=70hc4273hiK15yHAKjn5vVdCiHqt5lUWqhFI11qhA+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DRGfcSfQVjj7r8bMrx6BZYVxucEW6EVMcwWE3gcbOxZVnzxEtDpBhkIwb7i/jPRXZ
         n2oF8saQtW8R5LMrXMQdoRMHDGJvoimYzilLkg9qJN5gMOgvVEpm3QFojc457mrUKv
         EqSnaV8umMY2IOOuh/1SENs0L/ERzZWOalsXT+1w=
Date:   Thu, 9 Apr 2020 13:18:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
Subject: Re: [PATCH net] docs: networking: add full DIM API
Message-ID: <20200409131818.7f4fa0bf@kicinski-fedora-PC1C0HJN>
In-Reply-To: <0a2f9a52-6abb-b9ca-45c1-cc74f6d276d7@infradead.org>
References: <20200409175704.305241-1-kuba@kernel.org>
        <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
        <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
        <20200409124221.128d6327@kicinski-fedora-PC1C0HJN>
        <0a2f9a52-6abb-b9ca-45c1-cc74f6d276d7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 13:06:50 -0700 Randy Dunlap wrote:
> On 4/9/20 12:42 PM, Jakub Kicinski wrote:
> > On Thu, 9 Apr 2020 12:27:17 -0700 Randy Dunlap wrote:  
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Add the full net DIM API to the net_dim.rst file.
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> Cc: davem@davemloft.net
> >> Cc: Jakub Kicinski <kuba@kernel.org>
> >> Cc: netdev@vger.kernel.org, talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com  
> > 
> > Ah, very nice, I didn't know how to do that!
> > 
> > Do you reckon we should drop the .. c:function and .. c:type marking I
> > added? So that the mentions of net_dim and the structures point to the
> > kdoc?  
> 
> My understanding is that if functions have an ending (), then the c:function
> is not needed/wanted.  I don't know about the c:type uses.
> 
> But there is some duplication that might be cleaned up some.

I think you're thinking about :c:func:, I was talking about ..
c:function which basically renders very similar entries to kdoc.

If you have the doc rendered check out what
networking/net_dim.html#c.dim takes us to right now.
