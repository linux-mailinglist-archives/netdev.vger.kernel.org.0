Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF662AFF4F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgKLFcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgKLBgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 20:36:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 174142067D;
        Thu, 12 Nov 2020 01:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605144570;
        bh=nZ4GFia7wcwBp8ez9g2RSqS6ccrRRvR95DL34pZoJBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aaw/mzDzZjO1ktcHyGATtMMt38safsemW49WhtGXPGS8E+Z9OTBIO/kndCL2bL2Kn
         qkWwkt9uW10ypYfoUVTj8E7FyI7N7XP4azKdqz5o9tA2IKePf149g2ITCkNeZOkHl0
         BtnSpGyr9WdgYHBxxfUghfTa3LHj4kahoGHg1Uqk=
Date:   Wed, 11 Nov 2020 17:29:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: Add entry for Hirschmann
 Hellcreek Switch Driver
Message-ID: <20201111172929.54b35b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110071829.7467-1-kurt@linutronix.de>
References: <20201110071829.7467-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 08:18:29 +0100 Kurt Kanzenbach wrote:
> Add myself to cover the Hirschmann Hellcreek TSN Ethernet Switch Driver.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Applied, thanks!
