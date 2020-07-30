Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1402823360B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgG3Pxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3Px3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 11:53:29 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DE8C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 08:53:29 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g19so1956658plq.0
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 08:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J0e6V4BinGIzSmoIp553xeW7bz1hi+7kbQBHRsbuQVA=;
        b=J7Gduxg/bKJmKTwyFQ53pnw1cPAmeQ/6PP4laumZqDrqSttTBnZ1ejO18Z/F9URbOy
         7ULt9PUoJ54i/Rmf2DCWWlCH2WpJKx4wNuJsanPlgg3/1kttwOxM7Z3crTvLbzYZvzXM
         ZT1PVpyDk890w7GCuaxZXiVgAo+MDaW0j9OKJFgPZX39a0JHBgJp2B80abQrTQXvSIF1
         Y75wiihTwlSv1aLEd8GKRX6ka8tKTmASt34oIumZeknnqWdMmoXzLJVkCtvg4KnoHkRA
         SAfZZTDcO1INgLABTZ761WCfeIeBc4WIbdxnQnjlXI5uXlVLsLcpgr+wXqpB+K+6PQ48
         Ga6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J0e6V4BinGIzSmoIp553xeW7bz1hi+7kbQBHRsbuQVA=;
        b=P/z5pP8gwTb7ClLnF9Pf0Wr9BmzHnZd9rN1lmSXSvNNKhrENmKBtX+bvP7uZc2AHae
         uFELKv9xDdqsVuN4H6fa+2zW0l4lTbrHPx1Ll0/7WffCy1045/xGxmdOmaws7uBpuTLa
         nzd+/xej/dVjBxf+FGx0WeVYCHIQSnGT6QYhRCkufNaH1ygzT2yCAqaTmOX2AxsfJc2A
         Xtk8SUqPOrRiiJMBi/SRB/iD4mr47nkZU7nUEIWlRWuecaJgeg9hAq2mWKg2VFsMV0ef
         62b6LII9cfuY6Zg0kv5mGpREw1e7BwS1Jhuh2Hgc3CcZsYmkdjZIi8ItY5VQz8e8NOcJ
         qclg==
X-Gm-Message-State: AOAM530gOHUEt3wMhuZ5upFXYahgf71wfl0zWipye5L28korjkkgnGS6
        7wV/hISQ6eOIlxZjU/p5Y8I=
X-Google-Smtp-Source: ABdhPJxGZpUAT+V7pmBMLbVcvNfrzMkvdxo2v5qUsEVw7zCEjdYEwRHJLNN31uP6DaT7xbqAOVDhbQ==
X-Received: by 2002:a65:6403:: with SMTP id a3mr35805355pgv.246.1596124408994;
        Thu, 30 Jul 2020 08:53:28 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c30sm6670056pfj.213.2020.07.30.08.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:53:28 -0700 (PDT)
Date:   Thu, 30 Jul 2020 08:53:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200730155326.GB28298@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200729132832.GA1551@shell.armlinux.org.uk>
 <20200729220748.GW1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729220748.GW1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 11:07:48PM +0100, Russell King - ARM Linux admin wrote:
> What I see elsewhere in ethtool is that the MAC has the ability to
> override the phylib provided functionality - for example,
> __ethtool_get_sset_count(), __ethtool_get_strings(), and
> ethtool_get_phy_stats().  Would it be possible to do the same in
>  __ethtool_get_ts_info(), so at least a MAC driver can then decide
> whether to propagate the ethtool request to phylib or not, just like
> it can do with the SIOC*HWTSTAMP ioctls?  Essentially, reversing the
> order of:
> 
>         if (phy_has_tsinfo(phydev))
>                 return phy_ts_info(phydev, info);
>         if (ops->get_ts_info)
>                 return ops->get_ts_info(dev, info);
> 
> ?

I don't see a simple solution.  I think no matter what, the MAC
drivers need work to allow PHY time stamping, and the great majority
of users and driver authors are happy with MAC time stamping.

Thanks,
Richard
