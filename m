Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860E2368752
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbhDVTk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhDVTk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:40:27 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDCDC06174A;
        Thu, 22 Apr 2021 12:39:52 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 98BEC728D; Thu, 22 Apr 2021 15:39:50 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 98BEC728D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1619120390;
        bh=P1XokK26ajbrSJ6gTQG9u1z+r82OYj/giI7YYlt4FfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cWlu+nVLokNWr/vD1z1A4zQdGvLXDPGlwRgcvv+QiQ/2FL9Y9D0Yo6wkpjAy20aei
         spx5BIEgLX77PzswywChYKsUQDgwwmTf4rncvZV+TcJQZmpHCa8ufctFgHPXCR+FRC
         cgP8won5uqFHVE78mFBvfu8n/hmb01XPuXIi3980=
Date:   Thu, 22 Apr 2021 15:39:50 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Shelat, Abhi" <a.shelat@northeastern.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
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
Message-ID: <20210422193950.GA25415@fieldses.org>
References: <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421135637.GB27929@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:56:37AM -0400, J. Bruce Fields wrote:
> On Wed, Apr 21, 2021 at 04:49:31PM +0300, Leon Romanovsky wrote:
> > If you want to see another accepted patch that is already part of
> > stable@, you are invited to take a look on this patch that has "built-in bug":
> > 8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")
> 
> Interesting, thanks.

Though looking at it now, I'm not actually seeing the bug--probably I'm
overlooking something obvious.

--b.
