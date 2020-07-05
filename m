Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254A6214FAA
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgGEU4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgGEU4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:56:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE09C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:56:42 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b16so16102803pfi.13
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kytnAqiyAIiMZH87k6Kav/sWEIhN2SyziMibRp3f/Cs=;
        b=bTjq6V0Cw4aSJ8IpykhoUJCA1JIdccYb2C9ve/YqHEmocTz5hMZs6qLr5Kuaz7JpDO
         6mjjwIxdwg2kZ0AQb0XB1APUJZoildJQoGYhYgFrTUmMPmWFox21fUpVTruG08H614rt
         4FSpaKP8fjMe4K0CPVhBtKf6JqOWMfy5i5qRh61tWpuqLjLeSEarTBkznyYg02s1uuRS
         UaKaWgUYWxJPw27lfORhJrOYLkjb4ebsFa6oJaUrPMkIbb3FJIggAEnLkflELd+cK4ZT
         mYyUmwTjRcueI99fNo89a+s6FDuoxUtBj6dhbGlgmYnzwSg9bZKVO25dc+w4yKG6wcc3
         qlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kytnAqiyAIiMZH87k6Kav/sWEIhN2SyziMibRp3f/Cs=;
        b=Q64e/UBpbsWOyA/nKrg0/WVTSEmoYaCYn50cxn9nKUL9Nj8zOY5x8j8BqGwFI16q1T
         0btCRVziXuhQac0RvM8V80KBqZQNrcd2s58eOPxVorIt8YbQNNx6K6LI64LTm2f8z5pe
         2L7pMdsZ2F5Sj//bdzXcFW+dYOvJw+aRbpbJP4Exx0Kat2IxlwNgb+wvPHabXNirG43q
         DFjuIwjMvkUXNjTf9dyXj4bBFoNL2NDLdSIQrtBr99xfDcpuGrmsx2IDQDGQNvwDIRVL
         UpKB3CXPiLIakuQ9zkWCCV8zX8f9Zguqb+gSgINdnYfg3bCKEKIlu9K6BwBIHxFFJ9br
         31CQ==
X-Gm-Message-State: AOAM532r1a/4x94B7YXBGYOPBj1GAiWh/P1ep5IHncA6FUy6PrFisNkT
        k/B3/sArmwmE5GkiegFjtJ8=
X-Google-Smtp-Source: ABdhPJweY2Ey1BtBDY1F6z7GsrKiOVjVvntQKQt+g/JdeAHTFT7QYiUMRCIT4rUtiZyswngINETqdg==
X-Received: by 2002:a65:55c2:: with SMTP id k2mr36944676pgs.451.1593982601594;
        Sun, 05 Jul 2020 13:56:41 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id q39sm16492400pja.30.2020.07.05.13.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:56:40 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: lan9303: fix variable 'res' set but not used
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>
References: <20200705205555.893062-1-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6dac26c6-aa9c-2990-6c21-9fc2a64f9fde@gmail.com>
Date:   Sun, 5 Jul 2020 13:56:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705205555.893062-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 1:55 PM, Andrew Lunn wrote:
> Since lan9303_adjust_link() is a void function, there is no option to
> return an error. So just remove the variable and lets any errors be
> discarded.
> 
> Cc: Egil Hjelmeland <privat@egil-hjelmeland.no>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
