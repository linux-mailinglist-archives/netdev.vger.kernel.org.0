Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4A1221A83
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgGPDFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGPDFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:05:12 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4DFC061755;
        Wed, 15 Jul 2020 20:05:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ch3so4088038pjb.5;
        Wed, 15 Jul 2020 20:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VRaDJFSpDB1j9cYnlOkV3GqLs06ZARLvdLNp73gpV/4=;
        b=bm7Tr6ZMov6x6UpDeaUWjgxEamYsjSqxR7mYmChJCRR6NTWOk6qo8y+GxqUOB4RD+H
         Tp1LARqEQQVULijLfILA5UvW0x5n0cxweaYYdJ1DMXwjftehCLBe2iGvR4FYKELv8Ts+
         RGqRNTYuLKq8zUyxmP9/HMTB8tvIAreVxqAOoiHmzBXQDO/9Hc8vVD9tPIHLi4wT+Cll
         qg0uCpdMf9fNrH8oo6sAeDolTud7e3Zdiy2doIIdBWgUW+JObgE6TGdSycjlWsjSmjic
         giPItQSGTF4FR1jRZhcUeCuzMiYX/mYiw2rtw6A+GiPdTRmXUdqus4Lb6vV2McXrtKOb
         8Ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VRaDJFSpDB1j9cYnlOkV3GqLs06ZARLvdLNp73gpV/4=;
        b=WwIvGblSBMyhH2EMfSuESuoKbbyGBYWCedqR58E3GkD6q1w1XKvsjWS8r1sr3qVVwa
         8ruYKL2ZGc1yoHhkRmkuMSOS1xC+C4tLKwsm+PRSw0ApQOu/eHWjTYq/LPvb1UlzbaP8
         cT4bxbmMNlN242fnMLedtuvZVm8l0O/8hIy2ukGSOjFGijJ0tBa00BroFkAxef5mvilv
         OozUN91v0eLfq91mnmqoi6P8Ei8wdA8dfYawt6cyRePo1nJp53GnZobQt9m+Y802WAoJ
         4xON1qdMmuNP2YHUHe2XaUscVEjA8jWi3d/eVK2WMhN6DoJflWi4D2suah1RY3x/nz89
         TAaA==
X-Gm-Message-State: AOAM533vq6o15rmssEwIZNyTaLQP//hauyMhxRuWC1pnzhvDbbj483s+
        OyHgatLDyAQl+gsS61qPbJOL+K1r
X-Google-Smtp-Source: ABdhPJwwiclSNNPwU7AU3JARWWNyMpn8riMGUPXwtRZNIwy5/BZVqdkQ4eE2KBu2ptAcng9iwCgHJQ==
X-Received: by 2002:a17:902:10e:: with SMTP id 14mr1833218plb.297.1594868711851;
        Wed, 15 Jul 2020 20:05:11 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c132sm3189809pfb.112.2020.07.15.20.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 20:05:11 -0700 (PDT)
Subject: Re: [net-next PATCH v7 2/6] net: phy: introduce
 device_mdiobus_register()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-3-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ff18f607-b62e-41c8-b452-40485f449625@gmail.com>
Date:   Wed, 15 Jul 2020 20:05:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715090400.4733-3-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2020 2:03 AM, Calvin Johnson wrote:
> Introduce device_mdiobus_register() to register mdiobus
> in cases of either DT or ACPI.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
