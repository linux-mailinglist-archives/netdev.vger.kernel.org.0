Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A15037738A
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhEHSHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhEHSHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 14:07:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204DAC061574;
        Sat,  8 May 2021 11:06:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m9so12412110wrx.3;
        Sat, 08 May 2021 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BY3vyO9pMkZS/tNRRnw/sDCXtFbinbRxFnutirRQ/pE=;
        b=VRQzFAUpagU7++DK8NkgEOJrRYxq9XPkq19/Zy7tpJCN1o/WFUoYqfIAtVNANiw6ed
         o7W7eUlTAmuLCFxxTQCW1rePpoQBImxf1sh02QXd6Aj/Y1KUs0VJAF3CrSWHJJppTjxF
         mqAp4nbJ7UqiJF8+nen15ZpOD1EX6nobz2A3LHR6DwpEOVCUQwJyg4cmd/Q5uiswx49p
         aZt7looso0RtofHRyl+45i82aYVbTTou57ze4lfcU2HVxA5XxLdbu3VfNtelSME9jper
         4eh/OyfHMkxmW/fogp4uh8WTmTeqgnAIGJ/fZMIedPL/U95vBcF0VfkL4rv8MawpDBXw
         vmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BY3vyO9pMkZS/tNRRnw/sDCXtFbinbRxFnutirRQ/pE=;
        b=PzQiU8M8uwRr8yZbT9mXdtYLvzIB1NLcQcjn1KFbcBYpwg2MlTqI1Kyp3PGpwtsmlD
         zLmYomrQLTZ2SE7ljMvvD2rn4UqKERxrVGd6gyoiZ33tiLeXo8s3QpFFwLYKnnrqlwj6
         KsRwMVa1U3tFZcArmtXlr5uh80wJxU57Wt80iPsnfPM3z5bX+O61bAtJmqwcN2O1PEme
         ywdfVviEF+jR0J9yWhld+rO5C7uaDhd8EkVqscIgAnuRIpeKpUNtLCq/5wQ3XiEJJrCX
         Dn0ZmOIRX4iygDjB8up3hXzqntRsWR2tmbZQBOq74slXdhjfMEddGybBXH/uQ0My6q2K
         8Msg==
X-Gm-Message-State: AOAM530U/WWaIRtmqqYrShsp7NPSeDSTpcMz2GvitNNgXT1nCSfu1LUj
        S4dVJP+HfJZ0uEH22s8u30w=
X-Google-Smtp-Source: ABdhPJzgiebXyliJIANiTRFMMDpVXr4sIMuHD66xpFur+Y8GcDPBiz1mPW+PIoMXe3ichhG6PBWf7A==
X-Received: by 2002:adf:8b09:: with SMTP id n9mr20836834wra.148.1620497159645;
        Sat, 08 May 2021 11:05:59 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id n7sm14653695wri.14.2021.05.08.11.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 11:05:59 -0700 (PDT)
Date:   Sat, 8 May 2021 20:05:58 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJbSOYBxskVdqGm5@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > Fix mixed whitespace and tab for define spacing.
> 
> Please add a patch [0/28] which describes the big picture of what
> these changes are doing.
> 
> Also, this series is getting big. You might want to split it into two,
> One containing the cleanup, and the second adding support for the new
> switch.
> 
> 	Andrew

There is a 0/28. With all the changes. Could be that I messed the cc?
I agree think it's better to split this for the mdio part, the cleanup
and the changes needed for the internal phy.

Can I keep the review tag?
