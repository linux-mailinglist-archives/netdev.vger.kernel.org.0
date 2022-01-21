Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5928D4958A7
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiAUDuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiAUDuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:50:11 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9A3C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:50:11 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o64so8258619pjo.2
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wf5Oov8Y7/t9bYCNaYg9k/QaVvwYnSNBGqzXBpA9thk=;
        b=GxIyE05VeNqjrYVp+Qnond0zvaladSkIX/tzX1wKrYczQG265gL+pGHSTVTjqXuNUB
         EpxTAlQ+4SrkV8151tcFct7QUzpKv6ypdnmzY5QWkdU4ccTGFiR+3awBcPTxh+MZccki
         Qa2u61XnDO1wrPN100qVML7McxOz+XZc71I0TTKlMdEvVJVicG0XIhVXXIa4JjvtbMRB
         g/a4WeOkarED7i5nf8f5ix06RGSjmbfvbbvhW14KM/F5Efl6WDg0SZm3x5nPxi1A/ZLw
         XQjJymj+ezt6GFJO7/PAKWSUWf5bXYjsiQe1+EMj6Q6FsPmp3TzWj5qiGco0UFLrZGTC
         4XnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wf5Oov8Y7/t9bYCNaYg9k/QaVvwYnSNBGqzXBpA9thk=;
        b=4hGqHPI75SS4L9pvnuYcQP84dT97gYGR29COzusD4YhMozMnlaVALiFimPfIuaVQfa
         M0BzCie5a6Aa++zBAxX17fA1jtQ0oSUQfDlf7iZnY7dIMx7a2E/y8xAokGajGwkfQ6d9
         OlMEVxXEDkmlDqK79MgSrQYPz9xhmXdVl8lTyRYdqWdarVtdRlt/0FE7uwc/O3xzZsC3
         1wC9RCRcVXNmD78m33PL0gRcBiVGEdi3qm6BpoZLJtKQU3ufoxpJSwVqbFfGl+qppNU5
         CBKHwHQq4Nt+joLMZIR80Ra5gH7wpmtc4rpL+Bgj1sxJ0SiUdPJJWPl5nYLaizATwxuX
         nnFw==
X-Gm-Message-State: AOAM531VtsxVV695y3km9eJdML3R+3hLh54ucaErKeqXFhpnVUqtJX+M
        407n48ZbLs44gywIAInqTmk=
X-Google-Smtp-Source: ABdhPJx8SUT8a1sknUiVX6BoxnTUCCqyOOVipC95m9JlyedPiXSfWBCpFehpP/wzyx9Ja3xgbVQYkg==
X-Received: by 2002:a17:90b:4f4a:: with SMTP id pj10mr2668266pjb.68.1642737010566;
        Thu, 20 Jan 2022 19:50:10 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b6sm4936193pfl.126.2022.01.20.19.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 19:50:10 -0800 (PST)
Message-ID: <2091fa77-5578-c1bb-8457-3be4029b014d@gmail.com>
Date:   Thu, 20 Jan 2022 19:50:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
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
 <f85dcb52-1f66-f75a-d6de-83d238b5b69d@gmail.com>
 <CAJq09z5Pvo4tJNw0yKK2LYSNEdQTd4sXPpKFJbCNA-jUwmNctw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq09z5Pvo4tJNw0yKK2LYSNEdQTd4sXPpKFJbCNA-jUwmNctw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2022 7:42 PM, Luiz Angelo Daros de Luca wrote:
>> Are we talking about an in tree driver? If so which is it?
> 
> Yes, the one the patch touches: rtl8365mb.

I meant the DSA master network device, but you answered that, it uses a 
mt7260a SoC, but there is no Ethernet driver upstream for it yet?

git grep ralink,mt7620-gsw *
Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt: 
compatible = "ralink,mt7620-gsw";

> 
> My device uses a mt7620a SoC and traffic passes through its mt7530
> switch with vlan disabled before reaching the realtek switch. It still
> loads a swconfig driver but I think it might work without one.

Ah so you have a cascade of switches here, that could confuse your 
Ethernet MAC. Do you have a knob to adjust where to calculate the 
checksum from, say a L2 or L3 offset for instance?
-- 
Florian
