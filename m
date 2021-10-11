Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1464284D7
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhJKBtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhJKBtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:49:14 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D668AC061570;
        Sun, 10 Oct 2021 18:47:14 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id u20-20020a9d7214000000b0054e170300adso19676406otj.13;
        Sun, 10 Oct 2021 18:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jyo1OoFnbxC8E/O7QKHwDrtRIhBakB8gcSS0r0Ont7g=;
        b=kuqQ5OhhqX18T5eT0u9M0NEX50bnsMfBVIPl1FbDxEVDgGTtULjKeCDn286+Rj8RzJ
         oNr1LOIQ3vhVEaaxrZUDGEXDjqp4Razack9nkRE0BIlPyds597lXow81peCL7dwGupSL
         QG8kv0wY4jaD1cKViRQz+ioGs4X583Thzsy++NDiJ5RwbyF9BGDFMzXLm0Y7aFL/p5jy
         BCKBo7gEgmHZnStjesgp/ajcVmypWpyyPQSRpoTdVQtWQE2D31i2mArWUnyY84UfoMmi
         Numsuhicht3QoTGFZM52GrTyjQROrU8s2dQhbr9rXDdtDct1ct9VebkcGSiy3g2sSo9t
         IuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jyo1OoFnbxC8E/O7QKHwDrtRIhBakB8gcSS0r0Ont7g=;
        b=Bkvb21MycaKmUE1e7y+p1XKnuekUSUXRsih4bizwkUBGz0XkE/UuN2QBO1dWsBIpxl
         1adwrVDca2er/nm2Z/0tvZKLyx3otzfPQcMzNevbh2LG+plLXMzA2yncCiGrkFFXte+N
         qPirUgyQjrFu5cv96CnpHJst8mXZq5G/LAoo+NrL3RcgLsZP6PM7GEDFHy0gIHKz/+UA
         L4K2kXqOajFpUaUw76oHo8YJhjsq93Dm/alcPe3GXboV3TyZ6DYtBYKuIIdHd7S7Wi5i
         +ZleBdEPexA5Ud1E7k9pQAc3w/qEewrKqKRI/pMRElpRPWYw69Ay3sUcnFCncBQh7oBH
         rAmw==
X-Gm-Message-State: AOAM530QYQ2XbNXVWvTr3i/16NgAjcbql6TIqs5p7hhomGcuqr0c/rU8
        jxNiGRBto9sGsjn5lgM9EUQ=
X-Google-Smtp-Source: ABdhPJy/C34DxAlVP5b0nLAyqYfKkmAQlyegB8KvQZ3tV8tt6QJxFpKIKTWUG5XMvNbdBoe6lLz7WA==
X-Received: by 2002:a05:6830:1c6d:: with SMTP id s13mr11909408otg.158.1633916834153;
        Sun, 10 Oct 2021 18:47:14 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:802c:b332:26e0:e0aa? ([2600:1700:dfe0:49f0:802c:b332:26e0:e0aa])
        by smtp.gmail.com with ESMTPSA id w20sm244386otj.23.2021.10.10.18.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 18:47:13 -0700 (PDT)
Message-ID: <8ec6a052-dbc9-b5c7-ae51-56f646aa11d2@gmail.com>
Date:   Sun, 10 Oct 2021 18:47:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 01/14] net: dsa: qca8k: add mac_power_sel
 support
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Add missing mac power sel support needed for ipq8064/5 SoC that require
> 1.8v for the internal regulator port instead of the default 1.5v.
> If other device needs this, consider adding a dedicated binding to
> support this.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
