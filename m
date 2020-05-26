Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D861E331A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392242AbgEZWwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:52:20 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:46597 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392228AbgEZWwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:52:19 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 11DB42304C;
        Wed, 27 May 2020 00:52:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590533538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUf5XK6R2KfvkP9eLz0vv0T3BRvy2B2hHBQ4hWKx/eA=;
        b=ZNsMK0VIC/TT8DiDSHVWoCKy4YS3ivtrtc1Fwgz3feGkbTu1aB8Gop+0eNVQ351kqsh8hV
        TZSVX0lzcgVB4NVNxW/yOgRlDZJiDFPQMGwtC8WLnuyeNlUTJ3nmq9lMf62Hs7vvNRVLss
        SYA7m5IqQo1oLRPxQ7Rq8PmoIteBuls=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 May 2020 00:52:18 +0200
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next v2 0/2] net: enetc: remove bootloader dependency
In-Reply-To: <20200526225050.5997-1-michael@walle.cc>
References: <20200526225050.5997-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8b6054895d6d843a22cf046966645f5b@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> These patches were picked from the following series:
> https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
> They have never been resent. I've picked them up, addressed Andrews
> comments, fixed some more bugs and asked Claudiu if I can keep their 
> SOB
> tags; he agreed. I've tested this on our board which happens to have a
> bootloader which doesn't do the enetc setup in all cases.

If my SOB is wrong in the patches, please let me know.

-michael
