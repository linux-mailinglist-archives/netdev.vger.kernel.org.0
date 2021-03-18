Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614BC340EDD
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 21:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhCRULN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 16:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhCRUK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 16:10:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C4AC06174A;
        Thu, 18 Mar 2021 13:10:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x13so6851695wrs.9;
        Thu, 18 Mar 2021 13:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ps9LfNNCNYk4EPJwOAX29BFfryqjopm8suHQ9BWWqbc=;
        b=g8B+mRBmeY0Qo7Uqcp6rylyVws8d5WiipqfZ1jpiDKRqv8/nERUC5fi87sJvJao4BT
         yvY1j3C6TqqKl933x2lqWqCTWUarFsmHuYB010CePPnm3WEYarLNF2wgIFJ0UqINGyty
         9Y5Yi9RXHB05sZcYXIytpvMb8p5Glcq/3Ciq51Ch/MriyjNSGQVjmY7D5vdyX/y2Y456
         oo1SOi+yju2hYBFAHDyWkiH5FZclirjAm2f8qgoOXiNdJt6w/kdehCe+xRsbUix3/C7P
         juE/NKXKww2nVmATl4B/4xk9yQuQ9FnoNJDKHi4dWdlVw3/TNG0dLmc81iho072wcRs5
         iZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ps9LfNNCNYk4EPJwOAX29BFfryqjopm8suHQ9BWWqbc=;
        b=sGt4+GTZvKIiD5YXaW8TKvrgPgIxcqRpgRPW1SSftrRkZyF3EqFpzxyvy/7N8BLjPc
         1HY6Betbt32PisEP9nn3NeX3EjUPfmxREFcRt2gtDSqejGY8K2KyQkggaWiEHgTJCCob
         8CqYqkOjM04raQ6x9ZU8m/vpci5Xcxy/RvXmXirdXFAH6A+7PmQPqFO/d9w78MY2wGzt
         J8YisIxxY2L/9sH6UUFZHB5yjd02bFFaSh/tvJHOyJkax5aiT2oj+Bolvi9KmZ/g8CYX
         PMRThWLKX5/Gv3qxNRSiO9AwhCe94EL0bTZE5NxPUDs1opEe/4Fd2cjKl2tvr2FXvC7j
         cQJQ==
X-Gm-Message-State: AOAM531E9WN8RqPB1FPINQh/WVmsx6PFqAjraZZqAQJ6hbCQKgQ3BmVE
        rt8h2o+6Np/a1GVjFi1kT+o=
X-Google-Smtp-Source: ABdhPJytOYgRDnuAvvwEVLrt7yIsbidop3xJHop4swh7tXZl+QYLrUx2ALcgS/SXT6AVFL1QetZ7xg==
X-Received: by 2002:adf:e5cf:: with SMTP id a15mr970769wrn.226.1616098256344;
        Thu, 18 Mar 2021 13:10:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84? (p200300ea8f1fbb008d2c08cc6c7f1a84.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84])
        by smtp.googlemail.com with ESMTPSA id i26sm3670923wmb.18.2021.03.18.13.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 13:10:56 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: phy: at803x: remove at803x_aneg_done()
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210318194431.14811-1-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d4dd656a-fd30-51d2-f9bb-55ff4b4dce9b@gmail.com>
Date:   Thu, 18 Mar 2021 21:10:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318194431.14811-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 20:44, Michael Walle wrote:
> Here is what Vladimir says about it:
> 
>   at803x_aneg_done() keeps the aneg reporting as "not done" even when
>   the copper-side link was reported as up, but the in-band autoneg has
>   not finished.
> 
>   That was the _intended_ behavior when that code was introduced, and
>   Heiner have said about it [1]:
> 
>   | That's not nice from the PHY:
>   | It signals "link up", and if the system asks the PHY for link details,
>   | then it sheepishly says "well, link is *almost* up".
> 
>   If the specification of phy_aneg_done behavior does not include
>   in-band autoneg (and it doesn't), then this piece of code does not
>   belong here.
> 
>   The fact that we can no longer trigger this code from phylib is yet
>   another reason why it fails at its intended (and wrong) purpose and
>   should be removed.
> 
> Removing the SGMII link check, would just keep the call to
> genphy_aneg_done(), which is also the fallback. Thus we can just remove
> at803x_aneg_done() altogether.
> 
> [1] https://lore.kernel.org/netdev/fdf0074a-2572-5914-6f3e-77202cbf96de@gmail.com/
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
