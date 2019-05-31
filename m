Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26557314CC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfEaSdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:33:33 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35834 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfEaSdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cxyxGt5CbpzmJbgYuOu9H6gwZqfOOb5mY7RU2Xn6T70=; b=Mt2gWKqgWGO3HF/mRZVecjwuv
        Vapj7AlIa/3EMSBLLHm8fstjwZ9V6T1Kol5VBvyVQLgcvCpq+Ct0W8nPCYRFq+W7UJWwTooAJ8uap
        nlS4PRogkiP9Nqtnk2neq33H4/iEZ7O+IsC/cndkGl5XnlpICY373ALi1e2PSWvizT4MqhLxWibXs
        1GJEdBgvZDdSVRJ0/0pRBVCGfMWY174lm/0SSb1wWxA7ho2LiWRrQsbnszeTsKCL1b5PxahZcRFlw
        hZJcQ3RF+9ikiG4vYNAUxc5soFdbwbT+qQVQdmIhA9bGhJI6pWdJJJtJM1MUwA93f60tvcqLUUzfG
        vSjmr7rMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52768)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWmLE-0002R0-JD; Fri, 31 May 2019 19:33:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWmLB-0006Ya-1G; Fri, 31 May 2019 19:33:21 +0100
Date:   Fri, 31 May 2019 19:33:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     wsa@the-dreams.de, ruslan@babayev.com,
        mika.westerberg@linux.intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
Message-ID: <20190531183320.vrle32ps5jga37pn@shell.armlinux.org.uk>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190530.112759.2023290429676344968.davem@davemloft.net>
 <20190531125751.GB951@kunai>
 <20190531.112208.2148170988874389736.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531.112208.2148170988874389736.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:22:08AM -0700, David Miller wrote:
> From: Wolfram Sang <wsa@the-dreams.de>
> Date: Fri, 31 May 2019 14:57:52 +0200
> 
> >> Series applied.
> > 
> > Could you make a small immutable branch for me to pull into my I2C tree?
> > I have some changes for i2c.h pending and want to minimize merge
> > conflicts.
> 
> I already put other changes into net-next and also just merged 'net'
> into 'net-next' and pushed that out to git.kernel.org, so I don't know
> how I can still do that for you.
> 
> If it's still possible I'm willing to learn just show me what to do :)

i don't think it's possible - not with the changes having already
been merged yesterday, and presumably published shortly thereafter.

The tree contains 231 other changes wrt 5.2-rc2 up to the requested
point, which I doubt Wolfram will want.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
