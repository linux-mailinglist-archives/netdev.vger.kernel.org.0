Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67D52B4F1A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbgKPSVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbgKPSVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 13:21:09 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435D3222EC;
        Mon, 16 Nov 2020 18:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605550868;
        bh=YbDlZ1AVwxN0te7sA32IG9U9jyzPODAXadHjBoIrExE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DhKMjcJ/PzKmehKHb2T1T3fxKu4VnNIIWzGCryDYJ1ZqOalvyK4wKS84O23uj01Q0
         BMl/OMqq0xrrjh8o69mNBVxgwxdbBS4c2hoXoXzs0vOXwcEMllNqUW+D8se28fLeEW
         9x1mBrduxQecypCEZazgOVEejuErSG8Qw4hSXyas=
Date:   Mon, 16 Nov 2020 10:21:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [PATCH net-next] MAINTAINERS: Add Martin Schiller as a
 maintainer for the X.25 stack
Message-ID: <20201116102107.338f0a81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3a556cae7d869059fa3b30c921a91658@dev.tdt.de>
References: <20201114111029.326972-1-xie.he.0141@gmail.com>
        <3a556cae7d869059fa3b30c921a91658@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 10:01:20 +0100 Martin Schiller wrote:
> On 2020-11-14 12:10, Xie He wrote:
> > Martin Schiller is an active developer and reviewer for the X.25 code.
> > His company is providing products based on the Linux X.25 stack.
> > So he is a good candidate for maintainers of the X.25 code.
> > 
> > The original maintainer of the X.25 network layer (Andrew Hendry) has
> > not sent any email to the netdev mail list since 2013. So he is 
> > probably
> > inactive now.
> > 
> > Cc: Martin Schiller <ms@dev.tdt.de>
> > Cc: Andrew Hendry <andrew.hendry@gmail.com>
> > Signed-off-by: Xie He <xie.he.0141@gmail.com>
> 
> Acked-by: Martin Schiller <ms@dev.tdt.de>

Applied to net, thanks everyone!
