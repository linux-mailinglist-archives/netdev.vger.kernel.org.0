Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61DA1A3E2E
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 04:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDJC1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 22:27:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44167 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDJC1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 22:27:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id b72so442525pfb.11
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 19:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FQGxZIdmR9W/uYd+nLTaeKNhLCxJN8rtlec/bbms6jA=;
        b=JNcRIC9/ECkJBwnBcNcRlp0Zy4mdSqrVZ7FkvcJdS8/nbvxCT+i32CLIzyckkGNPsn
         DGShFauMSq+s52uPL2tgPizbZ/RjfbwTvn5t1F15uZNccctaSjXsePAD/4SaHZ1y85xt
         UAiwxED4a2rlSlK6gC7Fy6jr7HhVjdhhc2oE+D85FRfzQXYU1F7kZH17s2cu4jzseiZV
         BbH4n/r18RH93yfhmjXB6QH7vHTIaRzFIF6MMI5i8VwsUZ9p9gw58qOuVZ9jbsLh/m6K
         Tq8oPbtRGelIy+i6fYwMdq0hL9azJIs8bmjqaSq/jILgEu8d48/1wGrVjCnArYCUQoVZ
         qzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FQGxZIdmR9W/uYd+nLTaeKNhLCxJN8rtlec/bbms6jA=;
        b=hNMNbxLeV3y9AEGmqzbIojyCYdF9mldV8m3uuSwaB69M0fiIU7OB6RC8/A6Px3O/Rm
         oopM1fd/sNk8ti9XJj0uJFPsWrZqGB23jKmB0fuTbtaha+MbwOtyQERxQSzDxYKZn2aF
         fNWbaPwyEMoNn7fYwBLoD6c+ICYIf+OB23APNcmcTyMp6mWdwRCkXuvkozZxZ0SGlovV
         7vO/pxRsBDzzrJZS1p16EB+xOOQp27bGD2GX9hsARmcmVu1xjvPVWt+K9e8FXgWXhJI0
         /VId+SP0/Xw7X9QgFmPZ7X3mu96/yY5YbLCWmcxjK5LJsVZpKrg9ou0n6Q4SC9d9CIhs
         xZRg==
X-Gm-Message-State: AGi0PuYA8qIJrj7ZkXAFL78I0qxlsdVXVj9ZtdiaI4/YAHFy1kOysWGA
        3cMqC0SjUlISEdNzjN0p3HU=
X-Google-Smtp-Source: APiQypIGDTeO8xduiQ2dhxEJtqoN4RdJ7uLCJcUt7tMug24dxqHuoj0VcI7V2o7wTpvKidqaE+1PAA==
X-Received: by 2002:aa7:8d90:: with SMTP id i16mr2876806pfr.126.1586485629157;
        Thu, 09 Apr 2020 19:27:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z6sm427194pjt.42.2020.04.09.19.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 19:27:08 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
To:     DENG Qingfang <dqfext@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Wang <sean.wang@mediatek.com>,
        Weijie Gao <weijie.gao@mediatek.com>,
        linux-mediatek@lists.infradead.org
References: <20200409155409.12043-1-dqfext@gmail.com>
 <20200409.102035.13094168508101122.davem@davemloft.net>
 <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <c7da2de5-5e25-6284-0b35-fd2dbceb9c4f@gmail.com>
Date:   Thu, 9 Apr 2020 19:27:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/2020 7:19 PM, DENG Qingfang wrote:
> So, since nothing else uses the mt7530_set_jumbo function, should I
> remove the function and just add a single rmw to mt7530_setup?

(please do not top-post on netdev)

There is a proper way to support the MTU configuration for DSA switch
drivers which is:

        /*
         * MTU change functionality. Switches can also adjust their MRU
through
         * this method. By MTU, one understands the SDU (L2 payload) length.
         * If the switch needs to account for the DSA tag on the CPU
port, this
         * method needs to to do so privately.
         */
        int     (*port_change_mtu)(struct dsa_switch *ds, int port,
                                   int new_mtu);
        int     (*port_max_mtu)(struct dsa_switch *ds, int port);

> 
> On Fri, Apr 10, 2020 at 1:20 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: DENG Qingfang <dqfext@gmail.com>
>> Date: Thu,  9 Apr 2020 23:54:09 +0800
>>
>>> +static void
>>> +mt7530_set_jumbo(struct mt7530_priv *priv, u8 kilobytes)
>>> +{
>>> +     if (kilobytes > 15)
>>> +             kilobytes = 15;
>>  ...
>>> +     /* Enable jumbo frame up to 15 KB */
>>> +     mt7530_set_jumbo(priv, 15);
>>
>> You've made the test quite pointless, honestly.

-- 
Florian
