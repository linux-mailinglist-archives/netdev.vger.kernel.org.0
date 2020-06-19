Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84A2019FD
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390561AbgFSSJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388286AbgFSSJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:09:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9AFC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:09:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g10so9243610wmh.4
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SlfIFAUjnguc+JpsjlVfnRjFFMNQHOY/AMA58+Nfm8o=;
        b=josKoLFuN1sbCDPL6qWenuZbAd1Iqfbo1CH3/5XNWrazs0Z0zCauEYwYOZi9s3kj1Y
         EN2fD6p9ZzLe20bhJVt/zGlzQo9y43fp3sWJohex1Mcc0qiMBSuFGiv440jaD+eqJj/B
         +LIWZV3Q9zmrIDudX9GMfI50p9hTQTKs3E1FrYyC7Jgkz7rJrm9QRbYhuyQZMZOE/amr
         8rgNlNXK3gTqsLmM13A9er4OYikCmj/cBZh9e4fk3NpH4DTdBmnhartuCqBX0pzv7+0M
         J0J/ZBzrZkGcsU8FT8NeCg0seSFApNNvuhEA+2DdKoeAbYIOCTXzEo+24O9EmPvj9OIQ
         EakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SlfIFAUjnguc+JpsjlVfnRjFFMNQHOY/AMA58+Nfm8o=;
        b=VaQtUuCtYRjw91LAAC6B8PYQs4r5e9zddUG6TFtb00GK2DT55CkgzNjj3REwt7Ab2H
         BEMQG4xfgFCOFj6nuc6pJac5LGWPcow+5Mg+cmL0CVU0WylecBryVY1B/N3/zlIcCY4g
         mEBmFvTPDSEwXsUnTevZiABML/zxAPEkmAI/vwwBljxjxluMLQ4IoCobzYX8IqBlfuni
         AlwJa+NGV/mpxUOF2nS/FzZU7kfJCIW9sGSDIH9xIlsyiYBMImdtiysUXbZBMs9mCPg+
         lksxEmnQB+OhOFSAdJAvHx+VnyOuLqugTQNvJBkiFEiApe0XbDfXWdIgRtPDRFTP4hjh
         V0vQ==
X-Gm-Message-State: AOAM533wa3hDu76grrp7YtEr4J6n3LZkXLSyV8u7lG1dbfGk5Z1mGiOO
        8XfVOvmu0AldGMEGczOjHdY=
X-Google-Smtp-Source: ABdhPJwxGO6aBtOFI1wnjXO233Ox5l4UEeHez7RH58zmfnKmlO20oaF+V3coc42EeDeRC6sH4LDHcA==
X-Received: by 2002:a1c:2485:: with SMTP id k127mr2812633wmk.138.1592590162265;
        Fri, 19 Jun 2020 11:09:22 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 30sm3307658wrm.74.2020.06.19.11.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:09:21 -0700 (PDT)
Subject: Re: [PATCH 2/3] net: phy: marvell: Add Marvell 88E1340S support
To:     Maxim Kochetkov <fido_max@inbox.ru>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200619084904.95432-1-fido_max@inbox.ru>
 <20200619084904.95432-3-fido_max@inbox.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3ddc7d27-f555-006c-5785-0a07067edf09@gmail.com>
Date:   Fri, 19 Jun 2020 11:09:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619084904.95432-3-fido_max@inbox.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/2020 1:49 AM, Maxim Kochetkov wrote:
> Add support for this new phy ID.
> > Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
