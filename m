Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13906365E3C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhDTRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhDTRKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 13:10:41 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176F9C06174A;
        Tue, 20 Apr 2021 10:10:10 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 071357274; Tue, 20 Apr 2021 13:10:09 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 071357274
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1618938609;
        bh=G1/bkGfCnN9BPCT+BTU7MH0Yx34TK2JeYk5pORVadAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KXISL/jW2QvgORlWjBxAsoDlR0c7cjzlxQQCTF8hnO7vcZli+avWDUiFkhADSppri
         yZn0yt6Q2pubbQ5DcOS71LH6AzDXbvA1WS/bK2rkwQZTHsS36e/8mipekMJVC1EutB
         DXqZZk5ui9yYhopMKJ4eyomdzY7QRdECGcu+DJuU=
Date:   Tue, 20 Apr 2021 13:10:08 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <20210420171008.GB4017@fieldses.org>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH5/i7OvsjSmqADv@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> If you look at the code, this is impossible to have happen.
> 
> Please stop submitting known-invalid patches.  Your professor is playing
> around with the review process in order to achieve a paper in some
> strange and bizarre way.
> 
> This is not ok, it is wasting our time, and we will have to report this,
> AGAIN, to your university...

What's the story here?

--b.
