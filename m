Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6800B25EB83
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgIEWjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgIEWjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 18:39:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AEF20760;
        Sat,  5 Sep 2020 22:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599345589;
        bh=f6cbYvahZACM+UIERpV9/pi9+ksuaaosjiPpJmKVvkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c7UyNXbz2aiuraVcH3neT6lhRhv7R9M+Y21aCq49ZGx+KnFVn34hP+QG0EjNw4NcI
         olLtF1+88UDwiSyO/auoNe2QJXImfjEeGHNV4QoIfq6B5Q9+Bufcg57CPEjHK05mm6
         Oqc6S2qRqs+jbQtKs5+636vjugzN+F8GDnrY57BI=
Date:   Sat, 5 Sep 2020 15:39:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes
 a socket
Message-ID: <20200905153947.66f28395@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 16:05:48 -0600 Jens Axboe wrote:
> No functional changes in this patch, needed to provide io_uring support
> for shutdown(2).
> 
> Cc: netdev@vger.kernel.org
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> There's a trivial io_uring patch that depends on this one. If this one
> is acceptable to you, I'd like to queue it up in the io_uring branch for
> 5.10.

Go for it.

Acked-by: Jakub Kicinski <kuba@kernel.org>
