Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9201B214FB8
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGEVIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEVIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:08:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E440C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:08:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cm21so6594037pjb.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VbuQvSaQ5p42ISMOi2RZ4VadyiRj/yOjXA7FZmLIcSI=;
        b=dpq3DHVEZMP4dsQ5vmwQ3YVxXXtgezi/TwkYBJes2hv8o+XHHc/0jXZxeXWHIk1ooH
         0fN7/K7bfvCuF/e8g14PwNpLJx3owuk+XEMGdKMpbyQ1fQmsIYL8RRC5QdT3SuvNLmIX
         JumiJ+iI8xKpKgDr5BI32rQH/HHRAy6XB9iaNBUjTiEkY9R4y3gz4xeUWVHEHxyOYQIq
         +gfTcafaIKZCTQxx19XkQS97KKQGR3ebt0YuwoOJZFPOcxK5eES2TvBJxJVF+W9e73P6
         NVS/6tUCDyR6xiW9/4sVaguSBtuIDX0GRQZd7Pj0sde6I542jWCWxxwB3NmHIVLznySp
         4X+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VbuQvSaQ5p42ISMOi2RZ4VadyiRj/yOjXA7FZmLIcSI=;
        b=BWpf6XJ2i8xlajc3SN8Sc5Ym7YhHmUC6MoooJ9thNNtQYHWxnREiU57RkXh8zf3zEn
         u1iuPEjquysUcaoTi65NmqioYw9mk65wE1QzDGPlmSP38e5hLODt15YkUnYz0CQI63wJ
         c0woS06GfdNhuVaLgKo88JJEI6s50v8jaxsgwRHfifOZFjOsWLiSBvEP7sK8LYT40f9I
         kY4OCS3091odIKuFlkCsMwDDs3dEdUp+d5Rc2YCYq/u5+TDCh0JufpeIDkLWuHguduH0
         1T54/6q85+vk0Sfa30eagi9Vu0ekwNSA+ATiICIaCXjhigE2ls4TMS1BF01kDEd9nRL6
         jeig==
X-Gm-Message-State: AOAM533cA7XdphAIB9vhALpzB/DwUwZHZliyskKguutsJpCFWjdKyDoy
        iWYxy/ZIaLMpf1QpxPE3HPyhMmaH
X-Google-Smtp-Source: ABdhPJyf7kR9wVuqL7hcj0usnYS2lrjeGXiK/VVW1vxnlpw/RFy0D/QTrBQhxr7RKNoeHqmZ+IQDiA==
X-Received: by 2002:a17:90a:ad8e:: with SMTP id s14mr50616823pjq.36.1593983292375;
        Sun, 05 Jul 2020 14:08:12 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id p10sm11336923pgn.6.2020.07.05.14.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:08:11 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: vitesse-vsc73xx: Convert to plain comments to
 avoid kerneldoc warnings
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200705210508.893443-1-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b5ef254c-b839-51fa-1e25-dcefe28afc1c@gmail.com>
Date:   Sun, 5 Jul 2020 14:08:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705210508.893443-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 2:05 PM, Andrew Lunn wrote:
> The comments before struct vsc73xx_platform and struct vsc73xx_spi use
> kerneldoc format, but then fail to document the members of these
> structures. All the structure members are self evident, and the driver
> has not other kerneldoc comments, so change these to plain comments to
> avoid warnings.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
