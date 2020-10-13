Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0528D715
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgJMXib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgJMXib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 19:38:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B77621D7B;
        Tue, 13 Oct 2020 23:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632310;
        bh=BF7HacO3Kpiv75Ox/CB6ioQoHyDgjCn8DfZvCIAS3vs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lTFxaywQTuPqgPVQuWOBeBG/7biRpnwfrXM8vO/Izvn0cq0GQrbdCf6XfJLRyLPlG
         qcKgqPB0nYKqq3Tf3NZCJmrsuSpmJxvas+1fQLnOLuVx+kZWx4u9P6kDxS+0qG6v7V
         Wj6CGqTQlRODRqxe/I9HJVvFNhkcCMMSB5kY258E=
Date:   Tue, 13 Oct 2020 16:38:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: net: sctp: Fix negotiation of the number of data streams -
 backport request
Message-ID: <20201013163828.37fd4feb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c5b2080a713e4bb9be1a7def413561de@AcuMS.aculab.com>
References: <c5b2080a713e4bb9be1a7def413561de@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 10:32:13 +0000 David Laight wrote:
> This commit needs backporting to 5.1 through 5.8.
> Do you need me to find the patch email or is this
> with the full commit id enough?

I'll queue it up, thanks!
