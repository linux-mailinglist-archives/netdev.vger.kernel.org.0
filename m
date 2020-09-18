Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A60D26EAB9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIRBzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgIRBzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:55:22 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833DFC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:55:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so2297062pjb.4
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mSCh51rwVfIUwb+ngdDQ+9EzTnE1lRh9cbHOZkDUOIE=;
        b=mmpQXVcKHHBILvf/UFdVcFkprht4xccXpjkU9ITlTjYXTA0yUABuZ/SWmctjSMnOx2
         dqINZk4loJ5rFPjjLUn7TYb7c0UHALlWJlAa9Lk0wosCrAxW2QkAMAk8eCPNiPO7oIOy
         713O7zqbBUihdkE+eYRXSiuVPccT1gKtz7Oe0VWSyd8zFojff+/1QZMzUYCLfwYMGutt
         O4jfhqca+miO1xSEhNgFLqveYgCDEEAYXkjgXwkQ+Rc0dA1RrGmTRQJoM6jZccQ0nRoc
         jjcQ/QWQbIq7iEAG0LqburkCqgzmdBa9aQxhgQy+0ROmR2kOORaMoFSgCGbeYwLHzDlc
         KxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mSCh51rwVfIUwb+ngdDQ+9EzTnE1lRh9cbHOZkDUOIE=;
        b=LkufkioGEJqyIBbXdlDbloR28BBTGKmJRDGVThbfqCmvI0Kpu4xVMt4O440/s2s6PH
         o5vmwtY1z8wSCSo4cBpL6FBpbc6v3PMftOkjm4HZdzZHtAtU76uy6u3pU6Bc0/t7aPYh
         HElKVnbZvDlH4t1cNx2JdHYYL/3GvwGg2UuJxbyA32ubdrh/1cBSYnRljdKC4XxxSeH5
         3aEITO6a1ngXkx7Y0DafJNeYAHh43ZbXFJQOBvZgQopY5KPBzrLbMmuRGnSoEvEst84J
         OUcbK1bXpoT6Jsng5Lu/pIf/wc3zhic3mHAJXWWbcD7cvfDVVmAYmRM9PpJjUD5OeFWh
         eprA==
X-Gm-Message-State: AOAM530dhl4aqOpYFz9jUgYAa89o02aZfpqqve7QM2o0kOxLDxJQqsUY
        IyGkLT/jdKRLvCf0TWk6GzQ=
X-Google-Smtp-Source: ABdhPJw8NL7bW663e/fYMru2dOoj3yMP+L/IgByWuAmW6tHmaybB5g++UtkrQTnKQe729C3e7WH9gg==
X-Received: by 2002:a17:902:9006:b029:d2:341:6520 with SMTP id a6-20020a1709029006b02900d203416520mr3193831plp.37.1600394122095;
        Thu, 17 Sep 2020 18:55:22 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b18sm981307pfr.4.2020.09.17.18.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:55:21 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 4/9] net: dsa: Add devlink regions support to
 DSA
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-5-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f4d7181c-9120-0561-5ab5-f3ae37974574@gmail.com>
Date:   Thu, 17 Sep 2020 18:55:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> Allow DSA drivers to make use of devlink regions, via simple wrappers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
