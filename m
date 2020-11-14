Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917AD2B306C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKNT63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgKNT63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 14:58:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF4FB222EA;
        Sat, 14 Nov 2020 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605383909;
        bh=z2ayyOPTYWocGmZcybfMNuFvz496GyNgaozDgMl4lUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0t8ful2fegVHAgWtvLJvC7V/fyrHTC39rFIIb31lgQP763aXieNnQjnJLH1lAoI02
         pODYDXfUUJWTA11O/4r+/313aRapa3ELJZR0TWZxuHV41GBqYYLn4tW/ov8T558iL6
         JabcMiL8inXKFkQ+Qdr+pdTot9JS1h1Vh4DMwwHs=
Date:   Sat, 14 Nov 2020 11:58:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem@davemloft.net,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv2 net] sctp: change to hold/put transport for
 proto_unreach_timer
Message-ID: <20201114115828.6000db41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114134023.GC3556@localhost.localdomain>
References: <102788809b554958b13b95d33440f5448113b8d6.1605331373.git.lucien.xin@gmail.com>
        <20201114134023.GC3556@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 10:40:23 -0300 Marcelo Ricardo Leitner wrote:
> On Sat, Nov 14, 2020 at 01:22:53PM +0800, Xin Long wrote:
> > A call trace was found in Hangbin's Codenomicon testing with debug kernel:
> >   
> ...
> > 
> > So fix it by holding/putting transport instead for proto_unreach_timer
> > in transport, just like other timers in transport.
> > 
> > v1->v2:
> >   - Also use sctp_transport_put() for the "out_unlock:" path in
> >     sctp_generate_proto_unreach_event(), as Marcelo noticed.
> > 
> > Fixes: 50b5d6ad6382 ("sctp: Fix a race between ICMP protocol unreachable and connect()")
> > Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>  
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thanks!
