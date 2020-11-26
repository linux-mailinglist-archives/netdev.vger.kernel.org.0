Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E832C4C8E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgKZBUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbgKZBUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 20:20:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C759206C0;
        Thu, 26 Nov 2020 01:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606353651;
        bh=HVfb+vjvtP8sjwyANgn0PuGQJ4nghXCcbT8s6rkT0ho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YkAvw2QWF/ZWm9XSd6+6SatdW5/AbtnfMGs1c6+W0oCSp8xTmrzk0BlZ+0+AhQxq/
         brjVpUhzRmcaQy+9QIBLvXP1bGMyNH5UbEuZwFe68nexAg5HeEjef6bIbo105xy957
         Uh99FrWJhyPdYfq3wo4lL9o0CgrHBGG5EvDB7fmU=
Date:   Wed, 25 Nov 2020 17:20:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <ndagan@amazon.com>, <shayagr@amazon.com>, <sameehj@amazon.com>
Subject: Re: [PATCH V1 net-next 0/9] XDP Redirect implementation for ENA
 driver
Message-ID: <20201125172049.1a7f173e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
References: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 00:51:39 +0200 akiyano@amazon.com wrote:
> This series requires the patchset sent to 'net' to be applied cleanly. Decided
> to send this one up front to reduce the risk of not getting XDP Redirect in next
> version.

Netdev maintainers don't track dependencies between series.

Hopefully you'll can get some reviews but you'll need to repost next
week after net is merged into net-next.

Post this kind of stuff as an RFC next time around, please.
