Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8367E3379E0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhCKQrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhCKQrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:47:16 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE70C061574;
        Thu, 11 Mar 2021 08:47:16 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e7so3789213edu.10;
        Thu, 11 Mar 2021 08:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SX756dXupgS3itIHiEP07yjhdJyqc8DqtHCMzdh6MRo=;
        b=R9wg2pKVwClt4BFKX1kiHQ7mq/v3644NmsFSa2zgKZ+Kb6OrNqbR1V1dZy4zL9R4vu
         vLMpqQSxTBlMZ0t/6N8aPfWVUXykG8YcWk0cWKX5MjKRhlS5NRIPvZXyMMDi4jscxqz/
         Ev7aGxqArVCDT9/XzGEjphh8HcBIwqNdVQiYor0aMMM6FsRRoVyxr7przjyqcmb/yZZ5
         bAF5A6qjeby9EVZlPG8s93Tn0GDu0gFPp5KYkw/Y2sfLbuADksNLa5FtZtHW6Q2vU+hF
         dK4aXpg8pk/WBiV8F8x3swUMS0Y9HNodZkXwttw7rBQElyG32sI+RbnGR4qBoYUBGMcb
         LRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SX756dXupgS3itIHiEP07yjhdJyqc8DqtHCMzdh6MRo=;
        b=umKiWjJpHPSOeE9gFN8oLZqGbMKg8dT1J+H5zgtXB2T2NF5MH2TcZskUc5J7THSKmK
         5E2qmhRpldFefMlChABbjdQ1/n/1z/oNJHWwyZSTYzRy3MRxrtUlFvlHxh9gfePb3Q/U
         7Vt5rXiblHQRp0F6wP4kngJIlLTq7Qd0GEb+ndiLetE8/wQfZsKrA5RlgnF52T8X79BK
         JZGWykkagiVbo9DHudrYe0JGZ43NB8jEsmMa/oQeUN2PHKhhc1q4F4vVuhGdALNwFq+5
         BU1+PyWBfFar9jg99RBFn8sKKl/0W1k/+aF6PBqAhkIwtadmDAX/0F5GAkm+0xKH9r+A
         X/0Q==
X-Gm-Message-State: AOAM532I1mh+m5ZYI30mIoJKaIlmbVoPpyncq7m6FHNO1azZhFOloFMo
        uOTcWA/tLozL+92uE2h9XnI=
X-Google-Smtp-Source: ABdhPJzbvJBnHK734cKDjR2nu98P9RPcWwwdIsl6VSvtR5afUwQr00mWWgTTX1afwARu8pPC3xNBhQ==
X-Received: by 2002:aa7:d656:: with SMTP id v22mr9302062edr.119.1615481234980;
        Thu, 11 Mar 2021 08:47:14 -0800 (PST)
Received: from BV030612LT ([81.18.95.223])
        by smtp.gmail.com with ESMTPSA id da17sm1578584edb.83.2021.03.11.08.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 08:47:14 -0800 (PST)
Date:   Thu, 11 Mar 2021 18:47:11 +0200
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     Philipp Zabel <pza@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210311164711.GA892053@BV030612LT>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
 <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
 <20210311064336.GA6206@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311064336.GA6206@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Philipp,

Thanks for your quick review!

I will incorporate the indicated changes in the next patch revision.

Kind regards,
Cristi

On Thu, Mar 11, 2021 at 07:43:36AM +0100, Philipp Zabel wrote:
> Hi Cristian,
> 
> On Thu, Mar 11, 2021 at 03:20:13AM +0200, Cristian Ciocaltea wrote:
> > Add new driver for the Ethernet MAC used on the Actions Semi Owl
> > family of SoCs.
> > 
> > Currently this has been tested only on the Actions Semi S500 SoC
> > variant.
> > 
> > Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
> > ---
> [...]
> > diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
> > new file mode 100644
> > index 000000000000..ebd8ea88bca4
> > --- /dev/null
> > +++ b/drivers/net/ethernet/actions/owl-emac.c
> > @@ -0,0 +1,1660 @@
> [...]
> > +static int owl_emac_probe(struct platform_device *pdev)
> > +{
> [...]
> > +	priv->reset = devm_reset_control_get(dev, NULL);
> 
> Please use
> 
> 	priv->reset = devm_reset_control_get_exclusive(dev, NULL);
> 
> instead, to explicitly state that the driver requires exclusive
> control over the reset line.
> 
> > +	if (IS_ERR(priv->reset)) {
> > +		ret = PTR_ERR(priv->reset);
> > +		dev_err(dev, "failed to get reset control: %d\n", ret);
> > +		return ret;
> 
> You could use:
> 
> 		return dev_err_probe(dev, PTR_ERR(priv->reset),
> 				     "failed to get reset control");
> 
> regards
> Philipp
