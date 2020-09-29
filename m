Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCBD27CE84
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgI2NIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgI2NIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:08:02 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8903C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 06:08:01 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l15so6605478wmh.1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 06:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dcBDeC9UZY5u9t3odUMk80sWrSrrcZecc2BWTvMU+cE=;
        b=A9zrKTAi2FtuwtsbDKIoQ0VMgMha/Mqs6MfUzSQw/vSoxynrfeu31aejjaDAw2DHRR
         fPrAai8QAXZJ48a2gJF8UtXXWIrNza8Pv7h9KfpnkR1AcbVWp9Pxk5sNWfGkm1EPhUwB
         3F/tn4LAJs+IuPnObYm98KjH+ZEEcuU3P3Y8TePTGO20uh8gnDUt1XYyXM9EcbyV+Kwc
         ICLWdPaui0btb2SEp7HXZ4YDtM0iO0ohCIkxaraXPvECBbpKxwsmqGWJ0fJRyo61Y29l
         nozceOqgsT+6evM4s+C2uvBJsMFReVFRnUDxPR1dsVw4Pq2aYx76FFC0RJQ6ZVdIptd5
         JxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dcBDeC9UZY5u9t3odUMk80sWrSrrcZecc2BWTvMU+cE=;
        b=os7NliQRKX16Jj0MNg4NFRKFeubK2f6HDk/YubNTJhj+JM1X6piflRQwdrgaa8yyWT
         YRGM/8RaJs7PMw5V0rIjoztn63xWkW0Da8BfBC2FCx91GVv0shYXXPP+AJHGmYP0/VPO
         YM5QGmMY+Qg/5Z/8Ya5j4DoBXOGQNRikYBP97ELRHhsGzKyTeTWoiGVKHX8D4ZNlIv6u
         3ho2OgOlLKE7z785zG+P6Cz3BN9xQH1glXLDxRAeoXT9WvYDKSGbi6bgyOGCiW6jgeC1
         d/bDVdmehLZRndJnH1ofBO102ioyTO+gxjvWiFRkp4ew5wGzKfFaNsFgFu03MkBrzcwl
         HxaQ==
X-Gm-Message-State: AOAM531F2XehFpSU4ZZyEIeESvJ6F3pbJw0qRIUKT6ti+qJcMkuLSs8o
        Y5ixyrGrmjatmfNQKXLw09hXAA==
X-Google-Smtp-Source: ABdhPJx27MjnrnIBcUTtyKKg7pRWjrJVuInYblIvcGFy+cEhesValD/c3xphnm9VsmJI6HXA2Uvrww==
X-Received: by 2002:a1c:2cc4:: with SMTP id s187mr4548170wms.30.1601384880470;
        Tue, 29 Sep 2020 06:08:00 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v9sm6357456wrv.35.2020.09.29.06.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:07:59 -0700 (PDT)
Date:   Tue, 29 Sep 2020 15:07:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200929130758.GF8264@nanopsycho>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf>
 <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929110356.jnqoyy72bjer6psw@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 29, 2020 at 01:03:56PM CEST, vladimir.oltean@nxp.com wrote:
>On Mon, Sep 28, 2020 at 06:46:14PM -0700, Florian Fainelli wrote:
>> That makes sense to me as it would be confusing to suddenly show unused port
>> flavors after this patch series land. Andrew, Vladimir, does that work for
>> you as well?
>
>I have nothing to object against somebody adding a '--all' argument to
>devlink port commands.

How "unused" is a "flavour"? It seems to me more like a separate
attribute as port of any "flavour" may be potentially "unused". I don't
think we should mix these 2.

