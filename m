Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B133F867F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbhHZL3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbhHZL3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:29:19 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9845C061757;
        Thu, 26 Aug 2021 04:28:31 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x12so4450508wrr.11;
        Thu, 26 Aug 2021 04:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=L5cag9XJVl6CGutNwpSZlwmS3o3RmhThsalx1g1IrhE=;
        b=kATmy8zwa/wv9K4EFdVfOg6mUVsMmKNLSmp32Dly7sguCSunX2BgRQ+rlo5ngrzt7O
         R/APzCryqfQIwjrBS5jYZTlWpt4bGRcocN4kuk7XORZF/xTY525YHwntwzd7PsGeiZht
         1DUOOpYUAOU1BlgbDhZ1SN43crhC5ZYn/WTgPbKkhCOKbLbl3jJon137cak0gh5WidFy
         SQpb4snHqz+RBX3fTDiLwRoyCNTXe9yeaUIn0QB0DQiufVqwn+co7UjKCoFeRnJUHRWe
         LUJqKze7Ev2VZ4KcNhJ7Z8Q8kViGin0080Zgc1ixx1ffH98PyFCppfJa43SZ6ocUrop0
         dW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L5cag9XJVl6CGutNwpSZlwmS3o3RmhThsalx1g1IrhE=;
        b=bcF2kE8YYNPxYQ7S+DjoIXOCWB0km6yNvvqASuFTg8bO1v37pNvwo2tOtEnX+oFZzz
         Qpn9XHbRCOadZlzYs099gwAEZVDswminqk3WlXP5FSIvh/zasMxc4SMO3cuEBYIeAFZS
         47AwT6LVLez7lb0rzF5hP240WpZ6iAYqD4yXg1i9XiZEfHHOypnHwYG5TJiGwSy3ntLQ
         sy+f6OmrWDAALcC2i3pVWbIHrC+1+qGyZDNKDWE/tPwOz/PLUJFanLV3/gX6qr9Z7Y5V
         O+FL9vismhMSiwrxMqNvT88gjNXAyFf5F3ieK5sHo26yY2XKweV9ncNFFbLembGMGrec
         mw1g==
X-Gm-Message-State: AOAM531fTFpqFrSa5WaxgbgceXMNXOXOvb1WpSIJ/VROPlDsmuDnM6Gc
        u4f3m/HrggeNty+xBi/78ew=
X-Google-Smtp-Source: ABdhPJzTjaG3Csn2Yj/NA3ZQsg8Vit7gaAMhO4wYxTHEppDr8F+25UU9HnTFjqGhOluAy4YTKTHxQA==
X-Received: by 2002:adf:c381:: with SMTP id p1mr3319892wrf.163.1629977310446;
        Thu, 26 Aug 2021 04:28:30 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8192:e700:d55b:a197:684c:2cfe? (2a01cb058192e700d55ba197684c2cfe.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:d55b:a197:684c:2cfe])
        by smtp.gmail.com with UTF8SMTPSA id 17sm2352534wmj.20.2021.08.26.04.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 04:28:30 -0700 (PDT)
Message-ID: <4b61ce72-87ec-cf8b-9f71-67eb329a9ce6@gmail.com>
Date:   Thu, 26 Aug 2021 13:28:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [RFC net-next 1/2] net: dsa: allow taggers to customise netdev
 features
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20210825083832.2425886-1-dqfext@gmail.com>
 <20210825083832.2425886-2-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210825083832.2425886-2-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2021 10:38 AM, DENG Qingfang wrote:
> Allow taggers to add netdev features, such as VLAN offload, to slave
> devices, which will make it possible for taggers to handle VLAN tags
> themselves.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Besides transmit VLAN tag offload, do you think there are other netdev 
feature bits that would warrant something like this as opposed to a more 
structured approach with adding a specific boolean/flag that is specific 
to the netdev feature you want to propagate towards the DSA slave_dev?

Still:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
