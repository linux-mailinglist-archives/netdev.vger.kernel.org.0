Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4625F2A899B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgKEWRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732295AbgKEWRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:17:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EEBB20719;
        Thu,  5 Nov 2020 22:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604614635;
        bh=mNPOyHAF+gOnu/PLAerau+pFGR1szKyBJvd3sVTaCIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CAke+90x3N9/UR9ISLxRkSVyEJrWNFfRnvQAeGrGL/XMB+5pRVNhI8iuIh6RyqRzC
         +qMC3PBkFH/kkIeS1EsAOfYg75EffAqheiacMemt2d3eSmIW9TN4BqY69wySkt5uqK
         XgUNpXQrItd6xFOPn+F5o7n90DmM0QveHiNzlMRw=
Date:   Thu, 5 Nov 2020 14:17:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v8 0/8] Hirschmann Hellcreek DSA driver
Message-ID: <20201105141713.09809e6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103071101.3222-1-kurt@linutronix.de>
References: <20201103071101.3222-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 08:10:53 +0100 Kurt Kanzenbach wrote:
> this series adds a DSA driver for the Hirschmann Hellcreek TSN switch
> IP. Characteristics of that IP:
> 
>  * Full duplex Ethernet interface at 100/1000 Mbps on three ports
>  * IEEE 802.1Q-compliant Ethernet Switch
>  * IEEE 802.1Qbv Time-Aware scheduling support
>  * IEEE 1588 and IEEE 802.1AS support

Applied, thanks everyone!
