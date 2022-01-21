Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF84495889
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiAUDWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiAUDWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:22:30 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CBAC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:22:30 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l16so8187090pjl.4
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f6ZwsHN8w2pKFYdZrQ/ipfCgAfYHDZjmYiuOvoiy96A=;
        b=eOLkcQvqAWeRZblsYBglabvlWp1cYgCq8IkZv9Jx+8ZeHmW/fwBM0bD9FoeG01pzbi
         vN8UwDb99WjQypCpT1WxkcEUJ9ccDIxIiKDPM/7X7jKySsEmISwJdKzIWBX6aODAOJRR
         t9f1ktCErcmDQb0W3ljs7r+njAtZNH4kwFgdDsQyajceqQI7W5w+SEsnzZko61t4CcL4
         hp+RGRMzAPzt/R2XxSNc845esjdG1R4xz5rrMxefHq25JrphD5pTelLTCKyr0afNaweN
         2BnsfmEP04XfInlzEytU/wMSKuElemj7tNoBs0VvfMYXAhCKSEbhKPHMra0d90lfpMJ0
         XTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f6ZwsHN8w2pKFYdZrQ/ipfCgAfYHDZjmYiuOvoiy96A=;
        b=qYjSmbAFMfqdwtlxz8Ihm2BjR7xHXM2yPhBz/pqLsoAanhuLoGqZvDTc38sAfxprOu
         AF430ihPIsRRL+It9oZ09iMcUDWLZKL/fZKDLiILIzVwRMIvSQQ0W0Pf/edx2M7s4Ksr
         MjHdJlY0z/rxYj4WUn/iCwit3yhmD4E19wSRigLq/BTw2HIq76/rGHSoYw+ZBZhcLnX1
         yRPx6dshYpOFt+iC1DeP9yRQJF3X51BI7NZvPiaJZ0k6diC/6QWuSggIFldDaG1JBqdj
         Fi8z7B928udok0pzRsmoW3J34epzqQQLU7bPqw6ULIgYkIGUcH/D8wkIw3a1XmUF+MjD
         Cirg==
X-Gm-Message-State: AOAM533aql95eZqafxHNi3JcHpOPQ4Vlbp5MQxD9W1z3wbTaimo8MnHF
        e9JoIOA9BVmF0YLTPVnGvLg=
X-Google-Smtp-Source: ABdhPJwREZIjp60zRY9gUeG/GmcgsAynHv94DgDJSX80by4aC8aaUMvXjDnbqGvXPm6HyTeICVaUuw==
X-Received: by 2002:a17:902:8a89:b0:149:a833:af2a with SMTP id p9-20020a1709028a8900b00149a833af2amr1936481plo.153.1642735350131;
        Thu, 20 Jan 2022 19:22:30 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q8sm5069115pfl.194.2022.01.20.19.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 19:22:29 -0800 (PST)
Message-ID: <f85dcb52-1f66-f75a-d6de-83d238b5b69d@gmail.com>
Date:   Thu, 20 Jan 2022 19:22:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
References: <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2022 7:13 PM, Luiz Angelo Daros de Luca wrote:
>> :) device tree properties are not the fix for everything!
> 
> I'm still getting used to it ;-)
> 
> In this thread, Alvin suggested adding a new property to define which
> port will be used as trap_port instead of using the last CPU port.
> Should I try something different?
> 
>          switch1 {
>                 compatible = "realtek,rtl8367s";
>                 reg = <29>;
> 
>                 realtek,trap-port = <&port7>;
> 
>                 ports {
>                          ....
>                          port7: port@7 {
>                              ...
>                         };
>          };
> 
> Should I do something differently?
> 
>> I think I know what the problem is. But I'd need to know what the driver
>> for the DSA master is, to confirm. To be precise, what I'd like to check
>> is the value of master->vlan_features.
> 
> Here it is 0x1099513266227 (I hope). Oh, this DSA driver still does
> not implement vlan nor bridge offload. Maybe it would matter.

Are we talking about an in tree driver? If so which is it?
-- 
Florian
