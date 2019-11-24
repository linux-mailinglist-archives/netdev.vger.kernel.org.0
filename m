Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8350108562
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 23:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKXWp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 17:45:57 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39380 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfKXWp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 17:45:56 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so6286946pfo.6
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 14:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zmLK0rFFfYiHSW3DsZBQW692cSHm7fyRWmpu+4t626A=;
        b=bdRie+N5N4oS6/8CLqHV1EVLmoOJJz4A/838TvK7y8t3cbN7n0f5IGuZN9ZQLaI0vg
         q7V03R6oXKcT5L47vH5KugCiMAVX6yIjDnOJ4ShyZVBfd33qi/mg2Rx+uWy4s4xS0+0i
         ykd+55VOeNhlu34+LSOJmlpydMUyCqZ1ESaLCdaDL9LO6WUpUstPusiDjHlL9ltGkhT8
         tACMDNVIIFBYUZdfV1IQLEH5gFCvw3vMahlVKsxCJamFK12cRa2vsM6M+yGYThB1yYQO
         w5X9ZrH7Y46/bNA9An4j0FJO5x56n2eOZnXmgwnhIIWnm0nTP/p2iQ45TPxzxPSBNGuK
         TrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zmLK0rFFfYiHSW3DsZBQW692cSHm7fyRWmpu+4t626A=;
        b=boCvmQYJf/QHslNYPJ53jagRKRBgmbxSYHHi6MEYligiqnOlGYTByV4fG0R/kt21MN
         ri2LL1pvoI6HaGgNMWuPRkpBNcIZXrKaIu25rNanOfBK0rWkaQ7a1hm1brnXAI8j5+9I
         CSGzZArSucV+6J0xQJx/GomKNx5bO0vrSwZIiEBtB16i5hJXe+6PfRGRJnt52BmyqjIk
         2BoOsrizG9gKNA7gAhex/o6uTvgJQpTUhpA8lH3rbHaFyQIcmkqzBe8Vue+tByySfKxb
         ucuBrqM0K8o0h3Kp0cD4et1PVOU2acktCQq2SDBbF06GHKA3o2nMAkzTQDPxixTULmtr
         7a0A==
X-Gm-Message-State: APjAAAWkREA8+G/FkHsVlhyN5XW5//EVeKtCjd6w2TOPOoggqbLQMNlL
        zcPKde6g/A1f0Jcxp3LNPQkvFw==
X-Google-Smtp-Source: APXvYqwMKvvcq8Qowo5DIhfsHqq5K0cKTVwVrPRJAqMNTUUWS+CN9AxRkncpvJWtCTLKwLltDCbogA==
X-Received: by 2002:a63:5a1b:: with SMTP id o27mr29351909pgb.251.1574635554565;
        Sun, 24 Nov 2019 14:45:54 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id a6sm5768981pja.30.2019.11.24.14.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 14:45:54 -0800 (PST)
Date:   Sun, 24 Nov 2019 14:45:47 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     ecree@solarflare.com, dahern@digitalocean.com,
        netdev@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] sfc: fix build without CONFIG_RFS_ACCEL
Message-ID: <20191124144547.748ca04e@cakuba.netronome.com>
In-Reply-To: <20191123174542.5650-1-jakub.kicinski@netronome.com>
References: <964dd1b3-b26a-e5ee-7ac2-b4643206cb5f@solarflare.com>
        <20191123174542.5650-1-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 09:45:42 -0800, Jakub Kicinski wrote:
> The rfs members of struct efx_channel are under CONFIG_RFS_ACCEL.
> Ethtool stats which access those need to be as well.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: ca70bd423f10 ("sfc: add statistics for ARFS")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
