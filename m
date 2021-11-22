Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235B14587DB
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhKVB7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbhKVB7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:59:04 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C58CC061574;
        Sun, 21 Nov 2021 17:55:58 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r25so32926961edq.7;
        Sun, 21 Nov 2021 17:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yAMBLIWcgPcTELLwg6eU2Wm/MMJdqWWpdYWxaZx0w7I=;
        b=f9TKYg2LnQUvlKW4M4mZ36DxqkM/0x5Bhl98TqCgy3kf/Q3SrDlnDvJiQNkwzAzJp4
         23TEWeGofLHyC/5OL7Ty3mXx+B5QJUDL9bCZ1s7pcwCsWq/LxKR3oBdX8HI3skASaZOv
         fLRye1ADTG8fXuV4FuYrDohQJOlQT1l7WpQJmElCVby2RSu2XWF8+2GMFnT/1AeR05tP
         uMKYRnbthX+OC0MMrr36IcY0XNksf5mYW67DMnTwJGwP2bLv4gxW+HOuQAF+LK7efuQ6
         gHJBOADCd0jHq0rkeprXwkBNpVU3M3th2mt0dmSEQVYfHk+uR7plGWmQwqlLN11vlEKQ
         yOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yAMBLIWcgPcTELLwg6eU2Wm/MMJdqWWpdYWxaZx0w7I=;
        b=QPH9Z5fFUqexk8m2NnA8SNqzlsW0HUd85OWWLuySCdRxwFaBV5cZ9H+TGyCuP+Wyo6
         GIGZCYNNO+SbGdiO/alkcO9oIgq2k83G4eCTkZwyBxwrhi1AGXmbI5JG4/qR56lN5Xfj
         lr21XAG/G+JGKRxWIFT1NZyIB+jTuxrJV9HSmmQTWsuIiAo0KVjm7Q5//2TbOpBakUhw
         P0Uqbw0I/YCOfxEx9K6cGKDUdH4OEPDMvgcNcqYmrSDr4FpJRgmrICUKPoj7xB26izZX
         jJ0cykNoiQ7i4mz8zhYrhiGKDs4rIhkhqBRM1adXkm2HTsKPK50GMTWr9UpCq8qzUbyj
         kA6g==
X-Gm-Message-State: AOAM5324D7ewfYSK2camkO2i4YUw6C9p6/IOZtKnSNSqLVHJIUFiNbiJ
        9Qgm3Yg6IHnhqpg6rLKQPHY=
X-Google-Smtp-Source: ABdhPJxh9wtPbj/9SAkLHPD5rnxsYEkDvC05lZHgF3s41jG7S7NRGUWSefW0Tp7MFqUjXF6m8nWpng==
X-Received: by 2002:aa7:d052:: with SMTP id n18mr57814252edo.104.1637546157208;
        Sun, 21 Nov 2021 17:55:57 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id n16sm3262786edt.67.2021.11.21.17.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:55:56 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:55:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 0/9] Multiple cleanup and feature for qca8k
Message-ID: <20211122015555.ucbi77ytiokgbovu@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122012910.bd33slbrfk4h6xbw@skbuf>
 <619af5d3.1c69fb81.36176.ca79@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <619af5d3.1c69fb81.36176.ca79@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:43:46AM +0100, Ansuel Smith wrote:
> On Mon, Nov 22, 2021 at 03:29:10AM +0200, Vladimir Oltean wrote:
> > On Mon, Nov 22, 2021 at 02:03:04AM +0100, Ansuel Smith wrote:
> > > This is a reduced version of the old massive series.
> > > Refer to the changelog to know what is removed from this.
> > > 
> > > THIS IS BASED ON net-next WITH THE 2 FIXES FROM net ALREADY REVIEWED
> > > net: dsa: qca8k: fix MTU calculation
> > > net: dsa: qca8k: fix internal delay applied to the wrong PAD config
> > 
> > Since patchwork has auto build hooks now, it doesn't detect dependencies
> > to other trees like "net" in this case, and your patches will fail to
> > apply without the other ones you've mentioned, which in turn will make
> > the builds fail. Patches without clean build reports aren't accepted, so
> > you'll have to resend either way. Your options are:
> > (a) wait until the bugfix patches get applied to "net", and Jakub and/or
> >     David send the networking pull request for v5.16-rc3 to Linus, then
> >     they'll merge the "net" tree into "net-next" quickly afterwards and
> >     your patches apply cleanly. Last two "net" pull requests were
> >     submitted on Nov 18th and 12th, if that is any indication as to when
> >     the next one is going to be.
> > (b) base your patches on "net-next" without the bug fixes, and let
> >     Jakub/David handle the merge conflict when the'll merge "net" into
> >     "net-next" next time. Please note that if you do this, there is a
> >     small chance that mistakes can be made, and you can't easily
> >     backport patches to a stable tree such as OpenWRT if that's what
> >     you're into, since part of the delta will be in a merge commit, and
> >     there isn't any simple way in which you can linearize that during
> >     cherry-pick time, if you're picking from divergent branches.
> 
> Mhhh I honestly think b option can be accepted here (due to the fact
> that fixes patch are very small) but the backport part can be
> problematic.
> Think it's better to just wait and get the reviewed by tag.

There is an option (c), which sometimes can be done and sometimes can't,
which is to write the patches in such a way that they don't conflict
with each other. I haven't checked what the exact conflicts are here,
but that regmap conversion thing is pretty noisy, you're renaming every
register read and write. Being more moderate about it can work to your
advantage.

> Is it problematic to add stuff to this series while the fixes are
> merged? (for example the LAGs or mirror part / the code split)
> Or having big series is still problematic even if half of the patch are
> already reviewed?
> Just asking if there is a way to continue the review process while we
> wait for the merge process.

You can always send RFC patches because for those, the build part isn't
so important, and there you can specifically ask for review tags and/or
point reviewers to other patch sets that they should apply first, were
they to review your submission by actually applying to a git tree and
not just from reading the patches in the email client.

I would still have multiple series of manageable sizes instead of a
monolithic one, just because it is conceptually easier to refer to them
("add qca8k support for X/Y/Z features" rather than "qca8k-misc-2021-11-22").
