Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281EB214F87
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgGEUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgGEUpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:45:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3377EC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:45:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id md7so968231pjb.1
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QjNU4iKi1hZrVwpppk4HYo1YZ4iBLSS2bIKEXMAp/GA=;
        b=Cbw1RPi/ikEDPxL6/FD3Zip3cM5NIgja1D5IyTU2vb7AlowiWBF7THQZXtvBABzAXQ
         XMV06h5n174RSCYC71dsEzm6X3PHy+BcFlWcOA2VPJ7GcyjOwedcJf47UWambaZ3Cu04
         d6IkC0WIlgYnDHDxFWsrUcdsKDIMizkJ9xDQEhlfJv02WydQpaa2xdmSoIWTJaLo4IKg
         JCMkTH4R7bjU1pfnpxyXPaiVElXg5kzXPoscBWoJl0k8TcOoWxnlJa3e2z3dOy8Kqf6T
         VaRVmetHgK5M+tC7C3Yae//BRiteAfP8AB5aV1wb3D0fpt/O+7Wp9d4xmiHizjMN+/Mt
         aj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QjNU4iKi1hZrVwpppk4HYo1YZ4iBLSS2bIKEXMAp/GA=;
        b=IJObYXuH0Cpl9wgztsxtB4izHhQz7/Y3IMcm5p+VZOuG+9aNKOgnUy1FwaD6qqzreo
         7Z+F9906glfEKCaRV9az/viCNq+tj3ApXJu3MIv/KAJELCPPxfHhUuIijbcBVaRqAPei
         8Kqq3tPDQindl0r6qFdBsCAn8vXEhDQM9X1MPie47lLTEncKtCsJ8Tk3htONzKGSvgeW
         EvEtSiO4oZA4IvE9xuNFmkAvHLA39Xm7sNET8a+ahP5+6HmID6l+KmpXRStYeG3Sbdy7
         lXCjbjWWm3Ilve/MnCoRLIWYnSR1DDRu0KcDVCd+595G3tol6CtFULpmcvPzVtwC6q8v
         Krfg==
X-Gm-Message-State: AOAM531hq4nGfHhes3iFiSFiLmg0K+wIXEiFNBhs+qdDLyOOyeXqr4Ww
        JSuMs7XNd+TK+oRVjhFgRfw=
X-Google-Smtp-Source: ABdhPJzrPWayV7aZCbnRSJ0PkEuFCupB7en273n7nfUqNu5NtjRVRnNLQBjBHoIVvu22Ke9gz6555A==
X-Received: by 2002:a17:90a:970c:: with SMTP id x12mr46914306pjo.115.1593981930394;
        Sun, 05 Jul 2020 13:45:30 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id z5sm16929759pfn.117.2020.07.05.13.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:45:29 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] net: phy: Make phy_10gbit_fec_features_array
 static
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-5-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8e27e3e1-8a59-59c4-49a6-757cc74dfc43@gmail.com>
Date:   Sun, 5 Jul 2020 13:45:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705182921.887441-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> This array is not used outside of phy_device.c, so make it static.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
