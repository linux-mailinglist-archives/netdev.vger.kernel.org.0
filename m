Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C71D37B6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgENRNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726032AbgENRNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:13:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F9C061A0C;
        Thu, 14 May 2020 10:13:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l18so5263376wrn.6;
        Thu, 14 May 2020 10:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IF8Ki5IlJmDfGWXpvnWsTxxWq1hehzYSo+Qr+oMt2Z0=;
        b=YVAWLtGyA8IStGobc6Np+B0DqYsQgG4a9IntUyAoFxRiqqCmFGgKQUtUGe+9Ut0QPK
         HIsTq+Pa9oK0CuKgwObt7FuaJyGf0jJOd3q3DKR8L1aNqaOEeiUnGTcO5qVsKdmx0RC2
         QAQ7Ec+lsKn5/9dVqTuw5JjbByExL8+IiMHtZHVpckeUnpPHAMILVpOqqYwDTYRcxp4x
         aproeUhw4vmsUX8AT+oSousx+LNDC21tmwN0g/IKojVXIEpMJzCr1+a44ZPzL+Ag+X2y
         Pm5UYi0MRgAWlf8KZgTMBphQj795IZR/J1S/zdEPJVO9VQV5ED1YOekHXLoAn+zCaui4
         tjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IF8Ki5IlJmDfGWXpvnWsTxxWq1hehzYSo+Qr+oMt2Z0=;
        b=PF5qlnske1pn8FFVfBDNwCTTsM/4+Xt0mH9uDsx1x5hxwZ9WIdkD1DfByu6o+khZc/
         qeDi7cuzci/YAKy4NftacXHfZZLRBQCyjkF2WVMYW30COZJEp6AyhuzDZ7C4Cd/4sxPf
         zBjjIevEiuPz3a6e2AvrEu3KkImB3zR/rucPwmxP5YXsi7uCOcUfzL3J/bA9soJwO1Ig
         XsEhYuHkuzCc33r0JfslMadB/qV0OjDPUFvh2lpH+n217FNikn9J0vpO/mnIcRXA8sF8
         LkoNkPyub6rBDDMqELh+a0DauwR8MQ2kAItMCZg5arRBsbyv5LXbbkC1QscDNuJM0qTp
         uvDA==
X-Gm-Message-State: AOAM532/ppHWDCMWJwhXT4phItLpoe4/vYqcsf7corNLeCiPwXgcd7xm
        RYBHzR+gczyrA9Z1kftuQzC7kJ3t
X-Google-Smtp-Source: ABdhPJwJIGaaAtyx2qFPvj7ZGgx53qTYgdTvqwtZEkplNTBmG5Hqf357izSZbM5oXPFyLo0s18Ox5w==
X-Received: by 2002:a5d:560c:: with SMTP id l12mr6362645wrv.309.1589476414053;
        Thu, 14 May 2020 10:13:34 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c19sm5109706wrb.89.2020.05.14.10.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 10:13:33 -0700 (PDT)
Subject: Re: [PATCH] net: phy: mdio-moxart: remove unneeded include
To:     Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200514165938.21725-1-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8fc8ea34-a68c-8fbd-3821-d073c08444f8@gmail.com>
Date:   Thu, 14 May 2020 10:13:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514165938.21725-1-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/2020 9:59 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> mdio-moxart doesn't use regulators in the driver code. We can remove
> the regulator include.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
