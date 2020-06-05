Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3511EFE04
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgFEQai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgFEQah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:30:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FBDC08C5C2;
        Fri,  5 Jun 2020 09:30:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h95so2962331pje.4;
        Fri, 05 Jun 2020 09:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TEtap2IudhjHNV1R44cbxJPCSzuQYPIaYyarMsL3gsY=;
        b=YvperE5/32+idN/P44Fgr92aBDG15eDLFkcXHmVCkM0qF2C81IrIJG433jg2Nm34ZP
         udRTXKwZH6x6eGUrdFOVRtMQ7jlY4yoQDeeesMKy7PJjAAzNbgd40RHdqKWbvW/Gv2BL
         V6N/A3gkf92gPsznR0sDmGCPcy0o2J8fXka1cZ6wSUJijs/3sWWHnwBoPKfBE4ReFugd
         dYVD7kWGiwuqm88ZdkwvG13dH5NdiVZwD8d4aFTSUb0bK1R6mbkx7U0DG+Jcly7RU/kM
         DTN9910iwmwAALh9gcaEpb3dFSJaHlLKbGpwErqlSgg5n0PEZc1Vq//yKFLHchvGqYuN
         w5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEtap2IudhjHNV1R44cbxJPCSzuQYPIaYyarMsL3gsY=;
        b=jZ0cHPUYj5EuIlvr+TAlLk0/yMvIuy2/YzFxUtuaM5hASYKQ0VyRjqdOI8F+qtGT9p
         OyMAfJ7o+RJ/XmssdIHDp5ijqa+K61UcGWUHurUwHVSeAJFDz4+zLKg05KybP7FhTJud
         QOsSlCpOt1eUcDDKT2jWaYC63LC8LEZkZ8lPvenzTekAayL6/vceHImmOCqPHojS9J7r
         7cqA+LyLPPhe+fvxVxLipgB5uk5rq6pqX246ntuVE3+0h3aZjDM7XgyU1DtN0SAIEStU
         qyAyEsjgMl4LOf2U9PANrDHHL6HtCx7hpybHLcuoxRqwfBH08pn9qX6Vp9D5t38XJOTa
         k+7Q==
X-Gm-Message-State: AOAM533FptJo59xrAgqkUkmF5BKQkMMJLv3xuH9eCrWiIeqvuld0QP8T
        23mfghuUcJy2ymmaWVjne7PtyIAX
X-Google-Smtp-Source: ABdhPJz4gAW9/u7XyPT5jIJbNzMzYMaynXPP7tqHwaRi/wdJhcFdrQ5ahmEovRCpLbY2l4ObRZDgQQ==
X-Received: by 2002:a17:90a:dd42:: with SMTP id u2mr3974672pjv.65.1591374636887;
        Fri, 05 Jun 2020 09:30:36 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m22sm8454678pjv.30.2020.06.05.09.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:30:36 -0700 (PDT)
Subject: Re: [PATCH net 3/4] net: marvell: Fix OF_MDIO config check
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael@walle.cc
References: <20200605140107.31275-1-dmurphy@ti.com>
 <20200605140107.31275-4-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <931e6169-580f-b58d-664e-23f79e0a3242@gmail.com>
Date:   Fri, 5 Jun 2020 09:30:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200605140107.31275-4-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2020 7:01 AM, Dan Murphy wrote:
> When CONFIG_OF_MDIO is set to be a module the code block is not
> compiled. Use the IS_ENABLED macro that checks for both built in as
> well as module.
> 
> Fixes: cf41a51db8985 ("of/phylib: Use device tree properties to initialize Marvell PHYs.")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
