Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D72DC483
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgLPQnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgLPQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:43:31 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F34C0617A7
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:42:50 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j16so3097804edr.0
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7IfwjPXNbds65Qu7WkCeEnP0S6DCdgGm1djJwV6FDTQ=;
        b=Fis40suEV4DcECcn5ELx3xHiIudy+U/j/NVCm68l9PtTJhTvtk9CuX3E50S19sPet3
         L0LjVph8vm0YhkcGZEs7m/hd/qGrFgh8xZbMDuWxRD40Jy5JcYTAA+Ror3oKH0wELoaw
         bghcvRoiDfn5YtZHWOw+r+j6Momd0ASDxRMBHkUdw9MOqQ1Hz56mBQQ96ebFUFJNaFcW
         tHnVCRUBmF7qjAwCfgZGhQT2/QmET5ZdvMwAQEwasB8CSJo+eOULq1WCBNGfBvp1B6cA
         S5NjRSY+wQ/obiPQ+FoPlGaFQLKwQQ4SHeNB45Zy83eHNb3+Cd+DoHII7rfw+PG3almS
         AKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7IfwjPXNbds65Qu7WkCeEnP0S6DCdgGm1djJwV6FDTQ=;
        b=gpRHBwaW7HSu6ueLS6ADLrnEflZOR58+UtQG5VTIbkROf7H4Heodo6GHqndq4WjiTN
         mZbnjqwwI+L4X+1jIOTtmnzgVxTFJdpHnjmelyg+GwDiTNiOg4Xr+Wzh1WgD224wwymF
         m1xdJ3NASnszOD3NSFWfxoMon6RHhCU3RxX9nkyJpKz/1LDyckK1PsaPOJdEUZLNyJ+J
         2bozGXsoMp+1pXS8caOYgqAC0+LEXeKV/aQE5b/bffFC3RfM/4GtxBToZtbD4G3uxYp8
         MNQGBkBpFiB1yCO9RbzmsM7vF25ULIrHfyN+Kn0rZbR9NqFKkbRapNsJfof/xpJUVXWq
         9fKQ==
X-Gm-Message-State: AOAM533/mATFq5dSFTeu1BYudNQOAi6QdFiGHpZoOTuu5osQVNWqB8+H
        celED1jbn0GxkZqAf+CaxKk=
X-Google-Smtp-Source: ABdhPJwBSOXvBb32elbWPMNmKVMF8eMtdj+l0JCymH99wD3kCWcDwRsOrsm+V79+tq2Zgocf1Fk1kw==
X-Received: by 2002:a05:6402:1a54:: with SMTP id bf20mr34755809edb.65.1608136969337;
        Wed, 16 Dec 2020 08:42:49 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id j7sm22190031edp.52.2020.12.16.08.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:42:48 -0800 (PST)
Date:   Wed, 16 Dec 2020 18:42:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: net-next is CLOSED
Message-ID: <20201216164247.dyss26ivjxffrhgo@skbuf>
References: <20201215091056.7f811c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215091056.7f811c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Dec 15, 2020 at 09:10:56AM -0800, Jakub Kicinski wrote:
> The 5.10 PR went out yesterday, you know the drill.
>
> There are a few things (Vladimir's DSA+non-DSA bridging series, mlx5 SF
> patches, Intel's S0ix fixes, Octeon multi-group RSS, threaded NAPI)
> which we may include in the Thu PR if there is enough confidence.
> Any other new feature should be posted as RFC at this point.

First of all, congratulations for surviving this kernel development
cycle :D you did a great job and spent a lot of time reviewing code.

From my side there is absolutely zero urgency to send another pull
request with the DSA features that did not make it in time for the first
PR. I am happy to resend whenever net-next reopens.

Thanks,
-Vladimir
