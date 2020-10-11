Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB1428A848
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbgJKQpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 12:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388209AbgJKQpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 12:45:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B66C21655;
        Sun, 11 Oct 2020 16:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602434708;
        bh=MWZq73Js37yYCeb9lFpCw1s/HFggcwkZpKuGIcqIQLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vVhog8hQnGljXFDIr4ASVlLgxlpY9S1Al53ETlP3oKO6QOPbifO5PJAZr3skZvRf7
         yRg8HNE4JAgFfzkWi2m+l/9pklnWgCO6fBpFURaZ99lGN3uohPjbDJ7J6ULzCZ1AYw
         ld11xUUQolWcAvG9Vv67o/9TMcndmPDWNnSMDkh8=
Date:   Sun, 11 Oct 2020 09:45:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] ne2k: Enable RW-Bugfix
Message-ID: <20201011094506.54ed008c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010161711.19129-1-W_Armin@gmx.de>
References: <20201010161711.19129-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 18:17:11 +0200 Armin Wolf wrote:
> Correct a typo in ne.c and ne2k-pci.c which
> prevented activation of the RW-Bugfix.
> Also enable the RW-Bugfix by default since
> not doing so could (according to the Datasheet)
> cause the system to lock up with some chips.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
> v2 changes:
> - change NE8390_RW_BUGFIX to NE_RW_BUGFIX

I'm not applying this, sorry.

It's been this way since Linux 1.2 and you're giving no information
about why the change is needed in practice.
