Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136ED804B2
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfHCGfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 02:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfHCGfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 02:35:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B03732087C;
        Sat,  3 Aug 2019 06:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564814131;
        bh=ddEY9ZKdQQxW0ag1cV6aQ593D5nTUSXJmEET1SOsoA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNJwB+sesJxLY3pD/SHmcazF+dgZR4OvcTAH7/JIF2fz1F0V8UPi/l6vc/SqaqRqc
         LjW72JgoDXmE6XxM+6KTiBEHbd276x2t/6Z34Rm3HHjiTZSI5r3nz4LzigAJ+QW/9W
         vPbhjLTvNiK3jGcbJzfqQgQKcOKRnH4dBr0EJlgs=
Date:   Sat, 3 Aug 2019 08:35:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fernando Eckhardt Valle <phervalle@gmail.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:isdn:hysdn brace same line if
Message-ID: <20190803063528.GC10186@kroah.com>
References: <20190802195105.27788-1-phervalle@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802195105.27788-1-phervalle@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 07:51:05PM +0000, Fernando Eckhardt Valle wrote:
> Fix checkpatch error "ERROR: that open brace { should be on the previous
> line" in drivers/staging/isdn/hysdn/hycapi.c:51.
> 
> Signed-off-by: Fernando Eckhardt Valle <phervalle@gmail.com>
> ---
>  drivers/staging/isdn/hysdn/hycapi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Your subject line does not make sense :(

