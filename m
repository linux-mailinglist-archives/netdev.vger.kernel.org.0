Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B892C184F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbgKWWSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgKWWSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:18:14 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB93AC0613CF;
        Mon, 23 Nov 2020 14:18:14 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m9so15577401pgb.4;
        Mon, 23 Nov 2020 14:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GYhuGPhf89PyGdvpdtJ8n6aqotv2Tg3DuKVSdph64gk=;
        b=LXK4rgvTErDYQaaXeSd36XRDF9sH9fsyBq7dFoX5wPJJKprOzv7nvHZXVdYwmGZ/Wl
         DISjwPO1/7z4Ho6PNGO8jQVaNGFLGv+/LOkYmLaLpNKoSxd4Jk/qeEQnvypP1dXy9KvM
         VUN38NQ+CiEUzowSqUs/qmILEctIYlvql/uXppilzqbD5DvabSxWOm8qKX94+zuYoiMl
         xSEzgrW9oyiUTqetmnSXeV2/peOpTWWKfmfAkmb3LWMTOxFSyXutlX7xgU3LJDa7yH8o
         jANAdFRRCbe8Ik/mSouY2eI9OAm4zgHTXMIRpKZqUFd1vpcV3Dxa2wV2NhAfQyBdFfnX
         aQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYhuGPhf89PyGdvpdtJ8n6aqotv2Tg3DuKVSdph64gk=;
        b=FuIgB8diZnCYbBBOhrI280qfjGk++TGnqJuAa8FcCSrfSFKbiNZRwhmWXHLl5p8Tj/
         kXtfa9e0H6QiB2lHEsKneryfjybOciOOUemmi8C9kieYaT0xhZ0Vr74zuM+iLRm7SjPd
         ZCz6noPqckwM3fS9MmeYHib5qcaneeAyrrf7G5sduY4N8zOH58lF2Rm26yw1cPteJx4c
         Z1Vj6FmVn9JPYkXrlA4ci3SS41svohtqK0jZUPhMV2htWCKhxX01Zcr2vTJjXe2Wa79U
         f+3odPDc+I19X7mj+V5X90IACBtkwJ3JCKJns+3zDRrHY0WX3lvPo3htKjdeuRraE3WG
         PiBQ==
X-Gm-Message-State: AOAM532sAFy+ZjBBIQxBeu8VvS38pRmzXC964jFVgXg8bqKgJoFkciCI
        kXOItkqMWc/bv+ETbTsaRy+jFO9I5Rg=
X-Google-Smtp-Source: ABdhPJyqRjpWi0jwtkXyFNIbYj8fSqTzfpsF6heRSWgrv1foX8hhZAUGrR1mZ0MREY+4rbqOtM+EAQ==
X-Received: by 2002:a62:9242:0:b029:197:e5a1:922e with SMTP id o63-20020a6292420000b0290197e5a1922emr1349366pfd.4.1606169893948;
        Mon, 23 Nov 2020 14:18:13 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z126sm5253833pfz.120.2020.11.23.14.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 14:18:13 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] dsa: add support for Arrow XRS700x tag
 trailer
To:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-2-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <919273d3-6aa6-33b3-a8fe-d59ace9b1342@gmail.com>
Date:   Mon, 23 Nov 2020 14:18:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201120181627.21382-2-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/2020 10:16 AM, George McCollister wrote:
> Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> is modeled on tag_trailer.c which works in a similar way.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

One question below:

[snip]

> +	if (pskb_trim_rcsum(skb, skb->len - 1))
> +		return NULL;
> +
> +	/* Frame is forwarded by hardware, don't forward in software. */
> +	skb->offload_fwd_mark = 1;

Given the switch does not give you a forwarding reason, I suppose this
is fine, but do you possibly have to qualify this against different
source MAC addresses?
-- 
Florian
