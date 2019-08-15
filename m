Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C68EF83
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfHOPhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:37:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38475 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730491AbfHOPhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:37:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id m12so1203174plt.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z69VoiD9o73spuaSt0NrfWgQ9XFXXmiaAMulsAAvFJA=;
        b=eyEY9pMyCjp5nWzV0WZE5Z7T5SdXEcbbM7/r/b1YVqL4RkiqC40C5r/BsbYo2oWgEc
         306RfGNf8xHBKPIEY6gnHSLeyQqF1fFjQsGx+vEqGopuG3k0nKMCoFQyiGY/BC6c4HEt
         yKah0zocvcvdYeO5cTabkClbAx11H5PmAI5/gM0IMuq1haFc9Z/IsbKm3yyOG73Bfbk3
         wt0fMwDn87G8VV45UqNuq/0rgQXFPGw6pnB4PXO4js9CutiI0mj0+JQ8le290D6QD1IN
         Le06/yDeu8yya0z/VuTC63wwW+8dqpRD8G+EEXkj0BeTyWp8ocfjqS251vM8u1VvbG1L
         v5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z69VoiD9o73spuaSt0NrfWgQ9XFXXmiaAMulsAAvFJA=;
        b=sdUpSb54WBsQMs/IX5oPqaKcXZTEWyfooJdgcNNfIv3reVCfQXNbaNJ2SJI3uZReco
         ZoCx+MrtannM+AZVEh1sjR2ietn4cd+v+wELa6hnvKyFHcknc6xUIo6ia/HxqyPwPxgG
         3hO5w320TnRjgR0jDUfBtEnZc2TTudkMEfBxPrtRBX74/K19QNURW7S94flSGUlcW8wl
         Yi2s6blqSOVcl7Snf0rKzeZ51BIiVvR8T5YNputagRpL+VVV0E6T31KBB1NshPd5T9CR
         Cs33MPBrV426+8fUH1zJPQp5RWoeH1NcyHOWpZZAZsRWpMgKe0vJuNNLQvSptldWkTJG
         co4Q==
X-Gm-Message-State: APjAAAVt+Rt6cJ4Wgcvj7bN8umTKhpG7N3bO/1p4B4bEH6QRixhyRUoR
        x0nc6SCF1e0X2jcopxFl2CtXvO0O
X-Google-Smtp-Source: APXvYqxELm5IpYYeOGsbri/0IvdPSnxwyFhSjdqXdkgRABCtvvRGKPFpzijvZcrvzTk4V7RhsEs0Sw==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr4913633pll.102.1565883449603;
        Thu, 15 Aug 2019 08:37:29 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s14sm2977343pfe.16.2019.08.15.08.37.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:37:25 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: swphy: emulate register MII_ESTATUS
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25690798-5122-d5a2-7d2b-c166b8649a2e@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <347edda6-36fd-de73-d9fb-9fe5d3628b05@gmail.com>
Date:   Thu, 15 Aug 2019 08:37:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <25690798-5122-d5a2-7d2b-c166b8649a2e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 4:19 AM, Heiner Kallweit wrote:
> When the genphy driver binds to a swphy it will call
> genphy_read_abilites that will try to read MII_ESTATUS if BMSR_ESTATEN
> is set in MII_BMSR. So far this would read the default value 0xffff
> and 1000FD and 1000HD are reported as supported just by chance.
> Better add explicit support for emulating MII_ESTATUS.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
