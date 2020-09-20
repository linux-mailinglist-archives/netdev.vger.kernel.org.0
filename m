Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E93271810
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgITVLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:11:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F1C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:11:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l126so7236815pfd.5
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pXg4ns9HnJh6CjP5E6H/mx9BP7VgqE6W4++/09ei8Xw=;
        b=bwfUKiSVONShK1ykBAlHw2xyJs8rjOSbINhDrH+4m52EwmAHgVRL7BOYSbSd8ibB5E
         dkG/V9WNVvJfplD3GdBQ1phH7AW/wzN/8cY+ZF3QUYlw33Fnt7Qmx9IrWGim9Sj4r/B7
         tqWY+ZZdUdNJ1eIFA7h4M4U+oMBaKPxDzB+oaDDht+wd1m2nLhKp0WAwMZ5YWDtaxu0i
         aXrDIxkMdR32hB0Pcei34Gl1WxRtoqqQ/aH1+ElLEQKZAMwj4yy0rh6FtWCQG/bmbQdz
         Wkp0R0mw7xOah1asn3GjHKzAMYYV2UyG8Gp2WZGHl6n1bxu098g/7bbXgjfR4FkOHpgF
         hnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXg4ns9HnJh6CjP5E6H/mx9BP7VgqE6W4++/09ei8Xw=;
        b=rbTEu9JGw98ePRwgaiPyK/t2tgGutb7tyQlXniKvvlVAp9Vjh/1ciiCgtD/hMUV22E
         upPw3peWnw6Czd1H0DjS1HM510Tvq8ZGh4D8NUHr7Ab+BfZ0nLJM+PkiB5KNh2x8+Ahn
         kapC0Qj7gb18W27YaYoZCAGr6dM0uANQRaTJUEhjcho2UQfldqHadwLOPYXD7dDQ8NhZ
         E/vYX6NkO/tUi3rm1jQnOYbFtLAsYBYHiK+Gs90VVkyoGcrWBxf1LowtZt9Fvxgk9LIW
         5Ci2L9zfGVAz22dRXgcZbgPnE+vTbqzf3Rsdfe1P7PI/tT86YEbCL7Y3ng1bx0b/7HRc
         AL+A==
X-Gm-Message-State: AOAM532938qpa1526tmVERIdJlDNxLD9jjFrOCKDB7DSpc6A81J97N+L
        koIYekfmhZFSpQkSBrgSbLg=
X-Google-Smtp-Source: ABdhPJwVC7fS+tKXBSyacVweYE6XE0j6ylWSLJQdlEJtsyeSohrzts9fxdqdjBeOjMpW86q3Fim20Q==
X-Received: by 2002:a63:1c26:: with SMTP id c38mr35693601pgc.105.1600636308668;
        Sun, 20 Sep 2020 14:11:48 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ih11sm8396516pjb.51.2020.09.20.14.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 14:11:48 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] net: mdio: Add kerneldoc for main data
 structures and some functions
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200920171703.3692328-1-andrew@lunn.ch>
 <20200920171703.3692328-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <207017f9-02f4-b9b3-49e8-5f2061181680@gmail.com>
Date:   Sun, 20 Sep 2020 14:11:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920171703.3692328-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2020 10:17 AM, Andrew Lunn wrote:
> Document the main structures, a few inline helpers and exported
> functions which are not already documented.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
