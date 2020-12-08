Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4642D20C1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgLHCWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgLHCWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:22:47 -0500
Date:   Mon, 7 Dec 2020 18:22:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607394127;
        bh=bsexMs+QLMd00yUiO/o6BDQs4h2Mkb5Cc6l7Vc16tdQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bm1XVYpHH/f1Lqs92TK/I1Eco2jjBywkXjMCHdmnpsjNL+9jFXEll/mbQEh+2eKPL
         Jfn0CVf4gGhQ9PMIlskfmyQUZgQOuAJfa5uEcC0fdzgXotyrPqqe6dwe9WkRtFXYGb
         vOwMujgw40Gm3qTK8ro7lW4HBWzVX2jyvyl152iOHqBeJCoG7xSQsSjGjqo9jL8Ya8
         mw5HbaegFvIiUfnWEtNAIoCV7KJxJoPQ+VaUfaC0vHXjsGZD8lLQalp4qH5argRJJD
         Q6bcW6Vb66gLsQN45F8xnQFvTG+pBInMhaZ5JiKMRimRZwUt3moIEFvTkNE5JnT/OV
         aKTdJ2jKzddpA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: set xfrm feature flags more sanely
Message-ID: <20201207182206.572acfaf@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205174003.578267-1-jarod@redhat.com>
References: <20201205174003.578267-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 12:40:03 -0500 Jarod Wilson wrote:
> We can remove one of the ifdef blocks here, and instead of setting both
> the xfrm hw_features and features flags, then unsetting the the features
> flags if not in AB, wait to set the features flags if we're actually in AB
> mode.
> 
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied, thanks!
