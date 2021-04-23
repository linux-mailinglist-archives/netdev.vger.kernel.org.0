Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CA8369842
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhDWR0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhDWR0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 13:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4518E613DB;
        Fri, 23 Apr 2021 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619198732;
        bh=LeAKX/LclhdGdHtcpyE/Md+aiOKHU5kb4bGOf042jz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EOFnLe17l0EZrn7XhXD6jPMGlZTpthuz6avPiae9JZveQPygjRsgrLUK6gw1iHMAA
         pfFLNpiONAEsw9aVERQC7c8Lv4kvNXc8hTdvzwQ6rWsvMLrIcQ3PsW1ypbhL6Tx35H
         dwUGMkd4+iXINtoBBlhaWyjlWjU1apuMJArXO8t7qCpc1u9PoHhrgb+d5aKQ6uUSiR
         abDWwsAWTNWqKNL7C+QOmp52BjDFnYeViKoB+MfFJpPd8St2vNNOTEvGJwB50FuZN5
         bJSVcGr+utRaY6ps1RqgtNBYH+JhVmkwzCvlPT9vEjGivriG0RWRI6omeQOvWmBNDb
         6mjngWOS7ID6A==
Date:   Fri, 23 Apr 2021 20:25:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>
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
Message-ID: <YIMDCNx4q6esHTYt@unreal>
References: <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
 <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
 <20210421133727.GA27929@fieldses.org>
 <YIAta3cRl8mk/RkH@unreal>
 <20210421135637.GB27929@fieldses.org>
 <20210422193950.GA25415@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422193950.GA25415@fieldses.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:39:50PM -0400, J. Bruce Fields wrote:
> On Wed, Apr 21, 2021 at 09:56:37AM -0400, J. Bruce Fields wrote:
> > On Wed, Apr 21, 2021 at 04:49:31PM +0300, Leon Romanovsky wrote:
> > > If you want to see another accepted patch that is already part of
> > > stable@, you are invited to take a look on this patch that has "built-in bug":
> > > 8e949363f017 ("net: mlx5: Add a missing check on idr_find, free buf")
> > 
> > Interesting, thanks.
> 
> Though looking at it now, I'm not actually seeing the bug--probably I'm
> overlooking something obvious.

It was fixed in commit 31634bf5dcc4 ("net/mlx5: FPGA, tls, hold rcu read lock a bit longer")

Thanks

> 
> --b.
