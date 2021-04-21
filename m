Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B972366AA2
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhDUMUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhDUMUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 08:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ECA9613E0;
        Wed, 21 Apr 2021 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619007570;
        bh=L95QaJMrMeYMNbDPr8pjvWkKHVjgxGCPFXrCUXX8dN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsHvtM20kcZIl8G+2ULfzskF5Cf0Apte4j2pFt/1qPmEdARxGwRQ0+xxQzisTztU6
         vuOeewCx3DG6PpLlp26hDZhxxzqmssComUxw5JnUh1zlXi9y0AjJa+IYZfiDEuQdaS
         z6FkCMyvw/809ZxAOFBlLn1yXbmWdOebvvd1jTtafnSb86qjSwqZQyHIIHXtlUFUYf
         l9EKm9Y5yUNsgRERm0WA4ATtEFd1bQKheeGmjktFZ+ffiC/jaRlU+xfA7jm8EGHVus
         T9aAZ2kZjVSDJ2mjgVVMpG1rZFuCSmQZfW+R7wgDpl5vaTlX17ItvdsZEZ05XZwUtO
         F3fTOc7K2xlqA==
Date:   Wed, 21 Apr 2021 15:19:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Shelat, Abhi" <a.shelat@northeastern.edu>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIAYThdIoAPu2h7b@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:58:08AM +0000, Shelat, Abhi wrote:
> >> 
> >>>> They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> >>>> accepted patches from Aditya and 3 of them added various severity security
> >>>> "holes".
> >>> 
> >>> All contributions by this group of people need to be reverted, if they
> >>> have not been done so already, as what they are doing is intentional
> >>> malicious behavior and is not acceptable and totally unethical.  I'll
> >>> look at it after lunch unless someone else wants to do it…
> >> 
> 
> <snip>
> 
> Academic research should NOT waste the time of a community.
> 
> If you believe this behavior deserves an escalation, you can contact the Institutional Review Board (irb@umn.edu) at UMN to investigate whether this behavior was harmful; in particular, whether the research activity had an appropriate IRB review, and what safeguards prevent repeats in other communities.

The huge advantage of being "community" is that we don't need to do all
the above and waste our time to fill some bureaucratic forms with unclear
timelines and results.

Our solution to ignore all @umn.edu contributions is much more reliable
to us who are suffering from these researchers.

Thanks
