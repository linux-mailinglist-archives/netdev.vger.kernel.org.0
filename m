Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8043E522
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhJ1Pc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:32:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhJ1Pc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qAuFhgBFwzRjU9C9QI6Rl/rsQkR3ooBS4bpMf6vbBo4=; b=lFP4oAypO15El8tNC0JuZDkk61
        rjFlVA2VNcLE0JBKSGyizz98EwWcW/PVnHcNJvZrh/CCc/kF062/jpFbMxcfs7z7vy8mWzJZDRbAG
        hTeNQ3zgpLSo2hZkQv8KAe1/HPtvVlOhTG7WAjjxmHELNRIEjGlIkK8f/KBbaFBFBfI8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mg7MK-00C0j0-VO; Thu, 28 Oct 2021 17:30:28 +0200
Date:   Thu, 28 Oct 2021 17:30:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     bage@linutronix.de
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 0/2] Fix condition for showing MDI-X status
Message-ID: <YXrCFKu9EnApypVh@lunn.ch>
References: <20211027181140.46971-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027181140.46971-1-bage@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bastian

> I found that issue running ethtool on a br53 switch port.

Is this on the user ports? With copper PHYs? Did you try fixing the
driver so it actually sets TP?

> Despite the enum names, I cannot find documentation on the MDIX fields only
> being valid for twisted pair ports -- if they are present, they should be
> valid. But maybe I am mistaken.

I'm not sure that is true. I've never seen an SFP module that can swap
around the two fibres if they happen to be the wrong way around. And
it makes no sense for BNC based cheapernet, if that actually still
exists anywhere.

       Andrew
