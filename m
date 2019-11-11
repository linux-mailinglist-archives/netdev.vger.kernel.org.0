Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CCBF7432
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKMkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:40:36 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42595 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfKKMkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:40:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so14439377wrf.9
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j5rxIYJKfxse8jYsq7amhSSj0SDzdbqjxTLA6qXTSd0=;
        b=qeAY6HEWPJlp7S38hlFaC8gf2EyTvv9mtm1Zq3F2HEIYUAfWZYeBR3gWNA59SOnaeu
         9Na+xqT5VTl4nsGUrmnGQgnMqfilpmz1w7mgZ5RqlzSCwxPbeHrkF1T+rE/Wftj/tCd/
         yImuS+DvV19F4ThCyj2Kv4r+JhE00cYKLyuS6E3kJ2MXa+2hwbUyQHUt8hM9KpJSwGY+
         lYjUb68HIcXzDVrX0V2tlTW+2w9APm+n9twJk1NMyPWFZxChUU+Y0G7jRfVdU2x5pRAk
         LGdd0icAu2RQuV2QEbLww2EvyPwVGnPV5BB7fmDeOeIw5Okva1LAsGQZRtQgjPqRwdQF
         AL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j5rxIYJKfxse8jYsq7amhSSj0SDzdbqjxTLA6qXTSd0=;
        b=MP4y+bsrUKIOrxLCGNBaOTpr4YtV1761+wmFDuatDTUpd3m9qQA+eTzETA3ETsUupt
         eeZoR5dUPagJApWwtOgHs4GZZrEcVk23UmSIIEVupaWw+fwAOQpjyw/Ww82jjvpQt5HB
         ka+nHNkOPC+cMuYH7TsUbtJLbw9gItm6rfunLbx1dPtcbD71kesg/IbdjyGGzrM5lDoB
         kQaaHTbKbqW0ef5EdfkYcHjQn66dg9qBdT/wiprjhsI3WFeCUvqH2vC9CcjlBeTBqjSh
         h5Yb+kWegPnNwLfWj/eNoNEOYhVpeedzlwKN9DswAhRx2PDuW/0avf5J/92vL1eyoOCg
         oJIQ==
X-Gm-Message-State: APjAAAX1o8W4W+cYqvlj2K2j89/eyTv4hR2D1q5geWR+2ptigNDTelBy
        vL+aw8ToZo+VXNrC2vXrgqO1JA==
X-Google-Smtp-Source: APXvYqxbkDLvOsgCBNFeZQdkTivxR7kZ85wiTncIdqKVYbmcdEoX0n7rZTf0Xi2/8Fck78GO8DF2RA==
X-Received: by 2002:adf:a553:: with SMTP id j19mr16514106wrb.184.1573476034095;
        Mon, 11 Nov 2019 04:40:34 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id 4sm17534497wmd.33.2019.11.11.04.40.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 04:40:33 -0800 (PST)
Date:   Mon, 11 Nov 2019 13:40:33 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] lwtunnel: get nlsize for erspan options properly
Message-ID: <20191111124032.6xtffevcxr7wacgx@netronome.com>
References: <ec64223f823f0915d6ffe0952944263a591a5623.1573359678.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec64223f823f0915d6ffe0952944263a591a5623.1573359678.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 12:21:18PM +0800, Xin Long wrote:
> erspan v1 has OPT_ERSPAN_INDEX while erspan v2 has OPT_ERSPAN_DIR and
> OPT_ERSPAN_HWID attributes, and they require different nlsize when
> dumping.
> 
> So this patch is to get nlsize for erspan options properly according
> to erspan version.
> 
> Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

