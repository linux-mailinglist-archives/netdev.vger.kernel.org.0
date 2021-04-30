Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC43D36FF28
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhD3RGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhD3RGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 13:06:51 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A49C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:06:03 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id l22so74295552ljc.9
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=NhOwl+mpVQCsmkSByu8gdIMnotARm/Qk6Yk86/nB9zY=;
        b=pHfSJ5sQL/NicO+ECAqcHYcFgFv7giq3PT7GxOOcdoqQm0yBXlf0p6b2zOzzTC12Ta
         0uJeE9lbNPC3cFPAtAESMlwHY9Q/YcrEFqR/zvS+OwCLnA/epv2qrBAcj8DJMbmEQO68
         CJMvJNbKBBelZsigVV3gTVsf3jbwRiB/exZ74pCadb8KXBsb4ImLHlDNWyHeQoa63qXq
         YuOIDK4mfVzk0L6K3ED5IQnIN4KlDvwEuSPskjGWUwuT6FxbY4F0h2HP8+Xp81/PUhsT
         ug2mokFDOXdY7IxcmGeEHzGt3kPVSXpbuhe7mP5Oo7X//oqnIylW2dKLjEnuN+amP6yE
         Z0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=NhOwl+mpVQCsmkSByu8gdIMnotARm/Qk6Yk86/nB9zY=;
        b=YjVnVBd0qCgGQpoKZwpt/9qTIs++Mpvl4bGFR4x27YhgDVYG+YAgdMC19xyHUlpAY6
         kdxNRBkjAMrEPEBh+9xkd4O50DPs91bsC8TbLwUUI4S2Ti/sFtwtrf/FYRnEHfOARmcl
         lpX5fhl5BQ0bkglwYffparno8+at3x5iMjqHCfP0jqovasK1TfLoXdJFh3ftijBHuPCv
         hkLB8MAc0Nv8bvRF8hGzPpYPgrV9FN5Cz2vsYeLhfAkKh62CYgFjvlMRhhS6RuBYmUuO
         7ocBFDbFJvKah7YAYeoFCTyUPi16zt31DSAeqT2ASksEwXQWbXJDOP9r8S6aDT9k+xt+
         nymw==
X-Gm-Message-State: AOAM531Er7EfW5SoEXhTHhAbeAF3mpjBPE7dT1Qnp8clQgFGvTBLH9Bu
        Jvi01aHDrnp6MAqGW5vuHuE=
X-Google-Smtp-Source: ABdhPJzgUSdr9ULKcg92lZrKKqpsebQTRp46V2coFvyIO/nQEMxbhCbYcs064uEn6kK923l4/XwXWQ==
X-Received: by 2002:a2e:1541:: with SMTP id 1mr4581991ljv.80.1619802361772;
        Fri, 30 Apr 2021 10:06:01 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id r17sm338747lfr.18.2021.04.30.10.06.00
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 30 Apr 2021 10:06:01 -0700 (PDT)
Message-ID: <608C3B2C.8040005@gmail.com>
Date:   Fri, 30 Apr 2021 20:15:24 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
References: <608BF122.7050307@gmail.com>         (sfid-20210430_135009_123201_5C9D80DA) <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>
In-Reply-To: <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

30.04.2021 15:08, Johannes Berg:
>> rtnl_unlock(). Hence this delay and timeout.
>
> Fun. But we can just do it synchronously?
>
> https://p.sipsolutions.net/e4f076ed1b4c8a78.txt

Wow, that was quick! Thanks! However, unfortunately this patch still 
does not quite fix the problem. Although alx_check_link() now gets 
called synchronously at open, it somehow does not pass below the "if 
(old_speed == hw->link_speed) return" line here. I'd guess it is because 
the chip is not yet able to report meaningfull values immediately after 
initialization. The result is still the same: 120 seconds timeout 
happens, then the "eth0: NIC Up: 1 Gbps Full" message appears 
immediately and all is fine after that.
I'll do some more testing later today.


Thank you,

Regards,
Nikolai


>
> johannes
>
>

