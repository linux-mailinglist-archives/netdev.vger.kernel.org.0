Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5046A28F9C8
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392001AbgJOT4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391997AbgJOT4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:56:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C956206DD;
        Thu, 15 Oct 2020 19:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602791764;
        bh=IFboy+v3DDvlHNkG3SqXPgRt0t9TJUEPY5Ty3e1oZko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OGPdfslTFcOA+wxyeav8Cw8yxMHC5zuQ8FiSiiVprdhIAw/EiydkHa08wgn9DD2wG
         f5gwoYjipNczaUcBFBUpuQL0G/erFZgRh3A0gEVvUerQlCVV1yTv6jP2Lf4bcqf10r
         yVjRuHub2GXj4Z002j41clrze2QprmaI3Cw3uzb8=
Date:   Thu, 15 Oct 2020 12:56:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: add functionality to net core
 byte/packet counters and use it in r8169
Message-ID: <20201015125602.3e1efd01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
References: <e25761cc-60c2-92fe-f7df-b8c55cf12ec7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 17:47:32 +0200 Heiner Kallweit wrote:
> This series adds missing functionality to the net core handling of
> byte/packet counters and statistics. The extensions are used then
> to remove private rx/tx byte/packet counters in r8169 driver.

As much as I was hoping to apply this, it looks like it's still not
through my build testing :( 

So let's play it safe and come back to it in a week and a half.
