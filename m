Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCA7321035
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBVFS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhBVFS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:18:59 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C716C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:18:19 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id s107so10900476otb.8
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3MsGAZJ5Muv7PVA75CcHVYKxK89XXzzS9hkaVuorcyo=;
        b=HtYGwhBZVy2cn/v+GgiNbc8k7evj4CcVpvHWRCIsEo7OEK4QfFtkEpIezGi4eYEotA
         3VhnfQmMRwCwDeo13tiiHM/TiINA0w3wwC5ymJpJaEl0G5DULm0DRfO80xSe70kjXlia
         6aiBCoojdDk+YnhGVh4Tr4JGrNVmPJB/sp9U1PeGwJCXmmPZ7xSVF/9xVh1DNdotsLJc
         dZ92RfGvpUi4O2zt/5KJqyetMm8wirWvi62810ibDZuaftKMlNEshlv0wtciNRqNTeDG
         bN8qoK7mm5xPRS50/Emhs0P7mciPGqwha4y4Sz2lCTihA+ZcC4AgCKTTWVTIoimsDO7Y
         rsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3MsGAZJ5Muv7PVA75CcHVYKxK89XXzzS9hkaVuorcyo=;
        b=apdHMIH+wqm4weYEJb+Ac1I/i8A6MzrjSFhBU2TztLivRpPSQt6JSwYpwcRlI6P4n3
         7ytPofB5zD5zysDffYq7hoHSikp8WnOiyry0rikzGVWcQNG+NzF1YUx95JszuOxwDiSE
         STjWJjBLmQ7ATmNn0PX+U6nPZ+LqcD//nvWnfo5uidzUWEV0EYMJ+WNZeLDgvAaveywE
         wtUHeHoqq7ayYd6+iRJmheYHu8sDbWjR7C1HdF3W6vwGlWCqzoL3Ok58t5LorPPtOmFu
         ZjHbyG43vNYC1CdjuJjIb9g8WJ3owXqvTVZ9NQY4gB2c1Fu6isdn53KCj3XtNBuHSum/
         1KOg==
X-Gm-Message-State: AOAM530FHREr4GLEn4kNDuwPZtBraynkdzvKX4hORMyMRkgnY0dV2XWr
        vnBwjgmaBRGC0RC2v0fhmeA=
X-Google-Smtp-Source: ABdhPJwt3ZdqzcOdZAeNMnQLb+6VY1YvhTXxQ8lKgFyFg4n3/xl2F92PMVJJX00hzlX6YLHFPvHeVA==
X-Received: by 2002:a9d:2c64:: with SMTP id f91mr15696652otb.255.1613971098451;
        Sun, 21 Feb 2021 21:18:18 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id l25sm585765oic.49.2021.02.21.21.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:18:18 -0800 (PST)
Subject: Re: [RFC PATCH net-next 08/12] Documentation: networking: dsa: add
 paragraph for the LAG offload
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b4404151-ced4-b3b8-7fb0-3408dbf23800@gmail.com>
Date:   Sun, 21 Feb 2021 21:18:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the methods that a driver writer must implement
> for offloading a link aggregation group, and what is still missing.
> 
> Cc: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
