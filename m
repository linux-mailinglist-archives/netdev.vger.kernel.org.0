Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0E52EF77E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbhAHSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbhAHSfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:35:48 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A30C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:35:08 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e2so6083127plt.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wm9UU231uGhqvEoPX/bd3pkfZ8ACf12HqgBCQFgoWeI=;
        b=gZRCy4+WLRiq53Y4V09BmMNb33jiZXqWvnOejgT0CFNyBz0WCj19rc+owZh8KIMuRk
         bW1MyrlHb6Zm1aJMiYz+526uK0dUWAVjiSqfMjp9DVzEpeC1tBzzH1JPI95bg1xTLLm5
         Fm+9TLo4ZMkDygrGZhOn8FSsEXkwRdHeUz9EbG9UR6HKspYtLADwnvWb5irGuWsiEbK5
         xSXTWXuuWbnYlbSEyAfotRoA6jn8lOjeRFL9a1S+YKqQHXoJ83bj1ZAzpo3vCeSGICr8
         JLLja3upDOCvRXOyU92aM2ObSDzPw2uopcRcT4HrF3m2IRg15G5A2pQ+lIRSzxbxvpWm
         QfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wm9UU231uGhqvEoPX/bd3pkfZ8ACf12HqgBCQFgoWeI=;
        b=EjbXr7l2fT1ihDBUZQiURf3goE+OPuVXlSq3oicTs1SzsF0rkn8l34NDQFjQO0QnQw
         0F1/gHH1FBWlNflkFDRq50lDUE6lvtM6gC+yL7GU2z5qvKMzR5c5zklDFzwtciKD5RCE
         iIhUlGlZUzyxEeDDc+gjj/VNar+uheiNl0vr2WSzqabNRAotVVc85Bw93wXlPfXOA1ed
         8QBHE9WIHGYuNuXNXLKZbSbO5H8diTJdtlKcZthwI4L0Oxt/dbAz0dNKOpMOHW6dACdx
         stB2KkoRvFGnZeIEyOHqS/RVbHs42xyAwOMc01mYt2u6FLjROAsKFAKo/lJ5xfWzCgTf
         VbqQ==
X-Gm-Message-State: AOAM530SjsACG89q2k6MTfgysxDToKiyLoKhtP4k+lWse99CyQwFHsRx
        EaurUqE6f1WjaxR5LlXc7FU=
X-Google-Smtp-Source: ABdhPJx1VZUK0SiobuptGxOKWd6z2HJvjBf8S6onjGuLuIcv3jxFRy8Meqx3uZITfFUIlbCVT+t4kg==
X-Received: by 2002:a17:90a:e005:: with SMTP id u5mr5022857pjy.64.1610130908020;
        Fri, 08 Jan 2021 10:35:08 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c23sm10944312pgc.72.2021.01.08.10.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:35:07 -0800 (PST)
Subject: Re: [PATCH v3 net-next 07/10] net: mscc: ocelot: delete unused
 ocelot_set_cpu_port prototype
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <04c57711-054f-1009-37f9-8501ada7531f@gmail.com>
Date:   Fri, 8 Jan 2021 10:35:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a leftover of commit 69df578c5f4b ("net: mscc: ocelot: eliminate
> confusion between CPU and NPI port") which renamed that function.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
