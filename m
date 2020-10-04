Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA93282BCB
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgJDQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:18:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56035C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 09:18:19 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a200so68103pfa.10
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 09:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/8OoN3Q6MC8turgHz/YAyQfnJSUiB2EYOsDQPWctGgc=;
        b=bu6tD5HMr9+MeyzVFINWwPeL+kX0XAFq1bfwutnzhBfc/vgp8S2RWNmwqI9q8W3JcE
         xk9RzbxMEb9iVCBFRXg1AG7M0dnBWDRLMyJvaQKIAl8SVv0I9RIzdkTW1S3TR0rQsuYJ
         5iYV0r4QcbyV8/iPSTm6HF7qqGAy59xumLrwf4nNCz0Fk0RmWMMjEBCw1JLz+xkMDwba
         oh4S2YNb3ibe1Vze+qV0ZPnYbqgA1+ras3fKHf6bwaSDFaMHiSgEUtrBeCnh5lYeGq4+
         nOJX8Fl29un02WQ3zgxxR9wcL5ibQPUFX/ho5bPojKvJJCBvD23DRUg656ugEwcLjXIQ
         WcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/8OoN3Q6MC8turgHz/YAyQfnJSUiB2EYOsDQPWctGgc=;
        b=EdLU4d8C7qMjgmS0VXEvdWgA/t4d8MCSYcSbcwlvV/6ltrK+zBw8f8asY+H824dytX
         ZwjIQpLRs9a5gDG4m6m7SrcVBhbmB+pobr+7AwQbaZ4+17pWkng9uRnX3aj4C3tOoRkT
         mhCoT1uMOsLxLMX8TWgMGiPL9f8vKFrrAI0wf5QooeWaZicA/xRfasXEDt1PjZtqkf0Z
         KbHlrTl37gmGgadhMsMsXKIj42JReOYlFpDx7kWR21+b5qaUv2zm1rbPT2G2U428Dkgb
         bwQzM9RNWQ+TU2pYEC4Y87/9r4iV2NkU6+pjltrJp3dywGqyfaLlNXuMB6+Z6LfivACU
         VYew==
X-Gm-Message-State: AOAM530TkeIPtv3ylZ1w63XEGiZeyFbXUg9r86hRmCzfktiPGGK3m+PO
        Qt7ovBV0sNaIg3J8mKgnzRg=
X-Google-Smtp-Source: ABdhPJz+JGSWP2qsbhDh2twkCtpkXQgd+iBUOOr/Zz+VXu8wLdpIJL0jnTyjzpMTpxoSuYbIwl+Zgw==
X-Received: by 2002:a63:fe03:: with SMTP id p3mr10432882pgh.100.1601828298330;
        Sun, 04 Oct 2020 09:18:18 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j138sm5041778pfd.19.2020.10.04.09.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 09:18:17 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/7] net: dsa: Make use of devlink port
 flavour unused
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b3205cb4-798b-77ac-9df6-4609d37b8687@gmail.com>
Date:   Sun, 4 Oct 2020 09:18:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004161257.13945-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 9:12 AM, Andrew Lunn wrote:
> If a port is unused, still create a devlink port for it, but set the
> flavour to unused. This allows us to attach devlink regions to the
> port, etc.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Tested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
