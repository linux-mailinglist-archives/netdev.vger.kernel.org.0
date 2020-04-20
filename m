Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A3E1B1449
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgDTST4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgDTSTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:19:55 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1CCC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:19:54 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id a23so4258309plm.1
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+7Q/wlivJUTL5EHEkQxh6IjKR1UaRZCz+crv7wjFOzE=;
        b=hk7lAfIR+mda0y8MViOMJUEoZRbYEEO1qgpYHlDyNH+A+lP3T840CQCM70PgVhrxTI
         bQ7MZ3GBi9B53VWXFj46meTqgjSYbkqMRmQlGLPtdVGcK0bdR1gDxqPb6Cp4hGKmap7C
         ABM1NAACvpXwy+kK/cVLhoZB7lFbK9/lgQdWuAfGg12dVlcJy8tdJefbRRHhr6zVjJJ+
         yK5HQjoKQAcSDrgftVFlV/c7iACANlAPF6l8SsINyRVChP0tg2ryEse0mUcQ95djzGMz
         RyD73Oebl7jVs5HftXtqlCyMViODmwZlX7fELOJYO+c5s88bHfuKYt7TLhGpdIQNCUBk
         llXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+7Q/wlivJUTL5EHEkQxh6IjKR1UaRZCz+crv7wjFOzE=;
        b=rgnd7I4Lb7rmFRDT9+OPKT7eHUOzdQq7Qye25/hp6h6mDcTHH0TOSMqrLULd1siEpl
         pSu/6km/2ozm+Jz8m8nRknwz+imEVWdlvr3Lex6YCCnNQPEdn5HBDt/Mo+eQCKTgKLa7
         p/8quT++BQW7gI+YoQyqpElh539CdW9etVS1kRlB/EW9QDYJyR/dc0mzV+jutHTyiG8F
         kvWMqaD34w0ua0aTx17itDq10631Noapi5HVcHcz83y2er86BBLRrD1sUpv+9rDT3cU0
         SD9z1nhfwGWs4aACejwniS91b9e39OEgHmy0kS1KpvPUG2A7Z+Fdzwyz0hZI2EAnPMfR
         AmjQ==
X-Gm-Message-State: AGi0Pubp96Yy0V8h6bPwSYr/QxwkjFhrqh5I1fkCEoPmdyIj2+wF4RGk
        OSmNFh/gsOLYb48wH1QhQihC+94u
X-Google-Smtp-Source: APiQypKkMjtEX31tMkRRYC3IbeodoaGXmDcs1J0m/609KBUXZ00sp4fKJBIYeqbOxP8dt4hAPY1P3A==
X-Received: by 2002:a17:902:6949:: with SMTP id k9mr5477720plt.211.1587406793699;
        Mon, 20 Apr 2020 11:19:53 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 128sm139953pfx.187.2020.04.20.11.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 11:19:53 -0700 (PDT)
Subject: Re: [PATCH v1 2/2] net: bcmgenet: Drop useless OF code
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
 <20200420181652.34620-2-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <452b0089-1f01-2100-3ef4-44998a1559fe@gmail.com>
Date:   Mon, 20 Apr 2020 11:19:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420181652.34620-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2020 11:16 AM, Andy Shevchenko wrote:
> There is nothing which needs a set of OF headers, followed by redundant
> OF node ID check. Drop them for good.

After commit 99c6b06a37d4cab118c45448fef9d28df62d35d8 ("net: bcmgenet: 
Initial bcmgenet ACPI support") yes, this is true.

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
