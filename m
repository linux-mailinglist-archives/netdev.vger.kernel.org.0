Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863F61376FE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgAJT2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:28:23 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:33207 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgAJT2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:28:22 -0500
Received: by mail-qk1-f180.google.com with SMTP id d71so2985663qkc.0
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 11:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ka7eW2Y9Zxs9wyCkyRe5VZvVsSN3HVpNGdyGkx4YMVY=;
        b=dGoyXuQXUV06VB42Xp+KxDurtoGV5ySTsau7PP7nAUXrHxvabuXJf5Wp4UM2dSY5B4
         6vFjnPT6GDeWi46grL82ta11etxFvetsVfuZ5aJEBwIMUlW2WPD3h67cXOue4n06DWqw
         b5DHmU6TYameWgOPyFTQ1iUjPg5Hq/X+qAxgHgpHvXi4FHFdQCDsn2z34GKFbf3eszVu
         bS7JbZmuYqnNR1tLJIAgK01nLngPe092jvtix+WAPiAEronHbXFYRgqRYfEQMFgMRCDo
         WW+N5FQ2tW9UCcG/B8sqnqB4tzVih3LuC/PrIAOzhzPWM/nfEwhcSY21eKzK5XyUFpws
         33Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ka7eW2Y9Zxs9wyCkyRe5VZvVsSN3HVpNGdyGkx4YMVY=;
        b=AgretqbE0fbaSmrkfnBxcOFkbkpEkc0atTGdDDB5wyrVwpVq9d1Ou7hL/xtSX0Mj64
         gaaSWe/vmL64CXxgONnvKOH8W0uD5Kc8hKf+Cp2qzhs9SRT//mVHaUSvXq3gD35l+aKW
         aFXjdGIPu2uRPUb77PjNWlHOIY2y0k1krU4L6XqOkOk5vXsCRsXHP432a1GLRt11myrP
         IyLTOQT6NuiENO44j9YnsI/Tkkd9nKSnAYZcfJZak6mjg+pGKt4n99bpzA7ftI2hjIXr
         5gD4javohMi8zfibp09OTb/unV/LG/EVg0AtHlLGRCQECmCAWnpW6ueahgZQEzrLsBoo
         Px6Q==
X-Gm-Message-State: APjAAAXFQiy+ZZd4I9njjDTCXjaMQonQr9WpOq/op4YLF4275yKb8wY+
        oTOAuyby/XiyxbE3/3ITNNYsMQ==
X-Google-Smtp-Source: APXvYqzXuGPufIpDPpXfLJLpxLRCsAxH2+TAUl9FomPiIMBPjShbkY27KqCwuSaNPs/0KyEeXI9oqQ==
X-Received: by 2002:a37:5b41:: with SMTP id p62mr4833065qkb.442.1578684501853;
        Fri, 10 Jan 2020 11:28:21 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w20sm1512273qtj.4.2020.01.10.11.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 11:28:21 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:28:18 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 14/17] octeontx2-pf: Add basic ethtool support
Message-ID: <20200110112808.4970c92e@cakuba.netronome.com>
In-Reply-To: <1578656521-14189-15-git-send-email-sunil.kovvuri@gmail.com>
References: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
        <1578656521-14189-15-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 17:11:58 +0530, sunil.kovvuri@gmail.com wrote:
> +static const struct otx2_stat otx2_dev_stats[] = {
> +	OTX2_DEV_STAT(rx_bytes),
> +	OTX2_DEV_STAT(rx_frames),
> +	OTX2_DEV_STAT(rx_ucast_frames),
> +	OTX2_DEV_STAT(rx_bcast_frames),
> +	OTX2_DEV_STAT(rx_mcast_frames),
> +	OTX2_DEV_STAT(rx_drops),
> +
> +	OTX2_DEV_STAT(tx_bytes),
> +	OTX2_DEV_STAT(tx_frames),
> +	OTX2_DEV_STAT(tx_ucast_frames),
> +	OTX2_DEV_STAT(tx_bcast_frames),
> +	OTX2_DEV_STAT(tx_mcast_frames),
> +	OTX2_DEV_STAT(tx_drops),
> +};

Please don't duplicate the same exact stats which are exposed via
ndo_get_stats64 via ethtool.
