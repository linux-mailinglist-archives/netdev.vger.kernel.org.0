Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790DA77954
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 16:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfG0Ov5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 10:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfG0Ov5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 10:51:57 -0400
Received: from localhost (unknown [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68CC2086D;
        Sat, 27 Jul 2019 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564239116;
        bh=ZPA8Z65Vkjg1wkDtwbQLZ9CaUN/mSm2ylo/QrCGe2Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fE2qUCsVaDtspxuYMP1so1owpbJYPeCx935F8ce/9gICqFH8OcMEBSZmwXdKmJg/h
         UE5HthrrVrbp7F/P7BgoiZpYaTekzp/24zjTsVs1NYoom3Zwwh4uuycuNLEyMG1nj+
         R4mgxXsFaEoU4UnNVuFUNxX9RDe5iwdJb6BZstX0=
Date:   Sat, 27 Jul 2019 16:51:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, aaro.koskinen@iki.fi,
        arnd@arndb.de
Subject: Re: [PATCH 2/2] staging/octeon: Allow test build on !MIPS
Message-ID: <20190727145145.GA21910@kroah.com>
References: <20190726174425.6845-1-willy@infradead.org>
 <20190726174425.6845-3-willy@infradead.org>
 <20190727105706.GB458@kroah.com>
 <20190727142826.GA12889@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190727142826.GA12889@bombadil.infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 07:28:26AM -0700, Matthew Wilcox wrote:
> On Sat, Jul 27, 2019 at 12:57:06PM +0200, Greg KH wrote:
> > No real objection from me, having this driver able to be built on
> > non-mips systems would be great.
> > 
> > But wow, that stubs.h file is huge, you really need all of that?
> > There's no way to include the files from the mips "core" directly
> > instead for some of it?
> 
> I don't know.  I went the route of copying each structure/enum wholesale
> as I came across it in the build log rather than taking only the pieces
> of it that I needed.  My time versus a few hundred lines of source?
> 
> I think that a more wholesale restructuring of this driver would be
> helpful; there are a number of structures that are only used in the
> driver and not in the arch code, and those could then be removed from
> the stubs file.  But I have no long term investment in this driver;
> it just annoyed me to not be able to build it.

Ok, again, no objection from me, thanks for doing this work.

greg k-h
