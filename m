Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F7A416803
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243441AbhIWWaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239507AbhIWWaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:30:02 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48850C061574;
        Thu, 23 Sep 2021 15:28:30 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s11so7772077pgr.11;
        Thu, 23 Sep 2021 15:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NjGFClgphH4uTkcVbbvx9JSSPvqb15w479MfvY6Wezk=;
        b=no//ku5b7snvMBl+1g518aa6fRx78zQ6g1vD3ki+ui5MOpQQfkuOypjKhAVZDTyvWe
         mXnCTJ/pDREsuRoYbI5kSqGg3lDvJHTzhonj1wmZ97Bgc0zMnc3aMcS6OgWnusGwK2sf
         NgKiQvV5Ni+3fmMuqnZdAD1pYAvFqPuEzgWMnSJv48hqjkNKj72rHF4C8VThbRJMbs8/
         sWfExLKVEEiTdfSAQdbW5Klb67tio4u8ywzq0BABXKKwxpXjZxHNGclhPMPPBQ1eFwJF
         HuO1BS3FwCR3KJuzWgqDRayU9EeMPBgEBBlhoxBnpSEDKb2G6WhwjAKLZnMTr0kL/aBa
         4CZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NjGFClgphH4uTkcVbbvx9JSSPvqb15w479MfvY6Wezk=;
        b=ZAbaOxQ3gTIHwVunnP3Bgnyfj9BBQFmlldPQ5G9QNtsRDIdGTivkFgbngVIZ/1KwHL
         FRmuV0Mf7c9qNRcntxmw5JPNl4OuTKt3faFSh/MviZB88SJVhBG4JYJLbgsTUXfMUB+Y
         XBr6CRyQPlNkFlaRcHq1garLEt9mWJrcBuyYtHOsX1M85ahkBoPt5adkIKU2iqApUcdq
         1B6n2QXYZ9JJ+k3pYFrkIPYqSAGzNiHsqTm7G0Kt3MvrmiOK5j4QLPeNYNcQMsJ8arkT
         fn7/wlB0k1goy8lKGiBYZxmDfrA0UqvdxFobFlsahRMyw1am5G9hBz8VZWQa8wl+LXqh
         eZCA==
X-Gm-Message-State: AOAM532gRCUrGx/uiJYTV8lCRPBMPSBXH9ylFzlXF4jnwmvQ6u2WFisP
        gMt9gaxhSH2X88M2tq45ec6zXPDF2So=
X-Google-Smtp-Source: ABdhPJyzhgFkF1eEIzYu1I4d7RfR6teqOQhwYLp2lU0kOIX1loIDvI/Mc+LOJNMKymdVps21FmH9Zw==
X-Received: by 2002:a63:f84f:: with SMTP id v15mr967754pgj.204.1632436109271;
        Thu, 23 Sep 2021 15:28:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m186sm5192300pfb.165.2021.09.23.15.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 15:28:28 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] fw_devlink bug fixes
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <20210915170940.617415-1-saravanak@google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b36ad72-a65f-bd65-abae-c06b673e9154@gmail.com>
Date:   Thu, 23 Sep 2021 15:28:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210915170940.617415-1-saravanak@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/21 10:09 AM, Saravana Kannan wrote:
> Intended for 5.15.
> 
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> 
> v1->v2:
> - Added a few Reviewed-by and Tested-by tags
> - Addressed Geert's comments in patches 3 and 5
> - Dropped the fw_devlink.debug patch
> - Added 2 more patches to the series to address other fw_devlink issues
> 
> v2->v3:
> - Split the logging/debug changes into a separate series
> 
> Thanks,
> Saravana
> 
> Saravana Kannan (3):
>   driver core: fw_devlink: Improve handling of cyclic dependencies
>   driver core: fw_devlink: Add support for
>     FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
>   net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus
>     parents

Andrew, did you get a chance to test this patch set on a ZII development
board rev B or C by any chance?
-- 
Florian
