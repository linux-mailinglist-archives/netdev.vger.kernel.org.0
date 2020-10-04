Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36C5282BD1
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJDQY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:24:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3BEC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 09:24:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so4168105pgl.2
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 09:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kpNIEUtXZIcE7jxnWTsyV66ed+69BWhBJGFa9HdjwZo=;
        b=actFmoT0h3DINjoCIvxuyrYQwGMCO/LuWLB35f3LCXGrxkgvQiCJoJayLrmbsGhOky
         gu9loLuxVWLg/4ZCr9iU/x/a97Mq3pHo+5Q6rzjPXCxmAScPiozufTNl9xOLf9Hry2P5
         Aj0kBEgVK7FsPleh3UHjTisyk/aJ+IYdiTrvPhjrcD7t1bjz9LHhJ3cH6AhqRAgerJb5
         Z6rNNO2ueO6KwTpl2T+r6oGWS1oItVqgTZwkrrtjCpj3rSBOycVZ1gSel4piDAiuJmxJ
         hZ+PkE+8THbRoBg3gyEvsaqkS/R8fmZdavvIfWOQVllmS2XLx2Hv2i+etd0Z4lRffnsT
         47cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kpNIEUtXZIcE7jxnWTsyV66ed+69BWhBJGFa9HdjwZo=;
        b=t4YPL2yumsabGHb4yT9Uq+WqI8ENGBXEMbBSp5mW6wu1xxg4K1v6rXjse2/Pn6xgVW
         6y8Av66eIB6wltF7IsCLE6cRGRESq+sHZi/sJ5pDlzJkuvvTna5LiRUP+41REuisDduX
         Qd+iT1EQhGRFNWnuTzXZ/B5btN2ha8Kos6baigfi0J4K8sfsfbxrvnA1w278ONPy58Y1
         JLDYcjMzUR/aW7+rgsLN6UGqRAiDP5dGGa84kmPKSlaC45/mx08RKV1KjjzymwJPvolp
         TUpDL+DZCUMk2kHyQIjyMu1uwE+l70HfhVdp5JLUwjzuwHxtque5NBlzAaucVYxuUj/C
         IDKA==
X-Gm-Message-State: AOAM530ZpuZKUp2SfhOFgUtwNyVRFCIYnSsCGHjH7oOxwNJ3KAe0/swz
        eBkjhj5f3DCRGuxBDuML2nc=
X-Google-Smtp-Source: ABdhPJz8xQH1rzaXc/sNfk7mnLc+JINygESB0CR1gLriHh4Er9BLJ3nyTfoRM784e8I3fbcVqcFiVg==
X-Received: by 2002:a63:4c46:: with SMTP id m6mr10259510pgl.127.1601828663908;
        Sun, 04 Oct 2020 09:24:23 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w23sm2387967pfn.142.2020.10.04.09.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 09:24:23 -0700 (PDT)
Subject: Re: [PATCH net-next v3 7/7] net: dsa: mv88e6xxx: Add per port devlink
 regions
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-8-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4b31decc-7b57-0e89-97ef-73984311b91c@gmail.com>
Date:   Sun, 4 Oct 2020 09:24:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004161257.13945-8-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 9:12 AM, Andrew Lunn wrote:
> Add a devlink region to return the per port registers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
