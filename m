Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65D92BC021
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 16:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgKUPAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 10:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgKUPAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 10:00:51 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D1EC0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 07:00:51 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so1512666pge.6
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 07:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hAPqjXJs6Bmt1zww4mU/3N3T/nQ4dmJE4aHcNisUOgA=;
        b=s8B1mUVeN3Iu1LcOgkdZVJbzGWG52vIOoqN2SCKEQyKJg5Qz46TRmQoY0oEoZM2gyI
         PfbKNRa9SXMJ3FhpVVDmM/8Wli9QKHzKaBZ4N8j/PnR6cvUlaTwI+E46kTqDUy/MD6ag
         EZLQXilXmDhu0jIMkxscpEiAmJdaeZ6l+dSI+QpT2S6m7IWcY1QtYX/nMrFejvsBnNll
         ySzHPf6h8I5vVNM8wizZmOtn1YfZoqMQWYE8kRImpvK8HAPulqhnhHCOfjk9P7ocltBX
         hRB7Fa0adX4or8X5GP1il6kFCo5nA2wOhBdkWXn53eKKsbGABSnCkeoDpY81GEZGIDpG
         dIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hAPqjXJs6Bmt1zww4mU/3N3T/nQ4dmJE4aHcNisUOgA=;
        b=g+b5vcdMremfbUyYF4lEVbRuG3n78WJ1tZ/UPcjD0kK11hkmzdPBEcn1U8J4QDWXIq
         1TlnGX/lBjAErjL1bhd3nRB6KAAbxZc6g1O/OlCUFLrwl7Hk6onlIl95RIKBM+jAxuh0
         uT8ceTTeoatidG5fnAiVJgpm6gHxrK5ozwK7FScZJMQVbIag4xkRSSwJKJuqJX6c08fv
         3P4KNVYy6jgIqXH65xQYfQP7iRkXhm1zDVIC6Tn0KtuSEQXTN9psOb92aC8ufke89tqd
         PSYi+sBOhGgzCJC2QznapXmxfqAPCI/NL/OMKTDmANl2qUPfOzK1mVTqC7x/qN4VsItm
         Nq5Q==
X-Gm-Message-State: AOAM530d/xObQRvo6EY1AKi99UwFwO6Oe7qlZfwvOCAqKwF081i3kl6n
        GoUbgTHbGHRi6oKg6sAOVXrMdotSXxg=
X-Google-Smtp-Source: ABdhPJwNbqwmriUSPJy6Ur4LSIL2WOTF9p0bnaXOwYHDUpyAFAol9B8R7oz+1lGtq9uQl6Zdb44NuA==
X-Received: by 2002:a63:5864:: with SMTP id i36mr21239529pgm.68.1605970849452;
        Sat, 21 Nov 2020 07:00:49 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ge21sm7979677pjb.5.2020.11.21.07.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 07:00:48 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_hellcreek: Cleanup includes
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20201121114455.22422-1-kurt@linutronix.de>
 <20201121114455.22422-2-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a7de64ba-c005-cd7a-982e-e90681ffc47e@gmail.com>
Date:   Sat, 21 Nov 2020 07:00:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201121114455.22422-2-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2020 3:44 AM, Kurt Kanzenbach wrote:
> Remove unused and add needed includes. No functional change.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
