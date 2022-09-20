Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056675BE5B8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiITM03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiITM02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:26:28 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F8275392
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:26:25 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w8so3431247lft.12
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ktw2GqPx1pLMPe/HSHZwxwqbkAr5rt5mVL4PXoNJQe4=;
        b=fgEw7LwfwOcAqTWIOBiGSLbYBEBrHoLNfSkWA7S3EvpwLUxoDB75clIaV3OiRH7NLs
         7OXOMvVtPshS/UVt/Ik3W2fmLr9CmCKkAZl4YFuJr2OpKioxfy2qeFY1hkvXnE7DJ04U
         CtvZfGA+WJiYU0RglM7W6pWcdNuz2cMS0sDgB+Bg3i7EPBq7pG7QYUEmdZRU9vw1PKkQ
         +kyYjvpVYSiEsRcsboCtcrUDpzLgVZ/n2MrLYcxWdqwC0bnLopCNAmqL0RZTgWkRMEXa
         hIv201Z5+DIraIF05MJFX1TkmOUOGw6/n20AUfjh4tD/ts1BlqEe0ztUOJMhn49BjQWU
         tFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ktw2GqPx1pLMPe/HSHZwxwqbkAr5rt5mVL4PXoNJQe4=;
        b=QahIHuihDK/7hhiQNkMkt83JyG5Ir1Vgn1CwEiXGUCbGLThKidGbI+xCLzqmzcdpN6
         7HOwRq8sBfHoGD0XFIJdxXvYAHiZMQ87vQo9csoJIX/nf1kOjezQ2jPdI6ocftrYD//h
         HIOyIgsDOuMX8Svrd9aMr1yQWAhoBT/ppyKJyezOM/JHDxS210dV5e2J/BrSEIsUgmNV
         V7OKV4Y4YZwfU++UF9XFp9FrjKN/ozJ65V0kJuTlK5g4mDo/kO1Bq3JLY+/HU5WKRUTa
         SIhHHV8ynGTWPu2OpKFAMs7K5nqt/FBTDVhVDyd0efXa9c3ax86PR70RNbTflviF/Co3
         cxtg==
X-Gm-Message-State: ACrzQf0Y8hjrIOP9HafJhwPesM+9UmKj7a4RAWGJ8OfaIh6GdlqLwuPe
        UTXX6K2DbOgO+/avXj07ID7vHqiyFYEiFQ==
X-Google-Smtp-Source: AMsMyM6RSzGYNWcww2Vd4JrRFstjzfk7TsP449X8eBNX8sjHML62l2u/nyZG6lNfjvOWf/SJpAnFFA==
X-Received: by 2002:a05:6512:3182:b0:499:edbc:d23c with SMTP id i2-20020a056512318200b00499edbcd23cmr8510475lfe.675.1663676783896;
        Tue, 20 Sep 2022 05:26:23 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id e9-20020a05651236c900b00498f77cfa63sm284892lfs.280.2022.09.20.05.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 05:26:23 -0700 (PDT)
Message-ID: <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
Date:   Tue, 20 Sep 2022 14:26:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220919224924.yt7nzmr722a62rnl@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-20 00:49, Vladimir Oltean wrote:
> On Mon, Sep 19, 2022 at 01:08:45PM +0200, Mattias Forsblad wrote:
>> @@ -255,6 +299,15 @@ int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
>>  	chip->rmu.smi_ops = chip->smi_ops;
>>  	chip->rmu.ds_ops = chip->ds->ops;
>>  
>> +	/* Change rmu ops with our own pointer */
>> +	chip->rmu.smi_rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
>> +	chip->rmu.smi_rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
> 
> The patch splitting is still so poor, that I can't even complain about
> this bug properly, since no one uses this pointer for now (and when it
> will be used, it will not be obvious how it's assigned).
> 
> In short, it's called like this:
> 
> static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
> 					uint64_t *data)
> {
> 	struct mv88e6xxx_chip *chip = ds->priv;
> 
> 	chip->smi_ops->get_rmon(chip, port, data);
> }
> 
> When the switch doesn't support RMU operations, or when the RMU setup
> simply failed, "ethtool -S" will dereference a very NULL pointer during
> that indirect call, because mv88e6xxx_rmu_setup() is unconditionally
> called for every switch during setup. Probably not a wise choice to
> start off with the RMU ops for ethtool -S.
> 
> Also, not clear, if RMU fails, why we don't make an effort to fall back
> to MDIO for that user space request.
> 
>> +
>> +	/* Also change get stats strings for our own */
> 
> Who is "our own", and implicitly, who are they? You'd expect that there
> aren't tribalist factions within the same driver.
> 
>> +	chip->rmu.ds_rmu_ops = (struct dsa_switch_ops *)chip->ds->ops;
>> +	chip->rmu.ds_rmu_ops->get_sset_count = mv88e6xxx_stats_get_sset_count_rmu;
>> +	chip->rmu.ds_rmu_ops->get_strings = mv88e6xxx_stats_get_strings_rmu;
>> +
> 
> Those who cast a const to a non-const pointer and proceed to modify the
> read-only structure behind it should go to patchwork arrest for one week.
> 
>>  	/* Start disabled, we'll enable RMU in master_state_change */
>>  	if (chip->info->ops->rmu_disable)
>>  		return chip->info->ops->rmu_disable(chip);
>> -- 
>> 2.25.1
>>
> 

This whole shebang was a suggestion from Andrew. I had a solution with
mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
member? I'm not really sure on how to solve this in a better way?
Suggestions any? Maybe I've misunderstood his suggestion.

/Mattias
