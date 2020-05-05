Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2215A1C4C9F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEEDUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:20:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC029C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:20:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so218334pfn.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t54JxQSWLyu6+7MyCCArUIBGaEJESU755MRp6UzAb5I=;
        b=PCJMCmBJzbp+b2jCUR9AWw0sGfKpC8YcGj7b/H2fOg3FO7izcvXMtJ68Sl1aOsObHd
         Ifn7zFC4QplfpMibglw8xYVqMz5iPDUZydtihZH42DqM6ZBZUwuwk0+uuINZ5sYRFZRA
         cuvaU+CbWaD2H85ZY/IifJDC1XjR63XVuRjuFq3+VMHWot0SK0iKBcz6FP6ntuw48rnu
         jzmwYjHKF7c7rQrjkKNxdKscOwdib2ukem08xky5GTzA04a+oqU/YdycPU35a0hk1ic1
         /3GBu9BQL2glmO5QVRuM4FFOQ5bmSoCmOtVhwiuz4hz2zpauC0wcxg4ALDcKNbZVhQKF
         VA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t54JxQSWLyu6+7MyCCArUIBGaEJESU755MRp6UzAb5I=;
        b=OcsGk5S4t8umpG/tcDgUaSjbjYUZYOQdmZIQB+/voqtS1Nb+cVWzN2Jn6st37bUpyu
         Skf+iM6MYvjLN70vsRRNWAjXZY9uYxw3+fwEeBMdwDDHf9ZCIYVbnCCPYoEHKUag9UwT
         mIFawUyki47Idhuz8VP7A+eBO6+KTs5DgXPv8H+hEHrGKxX7IgqC+VRcTpRPTz4as7N9
         5QvTT+XxTwJgsJaNOgVZgHgS++qGRdtCwoE09AFsJOteKzhBaxq5f9Ao0Sz4aC42A83q
         vE2rm3DmQ+y3tIsF0c82t+czLaz+wSlD2O9rAgnsDqTcaqQWRMwT7W6Cw8/m6+LK8JrD
         kWzg==
X-Gm-Message-State: AGi0PuZT6A+fbr6CLgwzkAOcGMCQbbwnNwpzNryNvK99njnwEcuO96QK
        twKn/AUOU4X5WsTmw5HX/L8=
X-Google-Smtp-Source: APiQypKSRe38Rd/p+N4EaCM8e8C/3J7oM0laQlY8YUD97X1KNtJZqaeABuPqRTVDbj/+ROlJXCwQqg==
X-Received: by 2002:aa7:9839:: with SMTP id q25mr1076567pfl.311.1588648823188;
        Mon, 04 May 2020 20:20:23 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r18sm384323pgu.93.2020.05.04.20.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:20:22 -0700 (PDT)
Subject: Re: [PATCH net-next v2 05/10] net: ethtool: Make helpers public
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <500a1095-ae6a-cf9f-806d-50b87b509d67@gmail.com>
Date:   Mon, 4 May 2020 20:20:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Make some helpers for building ethtool netlink messages available
> outside the compilation unit, so they can be used for building
> messages which are not simple get/set.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
