Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A64214F93
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgGEUtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgGEUtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:49:14 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC28C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:49:14 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ch3so950827pjb.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/63rJ3PefTs9jtWEJY5TocfdFH6314avpbtWNbwM8k4=;
        b=Mr/fwp5ntQNLh+WdNHEjui/rd6d3VZrTpZ5l2MfCndXTIyMy8RElBCchsUopBu7oID
         v/qELkn56kZWiVTm29GJNyd+ixufOT4zw9TMfFg62AuFADT+qpcAQK7W80DyMYAQ1dZq
         zX+JSuATBueJIefMViEbaF0df2dWaDKODtAI7EgU3M25Kx19yKCpZlv4rLMjhgBpD9H/
         SVbNEPhKoIXA0YHzS9XEicUdQsf2Bz6AdgJSgWfmQDHaHMt/jVWbOnMsVZuCNrQtnHs0
         T4bW7B8vDXAg70BCdD0wwgwRMqg92MwzeZsUp5WCOrFdh+mmUJes1oQTotvgw1KTiY39
         gIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/63rJ3PefTs9jtWEJY5TocfdFH6314avpbtWNbwM8k4=;
        b=fLdKGQP8qhp82JrdNpFABtkquWNyZhgmRAlQgk3m+21sfsUHF4nyw5AoXo9McZAHmW
         sGVSGBztAWCypZM73vwK3Z8JVJKCZNFn7xKXNfmCg/6SANL+rkkXwt/uBTYW6DPmZJx2
         bkm3+T6+BIiSMVN/U6JwdGlBYPQhdrgRCBZZOojFduG4Y0IhZhi/Q1adduBpwaVKrco8
         28Kf/tYQ7Q1mbu+eVo2UDJ4D04cjZ15bUY/JblUm92OI8Pyar0MeOGL8P6oeQFSNUrPJ
         zV+/J64C7Em70DC9dWNXCjAs6hEXkaUtDpltXvZ489v2R8UwV9Ztg8XFPhaDG/YwcgP/
         A2cw==
X-Gm-Message-State: AOAM531U1JQi/9Zdb1ezn1tdnNCICnMAxPEbc6vdlXWEQj9AVNYyKYqG
        QJHZjILfWSzkkzqYijhuVGRwz3ZX
X-Google-Smtp-Source: ABdhPJzgklF2WQD3NunyGOhJY/EUpe/huWsrN1eYjtKAfvhf0XmWFUY2stDApTLb1PpMIhaKZhMNBQ==
X-Received: by 2002:a17:90a:8e:: with SMTP id a14mr11783022pja.206.1593982153749;
        Sun, 05 Jul 2020 13:49:13 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id i63sm16717745pfc.22.2020.07.05.13.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:49:13 -0700 (PDT)
Subject: Re: [PATCH] dsa: rtl8366: Pass GENMASK() signed bits
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
References: <20200705204227.892335-1-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <945fc1cb-c37f-49d5-564c-0786ed9c9d57@gmail.com>
Date:   Sun, 5 Jul 2020 13:49:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705204227.892335-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 1:42 PM, Andrew Lunn wrote:
> Oddly, GENMASK() requires signed bit numbers, so that it can compare
> them for < 0. If passed an unsigned type, we get warnings about the
> test never being true.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

The subject should also be prefixed with "net: " similar to the bcm_sf2
patches you just sent out, with that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
