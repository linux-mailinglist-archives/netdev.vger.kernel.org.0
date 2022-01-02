Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94040482C24
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiABQsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiABQsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:48:06 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604BCC061761
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 08:48:06 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m15so28379718pgu.11
        for <netdev@vger.kernel.org>; Sun, 02 Jan 2022 08:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8MGU7Bkxzsh4kSGgz7CgbOanZQ6i0lFiDarUZC8lk4A=;
        b=PBL4HSlh4BIBv0JQCgR/3XQ6IjM93MWzS7O5YSZ/asQSC5NtMKy95n/0piN5mbrjSo
         g+jzMoDz7/geg3L9pPT4NF2JIYjqrlF4hyS7DWBSBOXLlvqQZzQqDKQicNKvvi239Vly
         KPhgbS7duyQgglO5fdqdNZHSTx5QRTR4V0H/LmPzuE2oYg5Mu1JYeNFXB1nBiwp7ohLU
         E1sY1iVOhDkHwktfEhq76iMKaQvHSLT9QhzaGhzUMGAEV2vs4VKV/M+kBQfyFXTybsvb
         3xj1FwZBgwGdvgtPPkQxIFts6xNgISxkoah84l5OKKRM6OPZGePhOkimFFh88gQ6YwW7
         2ALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8MGU7Bkxzsh4kSGgz7CgbOanZQ6i0lFiDarUZC8lk4A=;
        b=7fGc7n9KpVjxFZrb2DIj1v7xvNRKADcMWsXpiX/l3uYTu3IdRcq6gOKHkhUoWJlTmQ
         RxPpa1gTCnWulYLWXlX05XkbCpwgvDhV51NOL8II0rBINJGXxcq5MR/Eu/BdGKXqXci2
         XNyKzOWEaV+rLywbwD1nizcmg/r9ZRo4YCl+jVnJgmkp3/DN31wbXE6o7p64MFI+MbYH
         AxKhoeEoQ30Qr9GBxlu5cqhx4Hlfe+ENu2Aw1+4391e9B/AGD+6olupIyUUYfjaF0wRd
         R5kzx9npTTR6fhe7Tet74oN7HgGEYt0jxUUc/V6YDIPLvuSkLlwO7Cybc7Jonk2vtYLW
         uYlQ==
X-Gm-Message-State: AOAM530b1SwLNsiwLE2GEdjxeEfKfcHIW/tcNzs6u2g5u+g5PGWQcxSf
        v4wdGFKeOJyRGt1V3CmFqwo=
X-Google-Smtp-Source: ABdhPJyRNtIMVEAZwWSYVJuHrmPwi9/hnF28q2VIYD/utTZw7zyXKI0HfCEHb/kbvIBoSsrAyQOzHg==
X-Received: by 2002:a63:9d4a:: with SMTP id i71mr7951272pgd.570.1641142085697;
        Sun, 02 Jan 2022 08:48:05 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g16sm33549610pfv.159.2022.01.02.08.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 08:48:05 -0800 (PST)
Message-ID: <2ddcd362-004a-7af6-6cab-75992dcebde9@gmail.com>
Date:   Sun, 2 Jan 2022 08:48:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v3 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20211231043306.12322-1-luizluca@gmail.com>
 <20211231043306.12322-3-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211231043306.12322-3-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/2021 8:32 PM, Luiz Angelo Daros de Luca wrote:
> In preparation to adding other interfaces, the private data structure
> was renamed to priv.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
