Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C501C4B74
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 03:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgEEBUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 21:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726449AbgEEBUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 21:20:00 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4260FC061A0F;
        Mon,  4 May 2020 18:20:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d184so80720pfd.4;
        Mon, 04 May 2020 18:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a1w1qq0mweMmTQ7rkzVokrIExSXiyuKnh/goSqDSvM4=;
        b=XGY2c4fVDS+MS42ccs/HV1JdQopehIykrD6IyoVXFJJQj4n3uL2DsB/F5fUIkk7JlU
         R1zrbORm6Umx21NQsupBeOCS0/fOjY7boJiWaxKEQcf8bjUxE1SZkW0h+6bcltqPPTpF
         csDg3+DAiDeh/MRDHSOJRmjouXt6IUr3rumiRAckHYmUshRnoq2YQisi+csDaBZoZZtP
         3on222JcNhkiGRk4MVej9CsFPr534uHc658ucVkuuO8ymo8WIMRUrf8GHWssgdnLNHvD
         gR08CpqbUYsJOVmsrb0XAgBgFXOkltkF3m4rHW+KFiWVpeJGKx4EEYscksUIRI5Gz5WH
         WAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a1w1qq0mweMmTQ7rkzVokrIExSXiyuKnh/goSqDSvM4=;
        b=XTK+0W/qBJsjfucDoaOOpskXFdu4AjbBHrRrbxTGlkpIlSb5eSNuxh42CtxE7Js0Pi
         y9F5fZDfkRjiIuvH/OuTu7iWfLWO04u7Jtk6j+mY7ZhF4pdei7pwFoWNyKwuYCiSHK4F
         WJzgVRb/JI4WJtl9w2qxnsYGOEEw41cUKfaM5nbAquyC9PoQ125KLslSZh7oLXKFxxtU
         yWviFOJmyI4pNALMhQKpB5LwKwpM8fbu3xb+sGEEXSwqchMt+YJqWdhltpMyZHloQgHr
         58tvmrDy8JLfFRyYczoR03WeTbOaz7dfcTc82n+POl/VwviFfioybzncMHgAJrz8Q6Cr
         MjOQ==
X-Gm-Message-State: AGi0PuaAI5TkDJ5C8woNGEKlS+Rpj2z7xKJmmO3MQK4wl6uhlMLQe48X
        xo0AwOtMlDDu0gOGo4j7ims=
X-Google-Smtp-Source: APiQypIs45WC84xw/BBiUgsU1QO2WVLwwNsCEdxos17hCwoDBA5qokgv8wRmIS1W7LTB2/4XrvznmA==
X-Received: by 2002:a63:1645:: with SMTP id 5mr940152pgw.145.1588641599757;
        Mon, 04 May 2020 18:19:59 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g74sm319242pfb.69.2020.05.04.18.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 18:19:58 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: use phy_package_shared
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
References: <20200504213136.26458-1-michael@walle.cc>
 <20200504213136.26458-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f1032e32-b031-4a35-cef0-4b112ec3caa4@gmail.com>
Date:   Mon, 4 May 2020 18:19:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504213136.26458-4-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 2:31 PM, Michael Walle wrote:
> Use the new phy_package_shared common storage to ease the package
> initialization and to access the global registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
