Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0810E4D6
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 04:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfLBDSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 22:18:31 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36614 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfLBDSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 22:18:31 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so3159241pls.3
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 19:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4bE7Kn3hkfVw8sL0NreOTV9xhsPMr6uJEGfhuFVrSsc=;
        b=ImXNAKj9Ko5ZaDNw6LM1ZvPy2Kl13+KV0CJNyhHSbY41wI7Lyjd+JQlvKEM0eH6pEM
         9ZPoJuCYM/TKzSbNi+y8KYRMzxzOPWNXJfRF6hFyQ3+4H8xgJNiGtRx7LFr6wt7+mo+J
         Gf9/jOVczQvVfy04jOU885d2a+udRRwX6fMrtmYiIPbV3GJZLC8DMd8uc/+/PF6/kjCk
         7pt3q8HbDaWyFVOq8mhlJ+ZbD9UhW+PMXt0tk53g5VTwMBx0Xow3rjiQlNiJT5JIfrFw
         A7gKvDJU2eDhZsNJ1lPBQ1IgOxKtlrZSH40RskHoKqUtE+/33txMTuyTtxmv60A0OWmm
         HKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4bE7Kn3hkfVw8sL0NreOTV9xhsPMr6uJEGfhuFVrSsc=;
        b=TEZettFOL3zgMbNRKAsVdX2ZX0v+RAFPr8MMJVVWryYNf8xOxx3l5Ougyc7PzhYBwB
         fZMNq0KN/g3O0BxyelKPdRqoGViGt1v8Seh3GbyCVFk+5W3P4heoqW3ATwgtVa1M1Zqr
         IkTEseA2J0KfmEuiA7ClCsEPi9Hk+mGd5lnRwU9IwXGLOcXFYwENoXoFbs2izwqhyVqs
         NRiRUZT0Vulv0cGXaikXWMI54GY1s04ShKuHiAejarmBnBC9p1ntSQFKlH5kHQ6Y7Q26
         VmSliJUtUyZHwbdgPBBexzwVAU0fOxI0o3TvOwDIgB6LWUgsjCV81N2tQKdC9NmGEk/g
         cexw==
X-Gm-Message-State: APjAAAV04O1iss/zU703mB+a1uIaJGoWfUIFlgHn35taN4PHVo9uH2an
        CCVc2hM1DeZ5awZYTnZTgC3X1sdJ
X-Google-Smtp-Source: APXvYqzN3kgyFJcGYF/m55h09wCpHv4Pplz3Z1Ze+h+j8IpR1jRplgYhJ0zw0OJ3RbcCFEX+1oW8wA==
X-Received: by 2002:a17:902:8f98:: with SMTP id z24mr25913732plo.35.1575256710055;
        Sun, 01 Dec 2019 19:18:30 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h5sm15641476pfk.30.2019.12.01.19.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 19:18:29 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH net,stable 1/1] net: fec: match the dev_id
 between probe and remove
To:     Andy Duan <fugang.duan@nxp.com>, David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1575009408-30362-1-git-send-email-fugang.duan@nxp.com>
 <20191130.122742.343376576614064539.davem@davemloft.net>
 <VI1PR0402MB3600232AF1CF9203704DCE83FF430@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <f6c05c83-4784-7017-187c-3262a3b45622@gmail.com>
Date:   Sun, 1 Dec 2019 19:18:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB3600232AF1CF9203704DCE83FF430@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/2019 7:04 PM, Andy Duan wrote:
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> Sent: Sunday, December 1, 2019 4:28 AM
>> From: Andy Duan <fugang.duan@nxp.com>
>> Date: Fri, 29 Nov 2019 06:40:28 +0000
>>
>>> Test device bind/unbind on i.MX8QM platform:
>>> echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/unbind
>>> echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/bind
>>>
>>> error log:
>>> pps pps0: new PPS source ptp0 /sys/bus/platform/drivers/fec/bind
>>> fec: probe of 5b040000.ethernet failed with error -2
>>>
>>> It should decrease the dev_id when device is unbinded. So let the
>>> fec_dev_id as global variable and let the count match in
>>> .probe() and .remvoe().
>>>
>>> Reported-by: shivani.patel <shivani.patel@volansystech.com>
>>> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>>
>> This is not correct.
>>
>> Nothing says that there is a direct correlation between the devices added and
>> the ones removed, nor the order in which these operations occur relative to
>> eachother.
>>
>> This dev_id allocation is buggy because you aren't using a proper ID allocation
>> scheme such as IDR.
> David, you are correct. There still has issue to support bind/unbind feature even if use IDR
> to allocate ID because enet instance#1 depend on instance#0 internal MDIO bus for some platforms
> and we don't know who is the real instance#0 while binging the device.
> 
> Do you have any suggestion to implement the bind/unbind feature with current dependence?
> Thanks.

Can you use the device driver model to reflect the link between the MDIO
bus device, its parent Ethernet controller and the second instance
Ethernet controller? Be it through the use of device links, or an actual
dev->parent relationship?
-- 
Florian
