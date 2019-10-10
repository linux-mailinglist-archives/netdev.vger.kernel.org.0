Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3054D2D9E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfJJPXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:23:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50794 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJPXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:23:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so7418175wmg.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 08:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qDz+r4rM94VL3+Pl5xzdTOjfOO1RdD3vAbbm0BQ2hHI=;
        b=AvvoG/BsjH8RyUfVf8qxu9E8+6nBME5ejysBka+LWWdHaophcj951/cLzlbdzoGi7m
         gncEsje2qdJsbuQDMyUKEsHahQF45XYIBaw/JxHTfMEu7RnUNGZHjp11WFF+ABFIyULU
         47f1KrwwzO2d27shcf6fYNMlzt3ATuNEAyRNkBfXmzoth6dN6Kl8MuQJi516+Hwpzq29
         7QpTfWmNKyUuVDHQM7fYIg9NQGqLhdIT987WN61jimmIrPHdPndhd669qkd1EdgJQaL6
         LpIkZQahdfVwCXWu+TH40v1xgFtVFmdPPgY0EnQvUamqDrwFnkN8xExmOSk4EmoInsme
         jeuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qDz+r4rM94VL3+Pl5xzdTOjfOO1RdD3vAbbm0BQ2hHI=;
        b=puNYsJVmTevvvNyS3oFdPQHLHi7wPHxY/SDJL+XEHHLpspUoYnFn7rLg4SoN803mz5
         IBSafGdY3rr+hGQzdq7eXaq/L2pRqwiQMy1OWO7QfKVLBnxDISe8pAKWROYmpLbPymTZ
         Uj+JIPq3eYcokiPbpPzp/CFLJTbyT77KKrd+3POW5wVQF9eKYGrkoYzK/O1pvIshfiDQ
         R0Ata1U/fWMK2yKke3L3gjLPbqDzGM3ZdxQicLPy/XYX1D9pTNAM3ZOvrE+3qtAzOm5d
         DV+r37apkVmfI9KUyK0rHJqgBx3HZAnacXizV1u8I6NCFc0dusdTMp+gfx7lKoCaoou7
         5zhg==
X-Gm-Message-State: APjAAAU9u8ZxyBir9erfUZHA7cudJ3g5QbXCRCOZf26XPeTREf0GA89v
        WxbFCh5rBGM2hQnN6jHiLe98vw==
X-Google-Smtp-Source: APXvYqw3Ud+Ro98c+TTzCOdXnjL0w7AL/IQDWdsh2/DyNRPzCEiNBX/grfAVzOVYXuihjhT9E88tjQ==
X-Received: by 2002:a1c:2d85:: with SMTP id t127mr7765333wmt.109.1570720988703;
        Thu, 10 Oct 2019 08:23:08 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e3sm6028321wme.39.2019.10.10.08.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:23:08 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:23:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 09/17] ethtool: generic handlers for GET
 requests
Message-ID: <20191010152307.GA4429@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:27PM CEST, mkubecek@suse.cz wrote:

[...]


>+static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {

I think that prefix would be good here as well:

+static const struct ethnl_get_request_ops *
ethnl_get_requests[__ETHTOOL_MSG_USER_CNT] = {

[...]
