Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE72224AFE
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgGRLgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgGRLgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:36:42 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50412C0619D2;
        Sat, 18 Jul 2020 04:36:42 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id by13so9610692edb.11;
        Sat, 18 Jul 2020 04:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b6FsGUMo8gBHzRtIJl8AyXC2dt0ZCDvAdrxSpOTGfxk=;
        b=uH6UG+454MUj+Xqo8/Abi8e11p1m+3u+CVKXQJU7G6YQp3eAccUqJG20D+haTz2dLj
         w0TfwTHqssz0rJ4xChpletS+mgQH3UzgYL0DqF+9looUO1qoVFFvXG6zjGiBikYhdJkJ
         267wOxnIBtci7SWge/Jg1WW5EhVzgo/hOuNk3iLp7ZkRUR4IBTBesQQ/tQqtORVinaPA
         mKFXQULJVUxGDAQTEFEL+OjsEu2zeSgL0phu/SFhG63aw8lLW+aTwuUk9Rsr2mrT9Ixp
         DF7OACeB8tha15uSSB2lOmls3cSWNl/tm2wFb1H6B5SvHLpQlBZCPQu0ZI9tmWNuEQkT
         fiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b6FsGUMo8gBHzRtIJl8AyXC2dt0ZCDvAdrxSpOTGfxk=;
        b=iLL5ap6/cIIanHS3GAvhzHuag6xRYqSd17FM2sanixV9jWJyE+C2tQUwnSYewc5f8E
         hGK1VhVxHEYBzvxhwipaweflNxdGByukfXxOd2uP4lb9CMC50oHmvGglVGabc9yu0Hsq
         n81IDkNN8SEuJfdui+PVWSd2lqcXKdN0SvydJfBLSDc1mlxWqFY6vc/VAjtgX/hbwUtH
         H9w5rOqDSrkG9zn87xZN4RXH8WVJ0Csk3rT+b6OozBdWMxAf8cMe7GowXx8tNWSKu5/J
         YHJqFb+TjQFAQWd0n6OxhCNiBbI7nLlwp3P9t3hqmvGRLi0GMaD6EaotCz25ZLE35762
         6rDg==
X-Gm-Message-State: AOAM5329N1ddZx7/ITqZLos/p0vD1f8ltzkcPV8WbM0pe0//qiVtiYxt
        DRLmng1iy4o80wPMLWEygdHNBhpU
X-Google-Smtp-Source: ABdhPJwCYe0BrQ3Q9cabQ3z1NVDErUPJzoEzc6eS2m2gZf+2VssDxL91fCNKDJECirYEU1Whr1l31Q==
X-Received: by 2002:a50:a45d:: with SMTP id v29mr13284631edb.284.1595072199959;
        Sat, 18 Jul 2020 04:36:39 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id 92sm10977207edg.78.2020.07.18.04.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 04:36:39 -0700 (PDT)
Date:   Sat, 18 Jul 2020 14:36:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] docs: networking: timestamping: add one
 more known issue
Message-ID: <20200718113637.iszcawncnm4ujksc@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-3-olteanv@gmail.com>
 <5af0fd85-9e09-e5a2-fc99-d72b8a31cc0d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5af0fd85-9e09-e5a2-fc99-d72b8a31cc0d@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 04:08:03PM -0700, Jacob Keller wrote:
> 
> 
> On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> > Document the fact that Ethernet PHY timestamping has a fundamentally
> > flawed corner case (which in fact hits the majority of networking
> > drivers): a PHY for which its host MAC driver doesn't forward the
> > phy_mii_ioctl for timestamping is still going to be presented to user
> > space as functional.
> > 
> > Fixing this inconsistency would require moving the phy_has_tsinfo()
> > check inside all MAC drivers which are capable of PHY timestamping, to
> > be in harmony with the existing design for phy_has_hwtstamp() checks.
> > Instead of doing that, document the preferable solution which is that
> > offending MAC drivers be fixed instead.
> 
> This statement feels weird. Aren't you documenting that the preferable
> solution is? I.e. "Document this preferable solution: Fix the offending
> MAC driver"
> 
> Or am I misunderstanding what the issue is here?
> 

You're right, it looks like I wasn't thinking in full sentences at that
particular time of day.

> > 
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  Documentation/networking/timestamping.rst | 37 +++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> > 
> > diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> > index 9a1f4cb4ce9e..4004c5d2771d 100644
> > --- a/Documentation/networking/timestamping.rst
> > +++ b/Documentation/networking/timestamping.rst
> > @@ -754,3 +754,40 @@ check in their "TX confirmation" portion, not only for
> >  that PTP timestamping is not enabled for anything other than the outermost PHC,
> >  this enhanced check will avoid delivering a duplicated TX timestamp to user
> >  space.
> > +
> > +Another known limitation is the design of the ``__ethtool_get_ts_info``
> > +function::
> > +
> > +  int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
> > +  {
> > +          const struct ethtool_ops *ops = dev->ethtool_ops;
> > +          struct phy_device *phydev = dev->phydev;
> > +
> > +          memset(info, 0, sizeof(*info));
> > +          info->cmd = ETHTOOL_GET_TS_INFO;
> > +
> > +          if (phy_has_tsinfo(phydev))
> > +                  return phy_ts_info(phydev, info);
> > +          if (ops->get_ts_info)
> > +                  return ops->get_ts_info(dev, info);
> > +
> > +          info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
> > +                                  SOF_TIMESTAMPING_SOFTWARE;
> > +          info->phc_index = -1;
> > +
> > +          return 0;
> > +  }
> > +
> > +Because the generic function searches first for the timestamping capabilities
> > +of the attached PHY, and returns them directly without consulting the MAC
> > +driver, no checking is being done whether the requirements described in `3.2.2
> > +Ethernet PHYs`_ are implemented or not. Therefore, if the MAC driver does not
> > +satisfy the requirements for PHY timestamping, and
> > +``CONFIG_NETWORK_PHY_TIMESTAMPING`` is enabled, then a non-functional PHC index
> > +(the one corresponding to the PHY) will be reported to user space, via
> > +``ethtool -T``.
> > +
> > +The correct solution to this problem is to implement the PHY timestamping
> > +requirements in the MAC driver found broken, and submit as a bug fix patch to
> > +netdev@vger.kernel.org. See :ref:`Documentation/process/stable-kernel-rules.rst
> > +<stable_kernel_rules>` for more details.
> > 

Thanks,
-Vladimir
