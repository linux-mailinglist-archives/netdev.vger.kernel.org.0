Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326EA5DB11
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGCBnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:43:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGCBnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 21:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZknEdyZ1T4tCO8tHmRX93ivSc3EBe24oWP4BwRhJ2Q0=; b=TYEN0hMZKShpozJvjr/W9Y1Srn
        iaaqJaCW3jncpzHmm3Y+Dogy7v6DYmTCxq2ob5wMgxdl8KTfwzyiDXnN/xjBCAMvqUVit5pkeskg4
        6vRmtmlc5vthbW7UyxuzRgsUekvcAeeRi2JwIK9aUBoeijunwkNHXb+mHSewJgugPPaA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hiQRA-0000XZ-Q8; Tue, 02 Jul 2019 23:35:40 +0200
Date:   Tue, 2 Jul 2019 23:35:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>
Subject: Re: Validation of forward_delay seems wrong...
Message-ID: <20190702213540.GD28471@lunn.ch>
References: <20190702204705.GC28471@lunn.ch>
 <55f24bfb-4239-dda8-24f8-26b6b2fa9f9e@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f24bfb-4239-dda8-24f8-26b6b2fa9f9e@cumulusnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> The man page is wrong, these have been in USER_HZ scaled clock_t format from the beginning.
> TBH a lot of the time/delay bridge config options are messed up like that.

Hi Nikola

Yes, that is a mess.

arch/alpha/include/asm/param.h:# define USER_HZ						1024
arch/ia64/include/asm/param.h:# define USER_HZ						HZ
include/asm-generic/param.h:# define USER_HZ						100

And ia64 does
# define HZ             CONFIG_HZ

So it seems pretty hard for user space to get this right in a generic
fashion.

	Andrew
