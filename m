Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370352CDD04
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgLCSCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbgLCSCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:02:23 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C64C061A4F;
        Thu,  3 Dec 2020 10:01:43 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id jx16so4769623ejb.10;
        Thu, 03 Dec 2020 10:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vrkRmpOJdYsv1OTsol1WiI+G5mphp85mQMrcLwt5llw=;
        b=PJ9U4t7gwpf3L9BXUTtYedcItrGStWV5xXJs2ODQYkKRGmyTk/ommC7rOFYpCnm5iV
         22e59hG4fPPPjgQFEZ7KPcQOH01jbStQy7JBOgtdUzPLbkyyolx+gggIHehh6+g6RnJ6
         G0oizsYDh3NTH/wEGp6C+qdgo7sLrKyk6UZZ8jkjEBZ39Rl6qAzU2MSH43pkQVeK2Sfw
         JSu7LnCNuJBg34p1x7efcBB4qkKYt8IqZ9luWBxl4e5o3fLlqHjjkAuXQO43O+IQuD/R
         yutk8DTwZ7MPI6P88XSoZI0j8UA4jjbjPUkm06awuloS3PwotYbpkOWYXLsHcSV+ESjE
         z8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vrkRmpOJdYsv1OTsol1WiI+G5mphp85mQMrcLwt5llw=;
        b=OUtawnNGE1410rBtqNWHmdumFQ3l4NCusrWKcSdplHZZ7Wj423fTU/umga8Acpin8o
         7VyXghYfVH2npMhgVB4HDuK6IDvvpOWQQnbK+jE+p3BpP6z608hR6Ec43fdM8KtzXJMf
         PeO+EJZptRL3eoiNSya3jbVrw60rkdZPyqWl+DpaPIjrc4ElKwtf9new1GPFr2Q9piQr
         oiH5D2mIpJZWGw6SwYS74Lef9x7pOvVS0rUJzv4aGp59GjA/C+Rj6eucj2PW3GQsbQ6J
         gspivDy/Lxq8bhrmzNdQgEtHuNLpU2t0aqPD8aUcHFd9CmQqdEzbq9wqy2UF21EgvF3T
         m8QA==
X-Gm-Message-State: AOAM530QT67O37+MDL4pum3Y2n2D3Won0bqFDAfjmzMPwtbnhVE1ObVi
        BmX6f/3s6vpDxG033g979JCu6nBvzB8=
X-Google-Smtp-Source: ABdhPJy5BnXOdnLykRHtRKij+0KNQueTx2wcwvxCL9WRMm6a5Yok5Y6dV7Lth9S16iCzuoUv/zclew==
X-Received: by 2002:a17:906:60c8:: with SMTP id f8mr3552635ejk.14.1607018501762;
        Thu, 03 Dec 2020 10:01:41 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id y17sm1284342ejq.88.2020.12.03.10.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:01:41 -0800 (PST)
Date:   Thu, 3 Dec 2020 20:01:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201203180140.4puwxgailw2iysxz@skbuf>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-3-o.rempel@pengutronix.de>
 <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201203085011.GA3606@pengutronix.de>
 <20201203083517.3b616782@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201203175320.f3fmyaqoxifydwzv@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203175320.f3fmyaqoxifydwzv@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 06:53:20PM +0100, Oleksij Rempel wrote:
> It is possible to poll it more frequently, but  it make no reals sense
> on this low power devices.

Frankly I thought you understood the implications of periodic polling
and you're ok with them, just wanting to have _something_. But fine,
welcome to my world, happy to have you onboard...

> What kind of options do we have?

https://www.spinics.net/lists/netdev/msg703774.html
https://www.spinics.net/lists/netdev/msg704370.html

Unfortunately I've been absolutely snowed under with work lately. I hope
to be able to come back to that during the weekend or something like that.
