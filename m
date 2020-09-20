Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D555A271806
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgITVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:07:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AF4C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:07:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k13so6712299pfg.1
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vby7GK3Nj+g5y39sYAVwEF9r/CziPdSEl8kDhns5Gtc=;
        b=fi1yh942/AWWI6opPlFfnA8vDPwqKA/Ecv0yPHmGT8VlrTsqcMbzihQnD2cwD9Do9T
         F725Bmqfpo+Fl5b3b2FeqKrzKLxWAGZt6x761lczA90zoxhkraVb5L9YNZbSLerHSbNe
         0m9/rCbzXkBlbBHVxbM8nYNFVN5q+LAOxq/WiT9LV+5cU4F9mv9LyFtlw0TWAcKO/UTi
         PEzrqK61R06gLdvZmVUj7C8958ZetXlkPZAOdh+tiCR0egU2XHT1uEZ5cSzwzuMCJLhA
         k4pPljuUlXQmFoquimPo60pbz7cT8z4xP39VLC99Mxj9lEXAbXQB7A+hGHuTDy9ilIZ+
         FYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vby7GK3Nj+g5y39sYAVwEF9r/CziPdSEl8kDhns5Gtc=;
        b=Ke0tjBJn8c9SbR2yxMEqj98tDqMp7asILBSv5vNwuJoQydYf7YILL7HLXhQa+pxn1u
         laZe2oGVzS7HnRP58JSmEXPh69ds8qAJvfw+wpA5ga9AB50vomQxCT7rL0AWQ+E/dJhF
         79KCIHg0nnd3kdpRuW2oEkWZb0LmoM2Hrp47XHESgnPQdiqvtJ3AHj2Q8d3pJskIxu0p
         deHHNxutqOjNM5La/4PZcSeiSOGE9i1J6ynJhhfSVgdCFpin66DxNDuUOpSEGxH3bEX7
         JwkY/F8DTk9oqI/0pY7Avcj0pp+5DaKhcr9yX00lllehf3aqLIHLaOoHX8CQZPL+YuYc
         qTRw==
X-Gm-Message-State: AOAM530LthPs+gC4nF12l3HVX/SBr3ewrb4WwUdrI/bddhX7ZiZHo6sH
        0eKG8L0o5nibk0Hbj17mF+U=
X-Google-Smtp-Source: ABdhPJwX3T9PKF5+H+1e6G04rh5pJ+fAtzqNQJVFraaUNLkjawhAGKapMXMdzedHwlXNGzJc+Q2Vzw==
X-Received: by 2002:a17:902:b20c:b029:d1:e5e7:be0c with SMTP id t12-20020a170902b20cb02900d1e5e7be0cmr24030774plr.63.1600636070181;
        Sun, 20 Sep 2020 14:07:50 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b203sm9801616pfb.205.2020.09.20.14.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 14:07:49 -0700 (PDT)
Subject: Re: [PATCH net-next 3/5] net: phy: Fixup kernel doc
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200920171703.3692328-1-andrew@lunn.ch>
 <20200920171703.3692328-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3d61e723-fd20-1f20-2f70-88b0f9d7e6e1@gmail.com>
Date:   Sun, 20 Sep 2020 14:07:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920171703.3692328-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2020 10:17 AM, Andrew Lunn wrote:
> Add missing parameter documentation, or fixup wrong parameter names.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
