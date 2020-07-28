Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63D0231206
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbgG1Sx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgG1Sx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:53:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D98CA207F5;
        Tue, 28 Jul 2020 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595962407;
        bh=cUDUgGMVbwPe3rczLGLEAals3Gs33jK248qpq3KJh8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a6Vpr23PALx/qqgcmjrz35hiVMfvRhOvOzhGXSywxxCja5dILuc4oolErsriVlO1y
         I39C9dGijspsOtmUDQ3iQ4VEWAQnDZUq2ic/JO3bBrI2a7EySlqM1yJMIsEFTFPd1d
         qAMY7zJqCfEz96Ccokxer3fozajKDGF5LFbvRTSg=
Date:   Tue, 28 Jul 2020 11:53:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jan Engelhardt <jengelh@inai.de>,
        Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Message-ID: <20200728115325.353c3028@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728155140.GA17714@lst.de>
References: <20200728063643.396100-1-hch@lst.de>
        <20200728063643.396100-5-hch@lst.de>
        <20200728084746.06f52878@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200728155140.GA17714@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 17:51:40 +0200 Christoph Hellwig wrote:
> On Tue, Jul 28, 2020 at 08:47:46AM -0700, Jakub Kicinski wrote:
> > Appears to cause these two new warnings, sadly:
> > 
> > net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression
> > net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression  
> 
> Shouldn't this just be one?  That one is justified, though as *optlen
> should be len.

Could be, seems like sparse duplicates some warnings in my build system,
not sure why :S
