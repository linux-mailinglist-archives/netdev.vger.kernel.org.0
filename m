Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E5A2B8A5E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKSDN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKSDN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:13:27 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DDFC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:13:27 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w6so3096445pfu.1
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AzkGS9+FLXJSVRmNcQRhi20e5HCzfgE84GbGq3Tjfgw=;
        b=NqDdKB4yF4YX1bqLsmcrbWX7ybucZnurweZkxdVbEg0iQxq0UnG3nS4/+Db2wJ/LNO
         m8U4qVYRynpqVmtMvAWPrYMJmpWcTb9jTicwLqMIcuKF1aumE4Rlc71xRf5UYfPQULV8
         1VAauevPHZBrPdSLOr7l9LJPUQUkI6cdkGHRGcMptoX0Yxi8gk2cx166GThGmDS6gFju
         RWg+Mnk++iAq8jHUOJNewFe4bUHlBfMM35LqVL8iGSMaKQQGD0MHDUI+cdfKksyuscE4
         zMB5G/sW2iyGXYAReQzmtsoHlINUm/mQdvfwyGOor6etJA3vbQWYaRn5og2yloBBoDum
         uidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AzkGS9+FLXJSVRmNcQRhi20e5HCzfgE84GbGq3Tjfgw=;
        b=RMk5/ZlOywrZJzoAZlnxLPA2XLdN7gwZmdeXj1/mmWew9nVVtQcy4KYn9+qNEXe7pK
         KYR0+jsyAmmQpXkT/54hVZLYkgYyU+EKEmw/adEpBnTkgWL0ik2rhTeZ09Qzp4kasZ1o
         waZWR4sdpljgsKEVZ5GYsTh4dRWemxkrQi6D7Bx3Xs0VFT5CaxhbllTSC53vRHCL/9VC
         5kIWg5EgvkH8YDlXJccH+yVWZ+6TOHwXBn05FXsJc16FbsJVU5+rkbYXPrtX5rgjrkr0
         4VqjCjRX7r90q7tdaQkGkyIauYNBDbgjM89i3LmSIZtdde4PYqBMsDpB2nvZ4yzKFT7O
         O2ZA==
X-Gm-Message-State: AOAM531X5MaFbGpmzQHa8oF9i4qOmXGddz1Q/Y0tO7ZKIHo82MfM5s1j
        XAfoFrsguIa47CxkYrj82Jk=
X-Google-Smtp-Source: ABdhPJzwKijUuWtpH68Y8zCm6flOiWRl4PpJvO+XteFkroL8+frR2gJ6SDGqe2u5MVKRQO1ZU3ZwsQ==
X-Received: by 2002:a05:6a00:158b:b029:18b:fd84:956d with SMTP id u11-20020a056a00158bb029018bfd84956dmr7513650pfk.22.1605755606713;
        Wed, 18 Nov 2020 19:13:26 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u20sm18248760pgo.22.2020.11.18.19.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:13:26 -0800 (PST)
Subject: Re: [PATCH 08/11] net: dsa: microchip: ksz8795: align port_cnt usage
 with other microchip drivers
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-9-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <aa7625ca-9c22-1560-3cad-71b10ab032ae@gmail.com>
Date:   Wed, 18 Nov 2020 19:13:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-9-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The ksz8795 driver is using port_cnt differently to the other microchip
> DSA drivers. It sets it to the external physical port count, than the
> whole port count (including the cpu port). This patch is aligning the
> variables purpose with the other microchip drivers.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

With Andrew's comment addressed on clarifying the intent of port_cnt:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
