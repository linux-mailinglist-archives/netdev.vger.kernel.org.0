Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820A9160087
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgBOVKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:10:48 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44698 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgBOVKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:10:48 -0500
Received: by mail-lj1-f195.google.com with SMTP id q8so14479713ljj.11
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 13:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AHv9g432bOCOXhQWsFhrOC13uKSzwICBMh5xUoEnDHw=;
        b=lo6drs9r+MG2Ppwy+q+5ZZ4yiO1kJPEYCCa3pHI3/cC89vjRBr0XdmGH85y5zQloI9
         DjGM6LyR14O7L63mnlnxyjFE4APcRObHMGsUM2rUT5+HUi5bnWlR+2wVVXMK6LWKY5Km
         d+7C7GRMmmxcu1zCX0mH7WUfxcrFQ1l5RpGV/YlcT/8ZhxgFAVJT/pJ6j93aaqxC+t/0
         TjdNXl0K487FWjATXx5Ksl+qfE5FD3c8I8atBmHoKjNES2AH9ZLg6N4qIoTZmf0sgob1
         YPha/wLtEIpH0LFENY3765qVeJoI/9jJ0UZUNrMXuRGzShAqrc8JIm50RWGNn7ADT6Gz
         zyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AHv9g432bOCOXhQWsFhrOC13uKSzwICBMh5xUoEnDHw=;
        b=szMCge6x7ghyd/ijTd+9YopWw3LkKrdWaPCrWQTCmGcsZ7tsZvk8o7Y9W7u78Ggap/
         g2hJE+vYg9mkNEIkpf4xmTQCY5FbWP8ipVvZEjIh276t/9AYsqNaMNQ0HRyFuRQCo5d5
         mr/b/KwM5yjLiTGJ/DTPb3aHWeUYNJ02tRmDO75eWSDjBBf+gejRAfkqOn4QQVpJQ7qJ
         KuAtyKoSuw1+NxGEenEYe00Oq6e6AubbvwWs+MrFwgDb4CaxOsAKjzWRdZdHZHHeLyvr
         2/4ceC62dzI/GiathFShIBPzEWvA46pl43BTZQ6wH9tw82ZV+OmLuUOdrN1XjugxxGOw
         rpQA==
X-Gm-Message-State: APjAAAUHyqlfO5+cyjj7I/7Gh55F74AewsS+Ji2nUUV7kKfjoBGVlXCQ
        LKTrjz3H4t7CoGiDzf+OlbzYoSb/
X-Google-Smtp-Source: APXvYqwgqoq18ZcrInUs503vxGWHjfQJlzmmWsb5DpB3D/RUOLGpTPA5uzyTSjKN42Nt90n7Ro4i6w==
X-Received: by 2002:a2e:a36a:: with SMTP id i10mr5495745ljn.107.1581801045958;
        Sat, 15 Feb 2020 13:10:45 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id y14sm5680140ljk.46.2020.02.15.13.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 13:10:45 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <088d26ff-69e2-4781-078a-5515aaddba48@gmail.com>
Date:   Sat, 15 Feb 2020 23:10:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200215161247.GA179065@eldamar.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-15 18:12, Salvatore Bonaccorso rašė:>> I'll try first to rebuild 
one of the Debian kernels after reverting that
>> a7a92cf81589 patch, for starters.
> 
> You can generate the a7a92cf81589 revert patch, and then for simple
> testing of a patch and build have a look at the Simple patching and
> building[1] section of the kernel handbook.
> 
> Hope this helps,
> 
> Regards,
> Salvatore

Yes, I used interdiff helper to modify official Debian 5.5 package. 
Already running it (after 55 minutes of building...). I'll report how it 
goes.
