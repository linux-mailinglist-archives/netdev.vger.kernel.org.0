Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEEA366A77
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhDUMJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235392AbhDUMJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 08:09:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDF7B613E0;
        Wed, 21 Apr 2021 12:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619006937;
        bh=NqFDGkhYlRMiJHTALUJ/CZF7PfCzmd7eTSEsM8iXJTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KuKVg4HLbA2Nf+78ZDgbo2U08h31kzp56CNuphfVNhnWthd+ayYdQu3qXGOOtoXrJ
         T7QRTxtNRnb9TL0Th+9Bu5woNqOn6dx7CXuuYmYEC4NEcXCyOAkt/LcUDB42guSxY1
         ES8LETtsfqvX6i8OFZhCHr1fUe5JOcRee6xA/a2M=
Date:   Wed, 21 Apr 2021 14:08:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Shelat, Abhi" <a.shelat@northeastern.edu>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <YIAV1hqp3rkBxVWA@kroah.com>
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

Thank you for saying this, I appreciate it.

greg k-h
