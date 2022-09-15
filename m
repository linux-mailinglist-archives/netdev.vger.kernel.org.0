Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B3F5B951E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIOHTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIOHTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:19:44 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6D8CE25
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 00:19:43 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id j13so6353964ljh.4
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 00:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=i+XreNREEN17dbhLXXKW1KKFQxAJV+CRtpl6jT/5U5c=;
        b=mAndPmms+VBlGkX58hm04VRBifk6bAzoH6Hl2NvqGGcJLfZxxcjud1tF7vArm/9f4s
         4TV41VIoimKF8AEZGWkrJLKugvThu4HMwIj3F9ufOP8cK+IIypWjM/Z/oSjlzFOWjTph
         YgLIiNLVjiiEbqMJtb4WRaJGqeqGa2xzx8WjZGzuJmTFMOlCNAD18sjRswcCz7Bl+gsT
         XesvyRzAybg8CEvPiu4yXFLT458r8iq0yqAwRqL9ULZWjK9ZAahsbXrRC88gsqTw5iKY
         8A+8ZqES/2j578iW/lO7ABtewfzYJhpf953MzSCtgpPwO7ZnUXgeW3K6XZm3fxj14kR+
         6GKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=i+XreNREEN17dbhLXXKW1KKFQxAJV+CRtpl6jT/5U5c=;
        b=FHyJHYthXTTatNpD7gRgrBA02LMi78sC5KEjoc29McfxKAnmsM/fUJKhaK2j9j0Z7s
         SR1r1ZOe7wYEs6jf2iHqXQsUKHx88/mlMy2ScQFe4DevkyfLBsKBMaoH3CbK3Iyd+RHK
         9CHn9ePGspkQyNavp7fyuapXv22uVdF+enz+3Cc/ntZt1MJgTroOnH9KpOcS0W/Fo/ZK
         k+Sc/QeKUuHjPavzk/xjsswQ8UAg33xIyQja9b+XPF5r769MNPzGQIHZRFF7cQIjlYtu
         58TB7K4NmSK2Ukce+nRhKhJGnjs4gvzYTOK17iMMR/sljSvRDDUrqIjSG9bIIlk3EoNp
         CFGg==
X-Gm-Message-State: ACrzQf3U6gzFnoKo8iYPgRwK977dGhegRdhc/xpJlCoEYxokPFU1Aiqk
        eo92T5HkqPS0JrQFd2xcp/g=
X-Google-Smtp-Source: AMsMyM4OKnlgMVQaD1nOofKfyhoPRhV6yOvlI8FB2febZwRahWtLG/cfq9j9b+qSsUS5vpfMhHHEcg==
X-Received: by 2002:a05:651c:552:b0:26c:336a:32e1 with SMTP id q18-20020a05651c055200b0026c336a32e1mr187983ljp.376.1663226381284;
        Thu, 15 Sep 2022 00:19:41 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id 17-20020a2e0311000000b002648152512asm2957637ljd.90.2022.09.15.00.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 00:19:40 -0700 (PDT)
Message-ID: <3f9a9054-6605-fc93-067d-6b22e131de6c@gmail.com>
Date:   Thu, 15 Sep 2022 09:19:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v11 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
References: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
 <20220914053041.1615876-6-mattias.forsblad@gmail.com>
 <YyHoXUyBIMyFGZTX@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <YyHoXUyBIMyFGZTX@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-14 16:42, Andrew Lunn wrote:
>> @@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
>>  				     u16 bank1_select, u16 histogram)
>>  {
>>  	struct mv88e6xxx_hw_stat *stat;
>> +	int offset = 0;
>> +	u64 high;
>>  	int i, j;
>>  
>>  	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
>>  		stat = &mv88e6xxx_hw_stats[i];
>>  		if (stat->type & types) {
>> -			mv88e6xxx_reg_lock(chip);
>> -			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
>> -							      bank1_select,
>> -							      histogram);
>> -			mv88e6xxx_reg_unlock(chip);
>> +			if (mv88e6xxx_rmu_available(chip) &&
>> +			    !(stat->type & STATS_TYPE_PORT)) {
> 
> If i understand you comment to a previous version, the problem here is
> STATS_TYPE_PORT. You are falling back to MDIO for those three
> statistics. The data sheet for the 6352 shows these statistics are
> available at offset 129 and above in the RMU reply.
> 
> I looked through the datasheets i have. I don't have a full set, but
> all that i have which include the RMU have these statistics at offset
> 129.
> 
> So i think you can remove the fallback to MDIO. That should then allow
> you to have a fully independent implementation, making it much
> cleaner.
> 
> Or do you see other problems i currently don't?
> 
>     Andrew
> 
I'll look into that, thanks.

/Mattias
