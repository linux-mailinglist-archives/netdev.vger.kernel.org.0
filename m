Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402FD1CCCF5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgEJSju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgEJSju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:39:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFC742080C;
        Sun, 10 May 2020 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589135990;
        bh=wrKLOw5tN/+Cndc1RotzS7+IF8fGA573JnpcJ0n2TY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HGh/ly+1x98Zkos4+oqVoRSFV6svdUXSPaZAf/g6w3MnoOEoHV2R0vEiv82hjD/eM
         0dvuOz3Je7fkL6F1B7xvXamiFJEV0qTveqsZtW+AWpXqj+G/ojPyB+PfQLnUWBGXWS
         kCLOWsHzWowuencH6G951sDjR4WUOkiDuKjO1tT0=
Date:   Sun, 10 May 2020 11:39:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200510113947.567e07a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510182252.GA411829@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
        <20200509162851.362346-7-andrew@lunn.ch>
        <20200510151226.GI30711@lion.mk-sys.cz>
        <20200510160758.GN362499@lunn.ch>
        <20200510110013.0ae22016@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200510182252.GA411829@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 20:22:52 +0200 Andrew Lunn wrote:
> > Sorry Andrew, would you mind doing one more quick spin? :(  
> 
> No problem.

Thanks!

> > More importantly we should not use the ENOTSUPP error code, AFAIU it's
> > for NFS, it's not a standard error code and user space struggles to
> > translate it with strerror(). Would you mind replacing all ENOTSUPPs
> > with EOPNOTSUPPs?  
> 
> O.K.
> 
> Would it be worth getting checkpatch warning about this?

Good point. I feel like I already had a patch for it once, it must have
gotten lost when I was changing jobs. I'll take care of it.
