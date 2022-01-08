Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388A14883C3
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 14:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbiAHNVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 08:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiAHNVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 08:21:06 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9386C061574;
        Sat,  8 Jan 2022 05:21:05 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x6so26008720lfa.5;
        Sat, 08 Jan 2022 05:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rEEQvk5Uck5nCpY81jxsRsod1zvCRX8Cy7vuSwuU20w=;
        b=nvoIU95jfD0X5rzdTYqID+b+uRLzjpP8BoezE4XHaRZZ9Al1zMLBamHUotVxV6R33S
         vxoqQqVnI156zdGsy4VZJeROx293CXzs2/3QvErcZvkzrBSSK4B/Iid/YiwjJ11FCOPu
         Fh5B044qXfSQXdkHa0FnjvpBK10ga91QeM/GobLb5HPQ6ht3ql/8Si5E0cIhkXLEzME/
         46nEWM65tOuKzWPnUbNlcMB/pqem/GjFg+cG8hZjtNKJ2jQol/+iG5K7pGhWjUaHAotG
         zAASZAfIzBIrwwdndvDe0Pif80PysNDCiAAPUHd/GqWedryEvKuoGKy0K8QA+TdT9z5/
         0p7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rEEQvk5Uck5nCpY81jxsRsod1zvCRX8Cy7vuSwuU20w=;
        b=f/x4RwO390LZkXZIfYs4jLv5DwMCnl0VNhXxt2ASP5QydWUEKZJ3i33RXYdsCqdoeH
         28Op2T5EOaLF3VVxSEQ7iCsSmrAaadurulqNJ+kkHgmRFt4RZMbUBB5lUVxMkL4zrf1L
         siotCNJvDXGoMOVtYcd98xuegH2/e5h5/LW3uDbyANoZBOncjqu+xfdv8S8jjhvEsZQi
         HpZv1cH4cXXkE1tehkxW3Zkx5J+bX4eEmW5exf+6O2A0hnr08Xl6M0I2q6+8ntVwtN3J
         gXNV/D545/BC8o9fHFXq9i1uSPEvK8BO3Ab1P49MXBxyvKJpp3pryRkdMBLAJdFyxq3M
         DTVw==
X-Gm-Message-State: AOAM533t7IEvBmhVf0T9nxKOZoTnNrntBRaa2EtVxyWznsJM5VUfURXZ
        ocZKah2mMQC7J1XdPHbVmxA=
X-Google-Smtp-Source: ABdhPJxE1+p7uSaAQ1gOWG571UTgSZCt/5TZLMGoJLFBT8yu2EYsfO9aU8EnVDTlB+yU3tOsbc0q0w==
X-Received: by 2002:a2e:9dcb:: with SMTP id x11mr49877694ljj.296.1641648064177;
        Sat, 08 Jan 2022 05:21:04 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.67])
        by smtp.gmail.com with ESMTPSA id q5sm223025lji.57.2022.01.08.05.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 05:21:03 -0800 (PST)
Message-ID: <9f7b9736-e67e-19fb-0f7b-6ee6735d5d13@gmail.com>
Date:   Sat, 8 Jan 2022 16:21:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH -next v2] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <2439d9ab-133f-0338-24f9-a9a5cd2065a3@datenfreihafen.org--to=stefan@datenfreihafen.org>
 <20220108131808.12225-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220108131808.12225-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/22 16:18, Pavel Skripkin wrote:
> Old USB API is prone to uninit value bugs if error handling is not
> correct. Let's move atusb to use new USB API to
> 
> 	1) Make code more simple, since new API does not require memory
> 	   to be allocates via kmalloc()
> 
> 	2) Defend driver from usb-related uninit value bugs.
> 
> 	3) Make code more modern and simple
> 
> This patch removes atusb usb wrappers as Greg suggested [0], this will make
> code more obvious and easier to understand over time, and replaces old
> API calls with new ones.
> 
> Also this patch adds and updates usb related error handling to prevent
> possible uninit value bugs in future
> 
> Link: https://lore.kernel.org/all/YdL0GPxy4TdGDzOO@kroah.com/ [0]
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Please, ignore this one.

Typo in git send-email args caused this email to be send in wrong thread 
and missed Stefan in CC list.



With regards,
Pavel Skripkin
