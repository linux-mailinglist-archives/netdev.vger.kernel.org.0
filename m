Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EE22CE138
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgLCV4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCV4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:56:19 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F0EC061A4F;
        Thu,  3 Dec 2020 13:55:39 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id n7so2256541pgg.2;
        Thu, 03 Dec 2020 13:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MGZIpj6kDyueO2djnCo0SecPtEfaxLgfdqTr0VKNOI4=;
        b=oj59AZ8B6v9bJUmfl68zeD0JZpAfznLDJ816AJBvIXkes6btwMMQrZNNhP8ZTQR5L1
         gNynSO1kOyGvQ5wsrvjsDZdx0i6zxJHlKSitLZ0sYs0pQPEiUF4G/idOGr7M5diswpnA
         YE5nYJ8wC+kLiNyqfGb8sDko8l+ak6AeMcvd1o1doWXQgsWx5P64NAuPsTt3XzVpvJb0
         14ug71hHDka5bCBe1HkjG+pGeF7TYtdFzxVzsVpVoydyBW1OOtlHFqepcKv4Zikvnyvw
         vK/NIZHh4hqYi6bpiIFWW1QpW69UmlJP1Bfdsw34pLk7T65Ms771HW5Z6TTF4XSSzBD2
         QRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGZIpj6kDyueO2djnCo0SecPtEfaxLgfdqTr0VKNOI4=;
        b=oIYhK+D+eh7HN5E3GeoehtkE/+ru5m+k2rL+4v+VOejpXtdbUbIjYHkjTnltW192NV
         0HHTrHUx2mM7tl22ODJIVuyeNPluttgXMfiRDhR+HOmBKi9BEBZ5A0Wxe+/oGRr/z9wF
         CfPI8pg6t8ALL1xz2SIbqux8K7SHtqpGzzPsWbfu/KQQZrEg5lNNR3jiHjrcdt/U2NBP
         zWcvH2FXUwxohWW5UQnotXe6dpj7CFF/5ngJsIGpFverQX9o2hvkrpVRlv8ubXS3cw1V
         /sijgvsMf5zTfW5AbbA+97nx7LcgC0foIYKHkUD34rnDcTPVTE2bRlb1dejYIkuJFAIA
         NstQ==
X-Gm-Message-State: AOAM530Gm7/aw1tYCxXQETNHegWr1O/EhsoPIafCqaasLyYX3ldC1Plo
        g038U+lGTogMF3E1WQYZ9d13U8Dxfmc=
X-Google-Smtp-Source: ABdhPJyqTKmY4bTDtvoXCoYWuj7RlR74oEwnoail+dMy8sK1nzNlR/d+voVmysMhB4ApjpPq78QDSg==
X-Received: by 2002:a63:4102:: with SMTP id o2mr4853447pga.166.1607032538243;
        Thu, 03 Dec 2020 13:55:38 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gw21sm297928pjb.28.2020.12.03.13.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 13:55:37 -0800 (PST)
Subject: Re: [PATCH net v1] net: dsa: ksz8795: use correct number of physical
 ports
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201203214645.31217-1-TheSven73@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b362e63f-ebb7-fe0d-dc90-4ec2c972b1b2@gmail.com>
Date:   Thu, 3 Dec 2020 13:55:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203214645.31217-1-TheSven73@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/2020 1:46 PM, Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The ksz8795 has five physical ports, but the driver assumes
> it has only four. This prevents the driver from working correctly.
> 
> Fix by indicating the correct number of physical ports.
> 
> Fixes: e66f840c08a23 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
