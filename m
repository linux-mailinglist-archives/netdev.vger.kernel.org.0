Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E289DCBD
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfH0Emz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:42:55 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43353 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfH0Emy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 00:42:54 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so11120983pld.10
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 21:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=e0cVIzMksFbCMSP3f8yt18DwW0l/6CnyyAG1KkhYAOE=;
        b=Fo+L0mF8M6WUJhrFXGifqdcGw/lYPtWgjqiiX/MBPatC/DvHqCUqO/wfuaBFB5TVuE
         G+T2OkYdQZmjcRli7WWOEE+fh8v5wK+o7+e20zyb1qUbiS/RMWsHEYDG0z96cIwuHOlC
         Z3fSPjCSm9DNyqGfI7iHgpOcxF1sRlRkwerSSGqU5Zlxekdbja0t6jRzwEYlAFYfqWSi
         c7brRvrXhB9VzrC0NiU7iN72y+yZNboldpzTJi0FaPP2K6aTkcp6Ix30jMMoq3iTTXBa
         i08ZClpedFfwBtXcIj6f3u+7YwrlxqTsoMrKT8hji9xf48SMOlcsA8ZdYZ2TRvGq5YAM
         dRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=e0cVIzMksFbCMSP3f8yt18DwW0l/6CnyyAG1KkhYAOE=;
        b=nuu2zm7QHfuQLlAA6jowW/U8r7PeB/ee5Xbfkw+mv5wtPqCFrYIxxhmV/XWDVXd4UG
         9AX71MJidGzu+ZVtdX6fT9PZU7SmEreG7PPsrS7fzVdffTD2iEdkm7xmwFWR/hiOKzxm
         XzrKcxmdf56jEMLzViMYQwhpg2GUZPtyGGniS/U3zpHVr3vA/ZtZr1doErVPz6+ukfcv
         tGZ6n3e3aU9w0DXcoy1Cwa04X81xF3K1Zd8/F4WLBPs+iEO+HNc5UM5qgjDjT2ChyGig
         gYhkZx3tpeiu8jRwuaAMDyeStBRD8MhH/y0RWzXQHVy76ymGsKqUnco4RXOPQ20h1rit
         /AhQ==
X-Gm-Message-State: APjAAAVRCzSTFMtwehD5rqhwvANwu1sYD9VoMUMmLvTeqlEXrxvO1epQ
        oYLQi0Qq2DgD/udK+J0M+USCmB4zVy4=
X-Google-Smtp-Source: APXvYqwaqwxExUmVj8U+JMDEA232h7lH1fN6z3d3LBJCrA7OM+gB2bZ7WD94q6FArWsS4Z/nJgVymg==
X-Received: by 2002:a17:902:b285:: with SMTP id u5mr22226124plr.329.1566880974069;
        Mon, 26 Aug 2019 21:42:54 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id a5sm929461pjs.31.2019.08.26.21.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 21:42:53 -0700 (PDT)
Date:   Mon, 26 Aug 2019 21:42:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 04/18] ionic: Add basic lif support
Message-ID: <20190826214238.07a0eee9@cakuba.netronome.com>
In-Reply-To: <20190826213339.56909-5-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
        <20190826213339.56909-5-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 14:33:25 -0700, Shannon Nelson wrote:
> +static inline bool ionic_is_pf(struct ionic *ionic)
> +{
> +	return ionic->pdev &&
> +	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF;
> +}
> +
> +static inline bool ionic_is_vf(struct ionic *ionic)
> +{
> +	return ionic->pdev &&
> +	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF;
> +}
> +
> +static inline bool ionic_is_25g(struct ionic *ionic)
> +{
> +	return ionic_is_pf(ionic) &&
> +	       ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_25;
> +}
> +
> +static inline bool ionic_is_100g(struct ionic *ionic)
> +{
> +	return ionic_is_pf(ionic) &&
> +	       (ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_100_4 ||
> +		ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_100_8);
> +}

Again, a bunch of unused stuff.
