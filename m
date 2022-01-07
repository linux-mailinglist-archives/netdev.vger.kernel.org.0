Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2D487D48
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiAGTsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiAGTsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 14:48:32 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FD2C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:48:32 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id r14-20020a17090b050e00b001b3548a4250so4417683pjz.2
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 11:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6eHOFenkayzoQogd1jCo62afpEjlKLE5y+yEBwP2OTg=;
        b=QDpgcA66qlRc2QAYGsBAJbYGb7qvLbql24noQEvl/cv8d8Inb9BkXWK4mukiQ2hJOm
         wrh3RQj8KiF7sAW3fngB72RrlQp6N7Q1T9bjpgo4nw1rVWsSzisCs5lZldXqAQ8OwEdX
         2+CCU4FOlOtlix6S/MrsPiLH6zRv8atPbeSHqM1PMJLxCdft2fgC982RjxsVLCti5TkN
         xwyEuBy4o7651BDTaYs5I2zhaNgPFEeVubvB7ix6N3yNBBhy3AJushzFCNXY3lu+l0q+
         uaTc3kgiJjcTGXesNnBtdDKcaI+k8NxzmJ9pePCwXkQpnzv7rXYeoPcAbakakia1O8x+
         XM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6eHOFenkayzoQogd1jCo62afpEjlKLE5y+yEBwP2OTg=;
        b=FmLAw3auJHjELVt/6zsLyufWM+4R4nHA3jRO4xpBXib6EQUFCELkEEgtZIYcvbodrf
         jWdIWdJuo4VYj6dmZR3FpeSboX4p0tiZWMNJDscm7BQu2Y88vaSF1YsEgqX1tUb4M7Oh
         W+i6meJyst7NP2xVu7WOWAnBNtZ+eVqmKqPDb8uMUxq2A7RS2PneCgWOW2CIzk5S+w0r
         tWLGY4BpRS6crlGUlbEEO2TbZpYfxTGHfiS6Xs852oUa9DZOLduu2PL0dVW+lqqAvKgY
         LpVoDlnXhHyTmrHiczUjeI2cHe/xZqHWlIDGldM9DUwHDtiJHOjp0kKKq1yEGvDUVtS9
         O0dg==
X-Gm-Message-State: AOAM53314hjl11hjzFxTE9rOQnEuHX2leniJfZdXMRcoc8zD36Y8uQO6
        5ZPljWtN9tn3EbzQUbztyok=
X-Google-Smtp-Source: ABdhPJxEnsO3v8xnN/w6SdC4g+UYsseDoi5pklzJaqJu+naverlHeYixOgBOzGdqo9W+M1jro7EvBg==
X-Received: by 2002:a17:90b:3ece:: with SMTP id rm14mr17404209pjb.6.1641584912222;
        Fri, 07 Jan 2022 11:48:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d13sm6940818pfl.18.2022.01.07.11.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 11:48:31 -0800 (PST)
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name
 and ndo_get_port_parent_id
To:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
 <20220107184842.550334-2-vladimir.oltean@nxp.com> <YdiWYydfY8flreN4@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <abc74eaa-dd76-a022-d09d-3845e7e9c7d2@gmail.com>
Date:   Fri, 7 Jan 2022 11:48:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YdiWYydfY8flreN4@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/22 11:37 AM, Andrew Lunn wrote:
> On Fri, Jan 07, 2022 at 08:48:41PM +0200, Vladimir Oltean wrote:
>> There are no legacy ports, DSA registers a devlink instance with ports
>> unconditionally for all switch drivers. Therefore, delete the old-style
>> ndo operations used for determining bridge forwarding domains.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Hi Vladimir
> 
> Maybe ask Ido or Jiri to review this? But none of the Mellanox drivers
> use use these ndo's, suggesting it is correct.

I confirmed that /sys/class/net/*/phys_port_name continues to work
before and after this patch, so:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
