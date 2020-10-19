Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4215292D38
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgJSR4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgJSR4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 13:56:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D972224D;
        Mon, 19 Oct 2020 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603130214;
        bh=7DyuFJJf/fzRqBqUb+5ZAyY//4MhrTpAhD0RYthFIsQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vGtCDPUl+KdXDAMDiEU9fiuwXaXy1sjv0SDA92b2eRuM7gIAEdrlM1xoq/6SMppUy
         7rSS2gSrWwjPcbDyvp6QfupX6k0P/gZvHA1T6GDqghGMp90zxurssL7u9X0426yskN
         EJGxCe0mVY40X94vGUrbqTfzBk9m3+LG0cqQFFE0=
Date:   Mon, 19 Oct 2020 10:56:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
Message-ID: <20201019105652.7367ae01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019114157.4347-1-schalla@marvell.com>
References: <20201019114157.4347-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 17:11:45 +0530 Srujana Challa wrote:
> This series introduces crypto(CPT) drivers(PF & VF) for Marvell OcteonTX2
> CN96XX Soc.

e have already sent a pull request for 5.10 and therefore net-next 
is closed for new drivers, features, and code refactoring.

Please repost when net-next reopens after 5.10-rc1 is cut.

(http://vger.kernel.org/~davem/net-next.html will not be up to date 
 this time around, sorry about that).

RFC patches sent for review only are obviously welcome at any time.
