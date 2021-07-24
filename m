Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6C83D48A7
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhGXP5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 11:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGXP5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 11:57:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90FEC061575;
        Sat, 24 Jul 2021 09:37:44 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so8074353pjh.3;
        Sat, 24 Jul 2021 09:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=58ES39bJrYCI4yZSgZYLWPj6FS4iI+jyIri71waPCCE=;
        b=RQx8YSnn1sc4taeC5u1cwP1A3qGEWRaEB3oenANQiUCFjI91oamhfvVH3MeHZy01OW
         7L/fy8+dIxDliJ0a5xH8zl7cEouuI6nLExmvVBveVOPt4FDJJYYi0gVJ0DqhrDJyGJqj
         UiXWgRjws0ipXgoHKw7KMpAj8k1yhHouTiNz2d2BF0vAcpwyyIkuyT5pYxaUu6Ozh//S
         4X1lP0nhvs+V9bF96mD5IPu4WxW/ujiRMYaAGIcL8L9UupHhxZC3egXbYODURDhWOrWG
         swJyLJkG64zTB+w9MFdA9ulaf8muGJaAFItwW8sfButzg3qR7zpHgp6U7OGjs0C/iSp3
         SPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=58ES39bJrYCI4yZSgZYLWPj6FS4iI+jyIri71waPCCE=;
        b=Af1/zfq1Z4rmJNSfB66FA118YOk6HdjNlhBbzhPKBWS5S4xoFmJl3/iOfTt4MouW2f
         sx9GWWdMJtGtpUd8fQrEk6nckk02ryRq9rd80cnFOzvkbHobZ7KGRFexsTQ/GtTwHMok
         dAQevaB7zy3VLXQtRNqRy75KorcG26JMwo15aQInAv0RR1ljNtdfrldQWIk/77rDE8Do
         Tqt1VIYlHQ+J2B7JO/xupcdsI7T8KbOxnyO7tfpXHIlnyt6kaU8J2u8J+zLt1bGrxDT+
         c+efEe6F6QVGDTZ8WjqalJtmQLnsBDkUdgbZ4P+j9ItBhP4VdTWCytymcNYXbSijwu87
         07SQ==
X-Gm-Message-State: AOAM533FbgD5KacSEWp8njYtw0csvye3BdsUmiXYSjOB+uP2ixhufgea
        WI1f//F+WNuYTurQFuE2yXxkGULxuos=
X-Google-Smtp-Source: ABdhPJwiQiyJ77bf1ENGGXmgUX+ZsNnRLL07yQAJv3Cu7toWAAQJSHfcfemLY/3Gcx2fXKvBNbuUjw==
X-Received: by 2002:a65:6489:: with SMTP id e9mr10184228pgv.409.1627144663739;
        Sat, 24 Jul 2021 09:37:43 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y30sm7982477pfa.220.2021.07.24.09.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 09:37:43 -0700 (PDT)
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
To:     Vladimir Oltean <olteanv@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Cc:     davem@davemloft.net, shawnguo@kernel.org,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20210723112835.31743-1-festevam@gmail.com>
 <20210723130851.6tfl4ijl7hkqzchm@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9455e5b8-d994-732f-2c3d-88c7a98aaf86@gmail.com>
Date:   Sat, 24 Jul 2021 09:37:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210723130851.6tfl4ijl7hkqzchm@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/2021 6:08 AM, Vladimir Oltean wrote:
> Hi Fabio,
> 
> On Fri, Jul 23, 2021 at 08:28:35AM -0300, Fabio Estevam wrote:
>> Since commit dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into
>> phy device node") the following W=1 dtc warnings are seen:
>>
>> arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi:323.7-334.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property
>>
>> Remove the unnecessary mdio #address-cells/#size-cells to fix it.
>>
>> Fixes: dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into phy device node")
>> Signed-off-by: Fabio Estevam <festevam@gmail.com>
>> ---
> 
> Are you actually sure this is the correct fix? If I look at mdio.yaml, I
> think it is pretty clear that the "ethernet-phy" subnode of the MDIO
> controller must have an "@[0-9a-f]+$" pattern, and a "reg" property. If

It is valid to omit the "reg" property of an Ethernet PHY which the 
kernel will then dynamically scan for. If you know the Ethernet PHY 
address it's obviously better to set it so you avoid scanning and the 
time spent in doing that. The boot loader could (should?) also provide 
that information to the kernel for the same reasons.
-- 
Florian
