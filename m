Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5271BB4FE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgD1EHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgD1EHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:07:43 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8603CC03C1A9;
        Mon, 27 Apr 2020 21:07:41 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x25so1131356wmc.0;
        Mon, 27 Apr 2020 21:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LSKLs+uH/nXJXVRVF9wLRK1/PW3bgortq15p+iwdX9I=;
        b=MIiTkf5iKNGuIMwLqKyx7DEjjzjvUMovzaXbiUoVaDKJsqXWuXjZKOk6xVZn1TEcb4
         CG9VeNNsaNMZtZTWr5WC3tggHz5Yrqh60YqPa/x9Nq12tHykkv3QZ85KIA23PYf+H8IE
         y8AIvBGTfLEzFc5DXqOr2Csynmv+ZUbsiTzbu7ctaMgyxTwh4K0Qe6ivUXthNJg9kRfF
         9UnsRxGnkJAtYSccPc6eppmNzy19Ertmn6uu7oV2KGm5ymZVBlJDX9DlsdMPUD/3r5T3
         Nu8nZKJvnE3Uh2KVpRJSQrdnI4rBHKULgoEdhZ6acfBwHzJrTBcdib6cCyndKg4JxLCo
         kr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LSKLs+uH/nXJXVRVF9wLRK1/PW3bgortq15p+iwdX9I=;
        b=KLYRqHscVnOk2ewdcYG0tPw+AXHNf1XSvymLJDYKvzm5l+Ck3AGmouANXpdN65x6Zd
         bjGv6UUcZqfj7vVYFoFK2vcXqSJ8iF80s92CT+fsgYPRqomfCwN17qHk/7IjpWNLX/or
         E9wjBkyb8NF4J3Kv3WMb7STGuVDjCAL3HsVlzzzKC96KIK6CD2fgkaroU9fP6OZ1s/VE
         4/bp8m2Q9PDKiP1ZI9LenKp6/Ou21ISfo7gninfjac2LHppne7xOpeMDOtCJ3NJvgQbZ
         8ZkZNOXxB8AXx3ksV0V0QeJfVMBWkCFtCpmXuL8G9mNljREnNCwbWBD03xziUiyqLS5r
         ziXQ==
X-Gm-Message-State: AGi0Pua/Pl2L1oY4vgXLyuq4NT5FCeuXgZdSpSkFDAw4VUeJ0DxH6Fin
        bQ85vWpecJC8oL4gRcMM2Zn4ANVD
X-Google-Smtp-Source: APiQypJ1OE0RgimC8V/dkU/ECeKwZbO3NfvMvHXCoBylN36m0uekgF9eW5JEO2yKMXgSnWky0nm0lQ==
X-Received: by 2002:a7b:c944:: with SMTP id i4mr2344325wml.144.1588046859892;
        Mon, 27 Apr 2020 21:07:39 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b22sm2427152wmj.1.2020.04.27.21.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 21:07:38 -0700 (PDT)
Subject: Re: [PATCH-next] net: phy: bcm54140: Make a bunch of functions static
To:     ChenTao <chentao107@huawei.com>, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200428014804.54944-1-chentao107@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2cc91b0a-049e-95db-b9d9-21da25b022d9@gmail.com>
Date:   Mon, 27 Apr 2020 21:07:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428014804.54944-1-chentao107@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2020 6:48 PM, ChenTao wrote:
> Fix the following warning:
> 
> drivers/net/phy/bcm54140.c:663:5: warning:
> symbol 'bcm54140_did_interrupt' was not declared. Should it be static?
> drivers/net/phy/bcm54140.c:672:5: warning:
> symbol 'bcm54140_ack_intr' was not declared. Should it be static?
> drivers/net/phy/bcm54140.c:684:5: warning:
> symbol 'bcm54140_config_intr' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: ChenTao <chentao107@huawei.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
