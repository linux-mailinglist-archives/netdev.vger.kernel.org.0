Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF63A4B37
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 01:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhFKXaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 19:30:55 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44924 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhFKXay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 19:30:54 -0400
Received: by mail-pf1-f176.google.com with SMTP id u18so5650370pfk.11;
        Fri, 11 Jun 2021 16:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8Jn6liQ/3aNa2Ev96jT361t7JUeEtDD45f4j/igbt/E=;
        b=aXv+TWPwW6c6QUnKLYUBE1l2sT9y1CHUWOMOL2Dai3vx6PNLtaSRzo4HFVH6kdDves
         K/pUSR3ECInn0xbVmjPKi8yAWBHFWM1LajD9WuO/77wChkRGjdB6ydni+bixTdq1bfty
         goMfe2eg8MLP5ZJ5zqojMEZumg1UW1SfaGULLHVXiklaU+Jh1iC4DACGwcKfHGjrP1R6
         02AIa4Zb0W9SkWzGpJeC/vCfvMG4xh4M+lB2MrClQN3b+KUJJMXv8BAVcmCRmWCIXakc
         6FkTd9uzUZa7kYwSBV3AFzLmjZ6oDmRswzYGsxmFe8Jq0tex3ubL4Eg6bpF6OYXs3y0C
         FYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Jn6liQ/3aNa2Ev96jT361t7JUeEtDD45f4j/igbt/E=;
        b=IuppxRL/ZYVcext6hTwNuTTgCa1aRtt7zCLIGvd0H6yQsLTKbQxTOd0pZKXkwPGRxY
         Z2PmoXQSl2OT+gYsrwqca0sK3lJLvHo4iQDxsOF8M/98TrOxNhmTQ60NX8bogtELean0
         fhNC1h0n+y/L74zDwaZ0+jxMgIdkex3uvg8keotCuy858ZtYCUXt1lKnkdEu9sI/qI9r
         T1hz5ekOQZB2zbh8L7e6FwYIJ6pAQAwRhrUgB7KF1TkeoEhROrw+0XlxGibtlZLcJyOp
         JumAQWQ2qY1MAoK5ONA//y6bobe6wRiyGca8H/nLup0bD+xMuiWLr/9oJZi7JWflUMp2
         w0dg==
X-Gm-Message-State: AOAM531ocWlDrWy9blcBCHIbrhFXLRRSFfbYUzFADngxVUExqffW5f8O
        cuSCADybjSFZhTwYoZ7EH/8=
X-Google-Smtp-Source: ABdhPJxEDKYSYwrCwmLbnPzjJ69rP+6r4MGfLDuW4hR6LsUfBOb72p5FiTwPHPbQhRRTAh4ax2ZTXQ==
X-Received: by 2002:a63:5f8b:: with SMTP id t133mr5831206pgb.411.1623454075804;
        Fri, 11 Jun 2021 16:27:55 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p1sm5820839pfp.137.2021.06.11.16.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 16:27:55 -0700 (PDT)
Subject: Re: [PATCH net-next v4 1/9] net: phy: micrel: move phy reg offsets to
 common header
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <859d59a5-b24c-c708-502a-0edce94ab51c@gmail.com>
Date:   Fri, 11 Jun 2021 16:27:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611071527.9333-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 12:15 AM, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> Some micrel devices share the same PHY register defines. This patch
> moves them to one common header so other drivers can reuse them.
> And reuse generic MII_* defines where possible.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
