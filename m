Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D437045638F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhKRTiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhKRTiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 14:38:13 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3725BC06173E;
        Thu, 18 Nov 2021 11:35:13 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i12so7060220pfd.6;
        Thu, 18 Nov 2021 11:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=aNGsVLQSk8APla+3x3UEhqP7h/DDTYTHDehhr7pOcd0=;
        b=U7HNIEwb6hJ43avmOVgg/LskTWeaXpDb3vh5JfLa1mP75Yd2zXS2gI95uXNY9NtO4V
         EL6+6Fi+YtnxHl1SuaYF/4QSFoI6vl1S9LHkcm4IasJryaPBlKLA6BI5srPUpqrHuV5M
         ratVG41AJORpDk/XLbrm0HqbU9I7b2Z33ZUbExt6Q9Hc8t/S87GcXFXfVuPyYwNH3G25
         QlsnnNORXrc8g+zSiV47WXSpfOlVAhj4lGm3uIfTO8qFV0uvrWMvJA1NPCN+1TYxHAEa
         Tem75P5VVKvU34YsrIq7aOluMkXlRmsijWxmMa0LIEweuaX7E1EAQULDOQPDfA4mIYK6
         rT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=aNGsVLQSk8APla+3x3UEhqP7h/DDTYTHDehhr7pOcd0=;
        b=2l6TZtXFht3cTGH6zwrGp0Nm7kVbQo84a6WlRJ9Xi0VH9Bbr9ut1hb/3eD0xo3q114
         1NM+UtayS2BHysLNVQB60bZmgb1ls0fOUILDuCjkcKE0Z5F4odKv4Zi/Tl14okcxSmMp
         Qycj5dvyriCH8vC261/wqc1K+1kRWUAreKGvxz2nJvyviUr4IYQ67aap4W/gnxoccTUj
         MXf92uVXv/58PHmX7hxHR6M4uEC0l7mOi7yUIJBs1Xm6klmWzY9RH+wINBRIUvdQ9ooF
         7w5tj80W2NSp07SOR4i8Yr/GTYzo2zJr43k3/uDaxsKzEaYIYHpbNCXAKr2Vry8ITbT+
         1AoA==
X-Gm-Message-State: AOAM531uLKKDbxzn6cRosqs8STb9PvM4eqnTWijyEy7YyLcDThK2Jdjr
        hpCykIklGKsUfNNXHQ4CqQ/KuyMGJRI=
X-Google-Smtp-Source: ABdhPJxVc/cBJeNGJlhzGefpxMRVfjj5FUYsJH5/AxDpGvC80RAfFe5fiR6NR4VuYB4PcC7UDgL73Q==
X-Received: by 2002:aa7:9990:0:b0:4a1:57ff:3369 with SMTP id k16-20020aa79990000000b004a157ff3369mr17271403pfh.31.1637264112494;
        Thu, 18 Nov 2021 11:35:12 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id y9sm8712946pjt.27.2021.11.18.11.35.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 11:35:11 -0800 (PST)
Subject: Re: [PATCH net v11 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Joe Perches <joe@perches.com>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
References: <20211114234005.335-1-schmitzmic@gmail.com>
 <20211114234005.335-4-schmitzmic@gmail.com>
 <2c686a4d3980e2362199162f5baf9d4f4dd5892d.camel@perches.com>
Cc:     alex@kazik.de, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <fb5e4127-c9e8-6e88-7cff-6a607a2816f2@gmail.com>
Date:   Fri, 19 Nov 2021 08:35:07 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <2c686a4d3980e2362199162f5baf9d4f4dd5892d.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

thanks for your review!

On 19/11/21 08:18, Joe Perches wrote:
> On Mon, 2021-11-15 at 12:40 +1300, Michael Schmitz wrote:
>> Add module parameter, IO mode autoprobe and PCMCIA reset code
>> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
> []
>> diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
> []
>> @@ -119,6 +119,48 @@ static u32 apne_msg_enable;
> []
>> +	cftuple_len = pcmcia_copy_tuple(CISTPL_CFTABLE_ENTRY, cftuple, 256);
>> +	if (cftuple_len < 3)
>> +		return 0;
>> +#ifdef DEBUG
>> +	else
>> +		print_hex_dump(KERN_WARNING, "cftable: ", DUMP_PREFIX_NONE, 8,
>> +			       sizeof(char), cftuple, cftuple_len, false);
>> +#endif
>
> Why KERN_WARNING and why not use print_hex_dump_debug without the #ifdef

No particular reason - head still stuck in the '90 perhaps.

> []
>> +#ifdef DEBUG
>> +	pr_info("IO flags: %x\n", cftable_entry.io.flags);
>
> pr_debug ?

Both changed now, thanks!

Regards,

	Michael Schmitz

>
