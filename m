Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7DD321021
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhBVFHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhBVFHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:07:05 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FC3C061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:06:25 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id h22so2564777otr.6
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6MEL30XjGBzEQd1KGSRxhZVPRJIF16QEmMEEBzU/4Gw=;
        b=a7OMUL53FuP6dIi75W0A5PglQWQkzx5bqHyBOynKQ1JOhp7PMNB2PHLx2YBOpFaZcP
         eyrHCaPxkYRLpm5G6qfB4f8Un+7CKzHNzK0sQaiZ5erwzOWlF821Pn07RRGxWnXUUaMV
         VojZBK4GOhBm7RScoyJV6UFKIWpq7YWBaQ1CSkGuzEiW94Pw9kztnFjq15kMxp/gjgMP
         iU/L5ierTgpUE9BkDdokLICQY9uA7NEMC7ZNEslaMGJW3wN6/WtODucH0+/oIO7h1oAk
         lPV3tDbxs57vRTT9GOFvRqu8LhZEcA7Gs0/aLpLsBcOqCsXUIJ+sKGrCqNXufLo4dx2R
         HAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6MEL30XjGBzEQd1KGSRxhZVPRJIF16QEmMEEBzU/4Gw=;
        b=OwwEaIzlfG7VrbHM7MN30PTID/rPKdf6bXuvXvK3aI9XlSMGPRsI5OIAra5pvdd2Hn
         QDawPAkFD+Gc1rmPQnn2v/358aiiMH7d7grjCwRx/G4GtVxzrnGj5xX6z7zERbByyGio
         UvUWaAcKpbP7+Vp7tCkDwJsK72Oc4r62Qm33+jWs54sls6Aacwt0OF0cbpX7I+SO3lU9
         ZSo88Aq6jBJ3DsNK+r5Yauvq4iBod8nVZ0dY3dR8bKfl4ggBGd4qAvd6uMphNkNfE72L
         rGteDcgOrZ6qICmQf7/EWyArxoNwg8KGOhP9du1WgxSt82t1U37CnnLtLJkp37ZfGFL2
         KNdQ==
X-Gm-Message-State: AOAM530jwk/u9wdFwVhe9TJeRkD3KVqDR4TSJNPj4xU5vtpO+vfI2oO6
        Y+Y2ZMBtluLQlO2QBflh7Yc=
X-Google-Smtp-Source: ABdhPJzvXr4rVs7IAc9WetFZ+Nr0r0V5W5MOmu6eUJyUodRskR/9nV3TiFtP+7uMljnOnBxmeSOeoA==
X-Received: by 2002:a05:6830:108b:: with SMTP id y11mr7841131oto.0.1613970385187;
        Sun, 21 Feb 2021 21:06:25 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id h20sm582339otr.2.2021.02.21.21.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:06:24 -0800 (PST)
Subject: Re: [RFC PATCH net-next 01/12] Documentation: networking: update the
 graphical representation
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
 <20210221213355.1241450-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a3db32c0-f2c9-3a9c-a835-c3430a0d5e04@gmail.com>
Date:   Sun, 21 Feb 2021 21:06:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> While preparing some slides for a customer presentation, I found the
> existing high-level view to be a bit confusing, so I modified it a
> little bit.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
