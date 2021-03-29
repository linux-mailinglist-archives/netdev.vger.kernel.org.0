Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E3A34C3CE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 08:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhC2GbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 02:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC2Ga3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 02:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8626191D;
        Mon, 29 Mar 2021 06:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616999429;
        bh=WFeImc+Hc2CjMwAXZaDfRTmVrbNmPHK9h8a25QveI/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gS8+jn56XzVFatdlpSHthGpkqpoK/w2aqeyHzbn6vfxoCVGhT8RI7dgV5yC/arJXy
         rVCxUjJK3q3N6DQ9CnZRHwTLY0COVBwi4Rdq2D7lJUYEOLJzKtOAHRZzWKJPLwrXF5
         AA6b3p4YyKz3xni8oVUEQMIslDtwaSE1ybzKFiaAgFrgK9Hy406mouTmwT4y3xJ4bs
         jHZOiRUL4nJQvo4rqqASVcIe/COsMuEciOnB6ElDYfXEXVuta1HmZzz7KxxcecgOLm
         c597sRLjJHKc8u+fdAhQJdlixkgAdhLBCQUvzvzzZw1Eiczye5oVpvL1imPUc+v83j
         zTitqy48om+uQ==
Date:   Mon, 29 Mar 2021 09:30:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <YGF0AfLmdAr1q1+i@unreal>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <YGFi0uIfavNsXhfs@unreal>
 <YGFl4IcdLfbsyO51@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGFl4IcdLfbsyO51@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 07:30:08AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Mar 29, 2021 at 08:17:06AM +0300, Leon Romanovsky wrote:
> > On Sun, Mar 28, 2021 at 02:26:21PM +0200, Greg Kroah-Hartman wrote:
> > > There does not seem to be any developers willing to maintain the
> > > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > > from the kernel tree entirely in a few kernel releases if no one steps
> > > up to maintain it.
> > > 
> > > Reported-by: Matthew Wilcox <willy@infradead.org>
> > > Cc: Du Cheng <ducheng2@gmail.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > 
> > Greg,
> > 
> > Why don't you simply delete it like other code that is not maintained?
> 
> "normally" we have been giving code a chance by having it live in
> drivers/staging/ for a bit before removing it to allow anyone that
> actually cares about the codebase to notice it before removing it.

I don't know about netdev view on this, but for the RDMA code, the code
in staging means _not_exist_. We took this decision after/during Lustre
fiasco. 

Thanks
