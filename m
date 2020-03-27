Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E835195DF3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgC0Sxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:53:48 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50258 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0Sxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:53:47 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so4249444pjb.0;
        Fri, 27 Mar 2020 11:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zz8pZffXcuHzcOzs7yUrmrfernHqa//RXyP98eRdT88=;
        b=cvMCryScSbQdTRMTKEX6uqFsGst+mTtHrahGUubzKFyKJvqSTCnMdFB915495iRvNv
         9V0rFw0bvk3/2aOPbokyBaogNTkwE92D3/aFBL7HQNFR/gBl/BEg1zVV4ou+hzGiutxK
         j20HdyOQw0/5UY0ykVgjh1Hk3/Flzwkaee5qEY+ASi6g4Ez0P4tGXuHwPuoYzZmrS4+Z
         byUOQL4ad/B+jFLIdA9h2MPrSM0oEgbyOz5tEtt9cLatTSzY8qrF/aUVzGpB7VGZoGzD
         cQr1PXDp4jvE36Mc1ucKwktqn0HE+8McDCaE2MBWMAK3TjY5XGIlkClOdBCSP1lsg3Us
         G4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zz8pZffXcuHzcOzs7yUrmrfernHqa//RXyP98eRdT88=;
        b=tiJO7QyMVkNhkCOhEXVTt6+0KF0SJcedFTY0WujOVBHW96JWv6MqNiY0beBfhbdlBL
         uH8wpPrKWZzKJwcQK/qqCg/8QHNE9ztx691kfO4YIDO1XxXJcD5dORvG2Fkk0udBSbf3
         P267R5WIr2WkgK/aBJwupGXQVQjo4yaT3UnmZmA8ifgQZsuQ/DUcc/4DvOHnYgcmZsm6
         CZPvaMXF32FHXyXDPRU9Q7CNw4vtZCakNbzETFvxONsDYIIA6loEDUGl+l5vIaMbQOEH
         14aE2+i4UeV1pDauXNQ3lBvJGJDlO/IG6hzU2No5zQpI92+zbjUVWCGJb4EpTr7aPjBA
         jUVQ==
X-Gm-Message-State: ANhLgQ1eIofOO6TLF2subIbmgAWEj2w3XToOujHf0YAnr3dctXK0Tm1U
        04TNCPrI4T25txBrJooRkkE=
X-Google-Smtp-Source: ADFU+vtSCkGSJRaZ60+Eh0o5MWVEcjGwR1ddOfdGV7PV5UWlOJnh9wHkb4tMp9KZ38zAT9TJzqGBvA==
X-Received: by 2002:a17:90a:9e9:: with SMTP id 96mr889366pjo.168.1585335226872;
        Fri, 27 Mar 2020 11:53:46 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e184sm4626002pfh.219.2020.03.27.11.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 11:53:46 -0700 (PDT)
Date:   Fri, 27 Mar 2020 11:53:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 11/12] ethtool: add timestamping related
 string sets
Message-ID: <20200327185344.GA28023@localhost>
References: <cover.1585316159.git.mkubecek@suse.cz>
 <9115b20867b6914eec70a58f3ba3b9deef4eb2b0.1585316159.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9115b20867b6914eec70a58f3ba3b9deef4eb2b0.1585316159.git.mkubecek@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 03:08:12PM +0100, Michal Kubecek wrote:
> +const char ts_tx_type_names[][ETH_GSTRING_LEN] = {
> +	[HWTSTAMP_TX_OFF]		= "off",
> +	[HWTSTAMP_TX_ON]		= "on",
> +	[HWTSTAMP_TX_ONESTEP_SYNC]	= "one-step-sync",
> +	[HWTSTAMP_TX_ONESTEP_P2P]	= "one-step-p2p",
> +};

Suggest "onestep-sync" and "onestep-p2p".

Acked-by: Richard Cochran <richardcochran@gmail.com>
