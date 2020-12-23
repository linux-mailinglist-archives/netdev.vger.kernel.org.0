Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEF52E1F60
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgLWQTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 11:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgLWQTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 11:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC6722BF3;
        Wed, 23 Dec 2020 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608740331;
        bh=3+M5dgFaogEfz2BIpAkiSTBvxwVIpEs3yiTB1VyEuUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P8HMSPHsWn6XRJQUqh9mUm96xAaICT16epLDMBPr20CAhP2IcMk354rtUtftIdWdY
         t6ZhVAcchO35Br4gp7qlOYfnwK2ncnals2kYVaamDRxbyunNEy89Xx023xVhPljir7
         eD7UsRWvKdH7ogjONvYLq50NzznX165MSMRNY+dXTAc9ivIzw/be0iFJxHCfuJ8b/W
         JstkAY3wg7Y6hbPWYF07GfxBPMV5iGVOn2dNbaWsZK/DstsBLgQwUsI0fVQMSOhA8m
         ZDQcXuMXiJqfasTNBO2JhKj6oRV3gdy3M6yTetAawGst3wOyC1ba5RWGBNcQBoEkGW
         ZJwUCgdP5ao/w==
Date:   Wed, 23 Dec 2020 08:18:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] docs: netdev-FAQ: fix question headers formatting
Message-ID: <20201223081850.772efcbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f76078ba5547744f2ec178984c32fbc7dcd29a2b.1608454187.git.baruch@tkos.co.il>
References: <f76078ba5547744f2ec178984c32fbc7dcd29a2b.1608454187.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Dec 2020 10:49:47 +0200 Baruch Siach wrote:
> Join adjacent questions to a single question line. This fixes the
> formatting of questions that were not part of the heading.
> 
> Also, drop Q: and A: prefixes. We don't need them now that questions and
> answers are visually separated.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied, thanks!
