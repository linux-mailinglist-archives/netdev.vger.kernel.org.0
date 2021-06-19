Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35933AD6F0
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbhFSDPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbhFSDPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:15:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2ACC061574;
        Fri, 18 Jun 2021 20:13:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bb20so2633592pjb.3;
        Fri, 18 Jun 2021 20:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=YTkc1RGIlMZsUFqvUXJXtnV5G900KAQ2a7/NWvfX1D8=;
        b=FyYsT2eKopXeUG8aK6Gtl28svK/w0q5m6MkBrm44l5RvOxMkrtmO7APYDccksw8/fw
         EZZwMqNDLH2ZduM4NrcCTIL7jgiytM5khk9Cs2YXbW9rdB+njhYjASnwVOoeahDBsdAC
         0Xb68F2nt1hT9P2ePqIwhpr7flTWAEGGwXUouf7Pn2HVR0DQTEEZ0vX/taG4yjoNLs1I
         uLPMpEE07wqjlLFb4QggoNC8qRf8IodAnn4G9etxVV9HxDkn9cIkJbjKZpxcI639Zib0
         gZDpQ0rJJMXlAi4Ij8FlJCQKX5I1XxvcrJoBHKysq9gFt99Q/IG+4lu9Lu7zYeeRAG2S
         3p1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=YTkc1RGIlMZsUFqvUXJXtnV5G900KAQ2a7/NWvfX1D8=;
        b=Hq1cg0kHRYA0BApmU1U+JEgTDJV+zsL+ZfARp2omQVaKHc0qh0JJQBIY6xZxDgWQpl
         4JrC7CWmxNNouJ5Jhj9XI6EVHWqwb0++4OS814wBDFQ6vRJwxkYpmNLUXSgg4HBfIdgu
         p5ECChfnjV8sQzDy8jPc0BfnehRLtLeH8tiCVohGbKxPh3BxGtdYsx4ssXyQUWcQOH3k
         +anfrjzVDVgK5jfU2we27VcpKyA5cxxx160e6GGmsHMvx18etPJVuZehLRQlmsBnguVs
         /iDWzvB19E/aLfZW1f9zvRJd9w6tbP6GxAdPtdjrJ8TdZvekxKavZPRxdqPghm8KJWFA
         Y8Xw==
X-Gm-Message-State: AOAM531blov84IZPGzQitJjA7dLy17hWhftY92ZApuOE6+6cCsJo098Z
        W+0ofMVEG7FMCEjqeK6OeEYCjNC9drA=
X-Google-Smtp-Source: ABdhPJx+gTI1pbNmlB1j9qN3WcS/02uTsTeCElWrrcNrG0Ktp0yakDMVzkxxIztDehUp8Aq645mbWw==
X-Received: by 2002:a17:90a:bb89:: with SMTP id v9mr978420pjr.0.1624072421726;
        Fri, 18 Jun 2021 20:13:41 -0700 (PDT)
Received: from [10.1.1.25] (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id z22sm9709871pfa.157.2021.06.18.20.13.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 20:13:41 -0700 (PDT)
Subject: Re: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Finn Thain <fthain@linux-m68k.org>
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com>
 <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
 <83b0640-459c-6f46-e070-1fc9559bd0be@linux-m68k.org>
Cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, alex@kazik.de,
        netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <458fe9a3-9a34-d35e-3559-7de498d8f28b@gmail.com>
Date:   Sat, 19 Jun 2021 15:13:35 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <83b0640-459c-6f46-e070-1fc9559bd0be@linux-m68k.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Finn,

thanks for reviewing again!

Am 19.06.2021 um 12:56 schrieb Finn Thain:
>>
>> +	/* Reset card. Who knows what dain-bramaged state it was left in. */
>> +	{	unsigned long reset_start_time = jiffies;
>
> There's a missing line break here.

Straight copy from apne_probe1() below, but you're right about style of 
course.

>
>> +
>> +		outb(inb(IOBASE + NE_RESET), IOBASE + NE_RESET);
>> +
>> +		while ((inb(IOBASE + NE_EN0_ISR) & ENISR_RESET) == 0)
>> +			if (time_after(jiffies, reset_start_time + 2*HZ/100)) {
>
> You could use msecs_to_jiffies(20) here.
>
>> +				pr_info("Card not found (no reset ack).\n");
>> +				isa_type=ISA_TYPE_AG16;
>
> Whitespace is needed around the '='.
>
>> +			}
>
> Missing a break statement?

Ouch.

>
>> +
>> +		outb(0xff, IOBASE + NE_EN0_ISR);		/* Ack all intr. */
>> +	}
>> +
>>  	dev = alloc_ei_netdev();
>>  	if (!dev)
>>  		return ERR_PTR(-ENOMEM);
>> @@ -590,6 +613,16 @@ static int init_pcmcia(void)
>>  #endif
>>  	u_long offset;
>>
>> +	/* reset card (idea taken from CardReset by Artur Pogoda) */
>> +	if (isa_type == ISA_TYPE_AG16) {
>> +		u_char  tmp = gayle.intreq;
>> +
>
> Extra whitespace.
>
>> +		gayle.intreq = 0xff;
>> +		mdelay(1);
>> +		gayle.intreq = tmp;
>> +		mdelay(300);
>> +	}
>> +
>>  	pcmcia_reset();
>>  	pcmcia_program_voltage(PCMCIA_0V);
>>  	pcmcia_access_speed(PCMCIA_SPEED_250NS);
>>

Thanks, will fix in v6 (and correct the commit message). Might split off 
the autoprobe bit so that can be easily dropped if need be.

Cheers,

	Michael
