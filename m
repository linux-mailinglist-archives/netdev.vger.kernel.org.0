Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF731E36D8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgE0EFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0EFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:05:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DE0C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:05:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nu7so944078pjb.0
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Isg0pibvTUg2meXw33arA900PhuCCML+WJkzvD5hIEM=;
        b=DK2ffep9P5KTwOizMMhTujuFZagtyZ8ZwfxGGK6VvFuy3Ty7WTnuHuONwHpl+t4Gzq
         EA6w1btt/0EpHbtia2aRZFsyuGdxBgGAm+8tNfzNgReyVw96DgCHLOjrkCQzWck0El5m
         yLngTQp+xK4Y3xgB3tkO3LaF35cbJctwn/NFct3QB5NL+/LDtLT/pC8LZKQLyv5cC/Qg
         2Egti4vqIg5F/XsRhSgmoUgCsIDDM678LhegdimbbOTBLTFLTGLqnqhTlVwrd2rDzEAV
         J0f1IaknY1CPTwGr29akQQe3PPUOZ7Pwf9UV0bIuQPVPjp8nMaNuTJymMPFKROI+66uT
         qvTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Isg0pibvTUg2meXw33arA900PhuCCML+WJkzvD5hIEM=;
        b=VSToP11I23pPeGArGjSmlxI5WvutA35TFbZgDhc45CGmWxsYU3WP29FodWSF8XgCWR
         Dh1LJV6WtdG5qEfSPsqEuFa+eqUV08Zn5tM2/ISZTfWX2dz3SVsg0cKZk4lNsfqwgNxe
         Rc4E4cWMaTTcRP+nplXrIJ/9Os2oXi5aUbhVCMzqYDjE7RWsFG2Ud24VsK4CC+8ycDVA
         sNF74hpBpucUC9LiljWME11lyaPcLGktOrGrp7RxojJFTvEwuGrEiLep8pyPMDgirKn+
         bK3K62naOSiICy9sltZtyVLPkmwBoaSxKC2hu9zMrNhJ+lY6UKaSZSPwLo1ZNRNI4ftb
         hOSA==
X-Gm-Message-State: AOAM530XAIPH+7KaA1+RXKW87HkY/owtXJr7dMAevz8uaLnCD10OitDE
        sRIkWQUOqg+zxGxK20WqE4pO5/xd6JM=
X-Google-Smtp-Source: ABdhPJwIgelBDvJlgpXhD1zc5nZBttdLPgvom5DzCFR7jj4EVAv11Sq7rmPm7o1Gxt39fgAR+IX3hg==
X-Received: by 2002:a17:902:b716:: with SMTP id d22mr3966309pls.140.1590552354487;
        Tue, 26 May 2020 21:05:54 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y13sm848869pfq.107.2020.05.26.21.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:05:53 -0700 (PDT)
Date:   Tue, 26 May 2020 21:05:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Julien Beraud <julien.beraud@orolia.com>
Cc:     Olivier Dautricourt <olivier.dautricourt@orolia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
Message-ID: <20200527040551.GB18483@localhost>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost>
 <20200514150900.GA12924@orolia.com>
 <20200515003706.GB18192@localhost>
 <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 03:26:47PM +0200, Julien Beraud wrote:
> The frequency adjustments of the mac's clock are done by changing the value of
> addend, so that the number of clock cycles that make the accumulator overflow
> slightly change.

This is typical.
 
> The value of sub-second-increment is set to 2 / ptp_clk_freq, because using an
> accumulator with the same number of bits as the addend register makes it
> impossible to overflow at every addition.
> 
> This mode allows to implement a PTP Slave, constantly adjusting the clock's freq
> to match the master.

Right.  And I would stick with this.  With the ts2phc program
(linuxptp master branch) you can use the EXTTS to discipline the clock
to match the external time source.

> -> In coarse mode, the accumulator and the addend register are not used and the
> value of sub-second-increment is added to the clock at every ptp_ref_clock
> cycle.

That sounds like simply configuring a fixed rate.

> This mode allows to implement a Grand Master where we can feed the stmmac's ptp
> ref clock input with a frequency that's controlled externally, making it
> useless to do frequency adjustments with the MAC.
> 
> We want our devices to be able to switch from Master to Slave at runtime.

If I understand correctly, what you are really asking for is the
ability to switch clock sources.  This normally done through the
device tree, and changing the device tree at run time is done with
overlays (which I think is still a WIP).

> So the question is what interface could we use to configure a timestamping
> clock that has more than one functioning mode and which mode can be changed at
> runtime, but not while timestamping is running ?

I think this must be decided at boot time using the DTS.  In any case,
the PHC time stamping API is not the right place for this.  If you end
up making a custom method (via debugfs for example), then your PHC
should then return an error when user space attempts to adjust it.
 
Thanks,
Richard
