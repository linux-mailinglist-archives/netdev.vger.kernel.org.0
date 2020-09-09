Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4ECB263382
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgIIRFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730324AbgIIPnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:43:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8CEC061756;
        Wed,  9 Sep 2020 08:43:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t14so2331525pgl.10;
        Wed, 09 Sep 2020 08:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bag69EkP6yWpG6o97y6tb9Dx12HOS7lqs0dtZkutxMY=;
        b=I3TpjY9OqoIWqRDmbOdwnQ1v+SEE8q2kipgTuTQ99D/jb4fdUvNQ42Npk1f2N2moQ8
         hA96XhKtfXOP1cIDKqmNZ3HutjQzuS7KU1ezoTl7quKGKt195K6GzxcUmZJ2AP5G/mjl
         zZsJ9LitWY4+4k27OW6uS98j+uNvs+CW1Ne/s1ms25lFxvbZoyekI7PvDds4dBsVXCAO
         ZJXfFX9VFSIBSvzQv6Q9YI9dVZ+MKF+ckl9f42t4OUbKn5reaxl+Sifj0lrRP6rwWBtA
         b+416QHIyes+UmYMKFXfRWDHD0xekgFwouveGfk03Y18NaPCXUUtic3vcURx9tUNQoF1
         ay7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bag69EkP6yWpG6o97y6tb9Dx12HOS7lqs0dtZkutxMY=;
        b=CJja6/KBQq/uTndLeGe6oL0tUqNyNlikOjOmzd55IEWKfBHOceW/Pr+oep+q8AZXk8
         AXBHkGeN2HZqP8892hSIQ6H6xeAicIYGtMo6c8wjpbx9wPC1FFD9TgDPwO5z4oF8xJrF
         U3qe177e5z32Mw442LH+KZX0qqBy4BnJQ9nBrAMrpuOUgsSM7LVanrlNynpBv8gNTh8b
         TFfQMdSFbmwxkRh0snOPAQf7lYNf/9wiuN4QzXCoav2ft2uHsnsGx3SZJaeBjg2e5y9o
         skeDpc5h0dMovaw6fvMbKBTHUQOTwIbbMt6FkYF6gWeiI2xpfEZ4zMyl+cHWKEqHf2V1
         z94w==
X-Gm-Message-State: AOAM5326pMVZQPLIh+2uF+Tcp+t5oEmDJC5/b1jZNvPIlNQ2EltyAccO
        2BodhNDKQuBktkxGg1rxXO3N9RXrw1A=
X-Google-Smtp-Source: ABdhPJwnEgUHmTVRl7qwxsDMuaptWc41HPiKDn4u5JYbhBAjgYaDhpwTk4w5nhshZWtOkRZKI/zYVw==
X-Received: by 2002:a17:902:c206:: with SMTP id 6mr1337188pll.93.1599666208262;
        Wed, 09 Sep 2020 08:43:28 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v4sm2339311pjh.38.2020.09.09.08.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 08:43:27 -0700 (PDT)
Subject: Re: [PATCH v3 5/5] net: phy: smsc: LAN8710/20: remove
 PHY_RST_AFTER_CLK_EN flag
To:     Marco Felsch <m.felsch@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
References: <20200909134501.32529-1-m.felsch@pengutronix.de>
 <20200909134501.32529-6-m.felsch@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1ed4093-41af-21a8-2ca3-4e1457d23750@gmail.com>
Date:   Wed, 9 Sep 2020 08:43:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909134501.32529-6-m.felsch@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 6:45 AM, Marco Felsch wrote:
> Don't reset the phy without respect to the PHY library state machine
> because this breaks the phy IRQ mode. The same behaviour can be archived
> now by specifying the refclk.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
