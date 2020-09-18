Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4734270611
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIRUOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRUOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:14:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBC4C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:14:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 67so4096153pgd.12
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HBFxw3SALTTObkSluWsBwaP9B6yE/QPTrDW4UlJ63QM=;
        b=YP4pgOpjpG7ulW8ZcKpXSQwB9mwSEwfKWRlyVwb+thFYKJJNb8HugdXHmgYC4LaXBZ
         L5jbSape7ykNAmngM2NyhhUh8oAP0nts2i6qYNNKuQ3fHb7PDAk18d+7vkHFcyRj+LYv
         HXJp2EU8tl0WJhSy/nJQw4djkDvD6Ci+78WHgKYhe8FgBskIBEcWzYWHy4c5hi2Bs+Z3
         MLVEs/pEp59wXl7dZd8ZCA/rd2b5dZ2YilNVOY/sT/6j3OFpNUSXNNR/2aK44jksHFLM
         vDVUNJjGjBJKIA1sNVJOdodhr9QmWxx4x/fP5sdKTu5u4eyHi7GrIBb7KhLBfjHP/v9q
         /FxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HBFxw3SALTTObkSluWsBwaP9B6yE/QPTrDW4UlJ63QM=;
        b=EGn60VTSr28tLu73IorE6OkVuYqmVVKrOqHFIXAdq3lmgqNyTV3vFOtDzRXQ8c80KC
         GRm3gQI9fPMLOLU4JykEpHN4lNSK1nlJ+w6c9bBdDPONTtHTAaknqO2pcBtkJgVlArgj
         lgPq3x9fx8truSWlKqBMU70/nun9Aj8oiZaq5U2fMmDeH9+yW5u99/gBhsSxw+MOmHTn
         nihMuJ3ztxzKAvDhy+VsaiUwXVxtzztoBR5Z/5Lflulp3ZIlB+fkUJfjOREtiRM/qILr
         4WcuUGkOoNO22WLsQtpHYmSCoAlZtce/p4GLXXc2wjZVRy37YlldY/WRvXs8koRpE0qz
         l9fA==
X-Gm-Message-State: AOAM5326slbsfl25C36+NG8q5RCZ/MFYr4Il0ZK5sAuH3Njt0e1Iex6M
        xotV2ZzlFGicKwDLMlMkgQU=
X-Google-Smtp-Source: ABdhPJwEhruWwElD2XntTZDirbSms5RWp8RerFXvjDVjt4pDEs2dB9ITgfezyyg9Ao7g4BQa2DP3ew==
X-Received: by 2002:aa7:8d4c:0:b029:13f:e666:8f05 with SMTP id s12-20020aa78d4c0000b029013fe6668f05mr25526183pfe.0.1600460040131;
        Fri, 18 Sep 2020 13:14:00 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v26sm3971605pgo.83.2020.09.18.13.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:13:59 -0700 (PDT)
Subject: Re: [PATCH net-next v4 7/9] net: dsa: mv88e6xxx: Add devlink regions
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200918191109.3640779-1-andrew@lunn.ch>
 <20200918191109.3640779-8-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <317e35c4-0f78-5c18-ee0a-c7c95fff771a@gmail.com>
Date:   Fri, 18 Sep 2020 13:13:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918191109.3640779-8-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 12:11 PM, Andrew Lunn wrote:
> Allow the global registers, and the ATU to be snapshot via devlink
> regions. It is later planned to add support for the port registers.
> 
> v2:
> Remove left over debug prints
> Comment ATU format is generic for mv88e6xxx, not wider
> 
> v3:
> Make use of ops structure passed to snapshot function
> Remove port regions
> 
> v4:
> Make use of enum mv88e6xxx_region_id
> Fix global2/global1 read typ0
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
