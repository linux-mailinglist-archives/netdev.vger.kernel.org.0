Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B041710E2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 07:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB0GTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 01:19:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34433 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgB0GTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 01:19:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so1862022wrl.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 22:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QbTNg4JcCKul6HQtrZY6ibXpxgZpO/X+l/jfs1a5tYU=;
        b=rta/krBlQ6JI3V1DbHyHkcZvhNmoJ8+6EtNhfDzL0L62+qMk7PkuJWuWMvizkJq7OI
         XXeWWLEIDrxM2qzPQJqS5JE3FrQU0wOy8nd16ZfnkLgut5zRM2bn6D9X8ffTiE1d2iLA
         lUq1xEWVsuzY59GSxZ6dAVN8PoWYM+hcy5mxh70hvonmFF3Hqca+GqSeKFkY1m1tl5qp
         56jX+A79hRPCwG4k6KOrtODpsHwlrm+6ItgWOh9fsTrZOVZzghasXKKzHRunSftEC34u
         b7JDExLtrHaKlC/U3ehpUfh3DY0j7GkWa3wZeBqEcnJhn7/XlxIVVjy988B0wcdJpdcG
         PfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QbTNg4JcCKul6HQtrZY6ibXpxgZpO/X+l/jfs1a5tYU=;
        b=nBTZGQEBDWVoI4S+9Vsn7qlhRRCvDexEHIEA2HPRGGl6UGs+jRT8THJFanNBs8f2oY
         qrs3FkrY/KieE+04+8EGlYr7LNdTO/n1YFUXNMhBgMmwyac0e7BxO/k7aR2/ZHQfhEGv
         PPoOzKHGjOOlNQQnbRHVSzzqbh8t+P4Q1uEzmlYOQVOor7SZ6+Lhm0Ij6yRquehq8+kk
         zv4MCzZx2guA2XKuDoNJFnvK+MlM/laeEQLPnMn6+08JsG5qoY1M1qTWOJTsNmIQpQwN
         g2Te2q6cIDxWQY/u84noDgt2yL8UMdiTnwQVD6iLc8pMjdmy4uhCRw4ILUfHKjvlIXTN
         RZDw==
X-Gm-Message-State: APjAAAWIrbzF0yPKTXU8yRX893+NE2c3Y/7tznB9c5/lNCplKnH+h130
        olWOhVMLh+9rsnCVoCmzvImtC7V8jek=
X-Google-Smtp-Source: APXvYqy1s5/nfRd3TNHfmqK4J1KT2yxPm5ZmCQA0BDb6x3brUVSEkE0Bj8YVstfF1qGMqz4zqsV8Rg==
X-Received: by 2002:adf:f18e:: with SMTP id h14mr2768007wro.51.1582784371959;
        Wed, 26 Feb 2020 22:19:31 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id v16sm6244332wml.11.2020.02.26.22.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 22:19:31 -0800 (PST)
Date:   Thu, 27 Feb 2020 07:19:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, ayal@mellanox.com,
        saeedm@mellanox.com, ranro@mellanox.com, moshe@mellanox.com
Subject: Re: [patch net] mlx5: register lag notifier for init network
 namespace only
Message-ID: <20200227061930.GD26061@nanopsycho>
References: <20200225092546.30710-1-jiri@resnulli.us>
 <20200226.165048.2228405992426450518.davem@davemloft.net>
 <20200226.165239.940350760077316036.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200226.165239.940350760077316036.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 27, 2020 at 01:52:39AM CET, davem@davemloft.net wrote:
>From: David Miller <davem@davemloft.net>
>Date: Wed, 26 Feb 2020 16:50:48 -0800 (PST)
>
>> From: Jiri Pirko <jiri@resnulli.us>
>> Date: Tue, 25 Feb 2020 10:25:46 +0100
>> 
>>> From: Jiri Pirko <jiri@mellanox.com>
>>> 
>>> The current code causes problems when the unregistering netdevice could
>>> be different then the registering one.
>>> 
>>> Since the check in mlx5_lag_netdev_event() does not allow any other
>>> network namespace anyway, fix this by registerting the lag notifier
>>> per init network namespace only.
>>> 
>>> Fixes: d48834f9d4b4 ("mlx5: Use dev_net netdevice notifier registrations")
>>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>>> Tested-by: Aya Levin <ayal@mellanox.com>
>> 
>> Applied, thank you.
>
>Actually, you need to respin this and fix the following warning:
>
>drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: In function ‘mlx5e_uplink_rep_disable’:
>drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:1864:21: warning: unused variable ‘netdev’ [-Wunused-variable]
>  struct net_device *netdev = priv->netdev;
>                     ^~~~~~
>
>You can retain Saeed's ACK when you do this.

Okay. Will do.


>
>Thank you.
