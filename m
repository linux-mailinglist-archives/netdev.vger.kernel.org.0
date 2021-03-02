Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944BE32A2D6
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837676AbhCBId3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238870AbhCBBmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:42:42 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6D5C06178B
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 17:41:49 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l2so12834612pgb.1
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 17:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CS8ni2TEJ98vuSa1ZYVCDS6wjRLBzxdcY96jO0fmQ8E=;
        b=vR/1IgSS/HFUf2OUS3jGx+xVqy0VtNq+k5jJFgI1NYvEO0uKvmb6HPLbpIS8kywiwO
         p97xegHP/hL7qIa15jEZozxGEY/EvwXksQqzlHBSth66ujyE2eKnHzaHx/u11+I6XprX
         Ou4LBphb0oA6Bx5sUHS09j3cypZVQJvwUOD+sCl0sfKj5ARD1jgBnykZH0Xqn2JOFliN
         HW+iHmjrtrG8P/mDiW6UgahfGAa1NU5Obkd4Xb9ZToBIYAxCoz7sLTL08PNUHiXduZpY
         aomaGEJ2RvkG+yqwnRkC2f2G887CKFuHLae5DG2RTTNI2YlVXlR2+gutbi/hnO4RJ80u
         tAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CS8ni2TEJ98vuSa1ZYVCDS6wjRLBzxdcY96jO0fmQ8E=;
        b=hO9TZxjIfNyQ4kEdUfOpquEAV7pYZ7l9WeYnlQNPLiFvfnKPKjYKxucqJA7Ul+7141
         vaVRia25q5VIwemCTBvuV8aJgApt1thUhwJDqrGMkaDQNYdU3F3FQhd7CURBmmhFBKIB
         Va/1WOzEjB5PPKzxxeD8UfkSbl4yixDIMBN0i01snXuSHrfcK7MAN/LTV85O9zyq1nN6
         axCPM62wbK5uxEfe1nk2OFXAsxgby+6bCROhVzo+eB7XsuogNa5D7OrwPknrWYJfYCoT
         dzUum5OlGEDoStur4ip5T3ZqiFkDWwKVgLEwJLgzsXgfDVTU0+zvZJxToXBCGM7Sx+sW
         3ydA==
X-Gm-Message-State: AOAM532R4jGrfLuoRjRl4IBxdKC+hR5OpPgfc5vtkvXaJLyqQ76aZWNi
        aMV78agyQlxbr/OIK1RE/4IOWgDu0c8=
X-Google-Smtp-Source: ABdhPJwtPb4fDOSQibFrF/q6ZzLMhrTApRbIlDIQx/ZlL5c3862qcXs/eJ+MIIXfdk3A+PTvcnRwoA==
X-Received: by 2002:aa7:8759:0:b029:1ed:81d4:1b88 with SMTP id g25-20020aa787590000b02901ed81d41b88mr1135817pfo.6.1614649309329;
        Mon, 01 Mar 2021 17:41:49 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v16sm17795621pfu.76.2021.03.01.17.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 17:41:48 -0800 (PST)
Subject: Re: [PATCH net 3/3] net: dsa: rtl4_a: Syntax fixes
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210301133241.1277164-1-linus.walleij@linaro.org>
 <20210301133241.1277164-3-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <67e87dae-623e-fe9d-0a01-447b1eaa1c97@gmail.com>
Date:   Mon, 1 Mar 2021 17:41:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210301133241.1277164-3-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/2021 5:32 AM, Linus Walleij wrote:
> Some errors spotted in the initial patch: use reverse
> christmas tree for nice code looks and fix a spelling
> mistake.
> 
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Reported-by: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
