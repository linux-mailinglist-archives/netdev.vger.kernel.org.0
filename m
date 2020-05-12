Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B81CEB8F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgELDh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:37:26 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3C4C061A0C;
        Mon, 11 May 2020 20:37:26 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g9so3012285edr.8;
        Mon, 11 May 2020 20:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KCtFW1+LXuMk8CaqJCrNUHAveDZKaHjGoG7f+GNzrW0=;
        b=DhRYg/TLZQykS4Ry0NoybB3/9SdZB9drXLsrdnBae05w1mMP3XD3dwewBTuFNbgHE9
         WilgbHjOIWrBaP+FAdFCOkHDR9KajK4orSGsv1aDjkA/Y63aao+FSAs5baCxIG65g6CP
         vWaGIk8lNcqiWrUy37L9aesG33ig5uTMsGI5dLTmbdhFkvHNVrlZ8IzyybSaeG5eI3k2
         sj441XLjSkxHS5jfjANoKriXnO4qqUp5ux4od0Y8ODC1vmAqEsw9Jynq5e++ueHxqn/+
         23jmaz6tBU8qS+tKvvDP4uMRksKiDAvy1eTHLpV9pn1uenl4oGEmcRMSi8lgiZ9XFqJ5
         GOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KCtFW1+LXuMk8CaqJCrNUHAveDZKaHjGoG7f+GNzrW0=;
        b=BHaNaXMg47N2gRg9/D1dTI44KFdoxZtsg75+X4PxBJPgLUcM3zWZuF5UYPriHxxCYY
         sjgPHOQrXWH2qXoeU/bIg3+0bYMXvaLYkurmBURhdU4k18qE5k0qNS4vx9RC+bCCy6PG
         j64SfNw0MLzLQ7qYLu4jU+zmmqn7y9BzvPlTKPFaFGnGcjDb+phHITQrH+dIpB7zf7hi
         h3n6RHfqYIVqBvI3PH8txB4tCnbmOX41DQRX1q0rmgPx9z8FLoQVEU3h+178WYIXFWA0
         PUZ6VIVNo3mTh4z4pd8K4KCI1XBaoA8ckkbs1LrQAQHdX5ousstYIkMRJqXUIxY+85ne
         X6+Q==
X-Gm-Message-State: AGi0PubF99e6UQ+JwryFg1P8j+mUpjjx+Xn85D/h3Zkd6fPShv317KA0
        LYkujjdmEVKqnvDReQUHHZ2wRdZR
X-Google-Smtp-Source: APiQypIKYGFihJ2q0MCE3cuV73QTv68p9yu1NANlA/uuYllqFtyRFjOms1/v63fshetZvSQWuSJFdQ==
X-Received: by 2002:a05:6402:1215:: with SMTP id c21mr16726330edw.128.1589254645008;
        Mon, 11 May 2020 20:37:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id sa29sm1544425ejb.39.2020.05.11.20.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:37:24 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 11/15] net: dsa: sja1105: add a new
 best_effort_vlan_filtering devlink parameter
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-12-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dc30d202-3924-172e-5d69-5d1a0ce6e9bd@gmail.com>
Date:   Mon, 11 May 2020 20:37:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-12-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This devlink parameter enables the handling of DSA tags when enslaved to
> a bridge with vlan_filtering=1. There are very good reasons to want
> this, but there are also very good reasons for not enabling it by
> default. So a devlink param named best_effort_vlan_filtering, currently
> driver-specific and exported only by sja1105, is used to configure this.
> 
> In practice, this is perhaps the way that most users are going to use
> the switch in. It assumes that no more than 7 VLANs are needed per port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
