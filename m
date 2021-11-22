Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66AF4587D4
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhKVBq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhKVBqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:46:55 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B02C061574;
        Sun, 21 Nov 2021 17:43:49 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y12so69746196eda.12;
        Sun, 21 Nov 2021 17:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=WKetCckwp95p/4tHTwxvu1lpAVsr+WXyeyDyPpEwckk=;
        b=KWZXzYHrUpUVae1bW8xVBF9UtM29jIfc62dzdgcN62fhSXhkINpxOUbgNhovU7mC4D
         1z4YURpiM4k8+CuOXr7Hmns6R4hGp40P3k+FKv/Cb1Z+AJfyXzq5pgg4SL9OyArpPWvZ
         Jng3GwhxokxWcsd+gvScfRa792FZTnDgjc6V7wXaIGVCndaa+3hMGzak+lthoRRSnIKe
         Cs8AQGLbBiqlCV6EZaWASuPF5TWl138OV1bc48NVFDIrXFKK9WMRX8Aeat6/tiwxdgMZ
         An5ZigcR4efd9JSYSqLZSRNy0ZrRhEqdPvRAKL0p8km6+l2mQbyasEJMaqvaCo9xuLeu
         jDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=WKetCckwp95p/4tHTwxvu1lpAVsr+WXyeyDyPpEwckk=;
        b=dRyzQ1p0lNgGNYMqwrS+04A9hm/bIpD0QdEsoXtQRgOyq8VF+lhzd6dWGgsF+jfCB2
         GnbSXRMUMVsQVuN55K/X+QcZl7FD9KCA7Z0t63WP/2PDqgzDjSRMEmVAW29nyZnYGlTj
         IISJeZHRlG32an0/8OIsFzAQlnjCVoMe24v9f04KL7xM4dFQUN+Lw4UZtSZjS//X3O6A
         fCGdE/pqDsBO0t94pc6GgZLHJZpObL6VvcaDY2tBU9lWIdVTfjAYOMO8zwJGnRXwsLxL
         4WedGfItmbdM8AkhGSaT3iFMll+g+zyZsRk11gujupUwI9AT93RfWfZOPKCLUQOD3SxX
         UKUw==
X-Gm-Message-State: AOAM532DjhZtjYgCVDKBKiO4/Ev/F51yPxniisKs317upA93ui8ygvox
        Pc6fC5Y36PnvDMBbf5Wzhps=
X-Google-Smtp-Source: ABdhPJxTuHLm6KHuQZ2JbIZcsu6KqTiEvFQuLMjQPhpAiZSk1HbLIVBhMqtYQTPsQ3LbN3fgm9tF/w==
X-Received: by 2002:a17:906:90da:: with SMTP id v26mr36140187ejw.442.1637545428256;
        Sun, 21 Nov 2021 17:43:48 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id r3sm2980472ejr.79.2021.11.21.17.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:43:47 -0800 (PST)
Message-ID: <619af5d3.1c69fb81.36176.ca79@mx.google.com>
X-Google-Original-Message-ID: <YZr10ojSVwLGQABI@Ansuel-xps.>
Date:   Mon, 22 Nov 2021 02:43:46 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 0/9] Multiple cleanup and feature for qca8k
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122012910.bd33slbrfk4h6xbw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122012910.bd33slbrfk4h6xbw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 03:29:10AM +0200, Vladimir Oltean wrote:
> On Mon, Nov 22, 2021 at 02:03:04AM +0100, Ansuel Smith wrote:
> > This is a reduced version of the old massive series.
> > Refer to the changelog to know what is removed from this.
> > 
> > THIS IS BASED ON net-next WITH THE 2 FIXES FROM net ALREADY REVIEWED
> > net: dsa: qca8k: fix MTU calculation
> > net: dsa: qca8k: fix internal delay applied to the wrong PAD config
> 
> Since patchwork has auto build hooks now, it doesn't detect dependencies
> to other trees like "net" in this case, and your patches will fail to
> apply without the other ones you've mentioned, which in turn will make
> the builds fail. Patches without clean build reports aren't accepted, so
> you'll have to resend either way. Your options are:
> (a) wait until the bugfix patches get applied to "net", and Jakub and/or
>     David send the networking pull request for v5.16-rc3 to Linus, then
>     they'll merge the "net" tree into "net-next" quickly afterwards and
>     your patches apply cleanly. Last two "net" pull requests were
>     submitted on Nov 18th and 12th, if that is any indication as to when
>     the next one is going to be.
> (b) base your patches on "net-next" without the bug fixes, and let
>     Jakub/David handle the merge conflict when the'll merge "net" into
>     "net-next" next time. Please note that if you do this, there is a
>     small chance that mistakes can be made, and you can't easily
>     backport patches to a stable tree such as OpenWRT if that's what
>     you're into, since part of the delta will be in a merge commit, and
>     there isn't any simple way in which you can linearize that during
>     cherry-pick time, if you're picking from divergent branches.

Mhhh I honestly think b option can be accepted here (due to the fact
that fixes patch are very small) but the backport part can be
problematic.
Think it's better to just wait and get the reviewed by tag.

Is it problematic to add stuff to this series while the fixes are
merged? (for example the LAGs or mirror part / the code split)
Or having big series is still problematic even if half of the patch are
already reviewed?
Just asking if there is a way to continue the review process while we
wait for the merge process.

-- 
	Ansuel
