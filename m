Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480A716F863
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgBZHOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:14:17 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39519 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgBZHOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:14:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so1781462wme.4;
        Tue, 25 Feb 2020 23:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tHBKQjVF1o5AMd4tGNeBZPwVg8jWlWlgLtqnC3t3r6U=;
        b=WJtUSt7WhCY1pMEsR25s63qiQe8pA67vwulPCXRTQnOEzfERNPCX20AcxSuuMr5em+
         UKbRmoTNDqUkuTVaxYK8ivUDYSgwJ8I+7UNlH5KQVlI5PRYmrpNyyjUltldKE7F7Lv1e
         LSgd+QlBOvX6Nr+LLSYFcfA9GWEPg4th632PoaFKsucGXjerBBaJUb/nIbLsaaQTyQrK
         HCeXvs4Em4KWp+Z+qC5vWL6X/9PJF0iS5CcKQ5XxBRpLX9SdISX31yESHpBkfsX/LiZx
         WSW9UhEwG4NVm7CREe36HZwtEoNfA371gj3g7moqYiv8ycKz35M/nagz4oLuX1sUajmN
         eiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tHBKQjVF1o5AMd4tGNeBZPwVg8jWlWlgLtqnC3t3r6U=;
        b=eNZQGX6PCvnQdPIU46w+Vk8ItkdizsdqqRbahSXIKkfkkd8UQ24xQOJLhkP+dihfhR
         sOpFsgAoBEgyY/YUqxyYr2Hix1/L6xeYeuUtxjCuLNgN9MlWTcz0cPTZBNBpNJZtlOTF
         NQsJUl1dx/uk9rEx0fu1yH0JUPNcmFp6KQU/ltDAR5Gl7s7tUTt7r97KIj8ElTibnKyr
         m0xmmQMFUULICtXHWleMJyE+o3f3+H8tIH8iSkOi/0JOfD9wc7kX9KKxdplGH8JRDKqe
         IBugVJip/IEd2x8GdLG6v0C6s+e25LsyApBXKARlBXdjZikvKOewHhcIjFOVmZsd+A1L
         gT2A==
X-Gm-Message-State: APjAAAWIS6DDBUMC0Wpynx8fPl0Py6j0Q8j0gAOV5l4ozZ9s87tTRGo3
        e0IpBFX2/xB8uzLv+2/R+9L+d8sf
X-Google-Smtp-Source: APXvYqxwuGMvN4DNCatbQL98Nsu2Lfnz5yoBH73RmWgTZnCsWqoawCoqWHtrW02hKk+8gDgZPN/CZg==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr3742542wmi.116.1582701255290;
        Tue, 25 Feb 2020 23:14:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:e467:10a7:6ccf:340e? (p200300EA8F296000E46710A76CCF340E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:e467:10a7:6ccf:340e])
        by smtp.googlemail.com with ESMTPSA id h10sm1732268wml.18.2020.02.25.23.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 23:14:14 -0800 (PST)
Subject: =?UTF-8?Q?Re=3a_=5bPATCH_v2=c2=a0=5d_net=3a_phy=3a_corrected_the_re?=
 =?UTF-8?Q?turn_value_for_genphy=5fcheck=5fand=5frestart=5faneg_and_genphy?=
 =?UTF-8?B?X2M0NV9jaGVja19hbmRfcmVzdGFydF9hbmVn?=
To:     Sudheesh Mavila <sudheesh.mavila@amd.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200226071045.79090-1-sudheesh.mavila@amd.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4ab671b8-ab6f-8828-52e2-9b94439e6cc5@gmail.com>
Date:   Wed, 26 Feb 2020 08:14:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226071045.79090-1-sudheesh.mavila@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2020 08:10, Sudheesh Mavila wrote:
> When auto-negotiation is not required, return value should be zero.
> 
> Changes v1->v2:
> - improved comments and code as Andrew Lunn and Heiner Kallweit suggestion
> - fixed issue in genphy_c45_check_and_restart_aneg as Russell King
>   suggestion.
> 
> Fixes: 2a10ab043ac5 ("net: phy: add genphy_check_and_restart_aneg()")
> Fixes: 1af9f16840e9 ("net: phy: add genphy_c45_check_and_restart_aneg()")
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> ---

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>


