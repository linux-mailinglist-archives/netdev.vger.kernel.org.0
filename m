Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0A33772B7
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEHPqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhEHPqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:46:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9063C061574;
        Sat,  8 May 2021 08:45:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gj14so6841443pjb.5;
        Sat, 08 May 2021 08:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8Nnb/EBgDVd13fINb2MqlRATV7+09CXnoK+lkzx35gg=;
        b=mdD8TDMZod/4BactuS9Vb095LRtUI+7x8KMvDlw1IxJmqYAcGHk5ep/fj/Lgv9PSMH
         nUZEFYnMFQW0cl6L0xPrwPyypimEQPTTHgcrjfTrIuSjEVsnnbMVmljkOSi2+AIzLJ2n
         Ikg3K5xwPtpEzpoak6AQsiIS6Rk4gIOVv0ilToMyXx58rVRYrxX8VUHOCqgI2ibh6VkA
         2QXRu6TfLO26F5hlLJ3pvQdWU8bCl4PPImtD79AgwzyzXWcR8gR8INAB4Iyjv5TTv81s
         rAewmsWlYS1i2Rq+UajtIUImiVDfsCH60AVe/4kAbciGBtZZ8hceYfo0NtS6BXft0Zd+
         dIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Nnb/EBgDVd13fINb2MqlRATV7+09CXnoK+lkzx35gg=;
        b=SCPVViIGj/GeD10Om3d/msFZLHWxPt1BOI/gdmqW91sHC9JjFsyibiIbSv+Bqkz/CD
         WMc2eDajMMywBjv/FWLsbWXU1X3t1mOtTiJLs4wKM+cH76fmD9enzbkJPZBy+zqO+066
         HpP/lzQMnvucHkKS3WgTuJnQE2jTO3gOnQ8wglFS+yrYSPiJ2ZyLPhBjRVnmi8YrgCO1
         JVe6lsDmpaAmITcXB5v9R+vkjr83UzPN/eNYw3AXq2jexF31qJzEE4kay5YFYQ18vb9r
         eABqu2GCPbWlrLdwxItYEApfDJm/uge1VpjaWIHWEP+zrGLH/BO9wSXocQ8eD/VAPlZ6
         LHwQ==
X-Gm-Message-State: AOAM533Pcy3PQdv8Ji0XR0McnOJbbJBdNYR9Pya2Ajofg7IAwfMTSfLa
        N7ZV+xnGb+TZw5TigEFwxKp5or02jqA=
X-Google-Smtp-Source: ABdhPJwX5li7LiCdDlyEmcl49R+8n1wlyB8paK2YMUWfUqTQKXnG8CQK2ES6oA5qfKTAbaeqtAlLkA==
X-Received: by 2002:a17:90a:5806:: with SMTP id h6mr16869185pji.14.1620488740912;
        Sat, 08 May 2021 08:45:40 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id a12sm6043561pfg.102.2021.05.08.08.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:45:40 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <be194ad9-4f9f-3f0c-a300-8d87f0b12528@gmail.com>
Date:   Sat, 8 May 2021 08:45:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:28 PM, Ansuel Smith wrote:
> Fix mixed whitespace and tab for define spacing.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
