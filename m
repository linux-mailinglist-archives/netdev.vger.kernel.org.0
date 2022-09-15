Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6A45BA1BD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIOULU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOULT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:11:19 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7038478
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:11:17 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id i15so15093937qvp.5
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=RYzqf4dKk8Q0AJaapVDFnt2EQlsY4Cd7mgKR1sQTHBs=;
        b=G8hT5qQwQ6TBO7Tk5pl7YOXnRnwp6swOiN0i+NGB4EXZo99U6Q7Ppb4DnwPWXu+A83
         /gzi2fV0Ky8s1VFGyEmpXWupPKE20sg5Lw7oA1guInEKSPLSuTTQ2MumQLsoHgozM8jS
         kVyAu2pwu/vc1SeDSjFZvF0rxXF2dt4wJAItuw5zLd6aRdMvZYAMFnU7iZ6+b87/5ZIE
         GIVMC/6b65IVaGmd+40ON/LRuTMKDXg4syMKzhUfHTHzWJNh5Yw3UnvuzQ759Ny7dri8
         JbmYX/jA2sISz+shGzTW2n7mGPI4FPE/jsW6Zc7HrLiPK1YAJWwmsCY2m8+Qtll2kj/D
         TkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RYzqf4dKk8Q0AJaapVDFnt2EQlsY4Cd7mgKR1sQTHBs=;
        b=vO4EZRGSSM8Q0w4Z39+VfzrMj4mSZD0toy07IQ9b5Vr+ENfJmfUl8F8OAJvp+5Oreo
         F08uwDg8iLQ0JYOF6ELL+OvTsgohuTslW17hcikLDffJP6fFXNUPgjhX9557Oy1c0oLw
         m2wdYf4SIvnSZAveVOSSII2RSlNiZ+JCwLuWBNZWm6hYv8y6xJqH5o+/ssFTgDS1kv3k
         lx51BpMDU2Qk+6d/iCTDpae7+Do0iQxSiW3ZAKNgIOY7uxAEUmmHQqnic39O8EINZ3UZ
         LqhEHY1uIisS+qD8ykSwTfZacYrbW9INzTXaeM3Jbp1juUW98OaveWUBHhNoWWyoXNkj
         r+EQ==
X-Gm-Message-State: ACrzQf2J3DlMyGDHTK2uSL5mvyGAWg+8gXnjRUkuWSMdsJpSfG57DeCK
        XNDkI3gZjma9yGTGgkS8Ks4meUBkJzg=
X-Google-Smtp-Source: AMsMyM5Dv/q8Jf/rcwWQ8mGB8Wc/aWWlg3rdLPJ2Y+7JGWE4z/CUFHevdOVeynnGW4awE2UpG2laXg==
X-Received: by 2002:a0c:e00f:0:b0:4ad:40f:4c8a with SMTP id j15-20020a0ce00f000000b004ad040f4c8amr1667423qvk.92.1663272676754;
        Thu, 15 Sep 2022 13:11:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u7-20020a05622a17c700b00342b7e4241fsm3969020qtk.77.2022.09.15.13.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 13:11:15 -0700 (PDT)
Message-ID: <22592ab8-ad68-0aca-c23c-72954b043ac0@gmail.com>
Date:   Thu, 15 Sep 2022 13:11:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v12 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
 <20220915143658.3377139-6-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220915143658.3377139-6-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/22 07:36, Mattias Forsblad wrote:
> Use the Remote Management Unit for efficiently accessing
> the RMON data.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Seems a bit wasteful to add a rmu_reg field for each statistics member 
when there are only 6 STATS_TYPE_PORT that could be read over RMU.

Maybe what you could do is that the offset in the "reg" member could be 
split into a lower half that is used to encore the existing offset, and 
you use the upper half to encode the RMU-offset.
-- 
Florian
