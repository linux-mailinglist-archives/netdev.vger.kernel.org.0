Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F28140BA
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfEEPm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:42:59 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39262 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEPm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:42:59 -0400
Received: by mail-wm1-f52.google.com with SMTP id n25so12216074wmk.4
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p1blnRSis7Q9xqfyqfDOn0XLv0kUXXwvjVK9mpB5JjE=;
        b=g2C4+C09dorl7UQK0EYER2JzX6MU29r0bNwcf/KuezmCdKPTlfYiXQSZsRW0xitSYx
         pktpgK7PeaYdRL6d1+wqHlZ7rWGPMPXKSlyuHl/5qjIcFKFXLj5u8t6moa35MwvdGo83
         RFs20IDVkf6zZDrmR1pvbHoyiJ+MVQxBDcJ95IecuKQWlf2sqidzZl7fX5orZtCegD4J
         i327yxhqo03opUwUPhT/3tG7GHN/i8OL//Mrst4Mt9WHQ6opQ7LvVBjZvK/oqUZM6opn
         iEP5RnH08yCmerTfO11zbUULagLWKaIcxuMf/8pNJX/ywREqZn5rGCvMk0ucIdJORxGq
         GROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p1blnRSis7Q9xqfyqfDOn0XLv0kUXXwvjVK9mpB5JjE=;
        b=PLHZS/kaaukLrprgKN6LPKzRs4N+RKQK/+e3U1bimvSJinjqMmPUgupQN6PhABjsDW
         hNhFX0WOncDU92usEXl8l/4vLEW4G0fMn9QJUhNnNbGMfZdMvzL98PiE/B5602FwotWh
         Y48inHe7MPzdtFYvOZBZSzTb0kr2waDIkIv6ExqcNjQENMj1FDhIPHi9RWAHOHtyUUrU
         iR5BvSYOqghxZQhayZbCtU18xAig6ZiO36owRThwcmyEfnDcT0WUlK7YNNVaXT/uBfPq
         iHJMl26qEojpVSSlt5lUsC/4FDg85dgdK3f39kDzDF4bEKMqIkihw2Gi1X4ZwLGDlYyl
         pU9g==
X-Gm-Message-State: APjAAAXsLdRanD0X3vm2xCNeAlOUzb2Nnql+1cdFs2MeUQNXGvGWRM38
        f4jQHDG6Ka4ait2P8gA6QbmtWw==
X-Google-Smtp-Source: APXvYqztGzOig7hYmLTO58ztW9PNUlFhUmTd1DL+zf4jyObn2QR31sw4mgkgaXX4DZeFWNCPnywRsQ==
X-Received: by 2002:a7b:cc01:: with SMTP id f1mr13046527wmh.78.1557070977751;
        Sun, 05 May 2019 08:42:57 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j3sm6316487wrg.72.2019.05.05.08.42.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:42:57 -0700 (PDT)
Date:   Sun, 5 May 2019 17:42:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 08/15] net/mlx5: Refactor print health info
Message-ID: <20190505154256.GD31501@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-9-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505003207.1353-9-saeedm@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 02:33:21AM CEST, saeedm@mellanox.com wrote:
>From: Moshe Shemesh <moshe@mellanox.com>
>
>Refactor print health info code, split to two functions:
> 1. mlx5_get_health_info() - writes the health info into a buffer.
> 2. mlx5_print_health_info() - prints the health info to kernel log.
>This refactoring is done to enable using the health info data by devlink
>health reporter diagnose() in the downstream patch.

Please avoid this. Leave the print out as it is and format fmsg
properly.
