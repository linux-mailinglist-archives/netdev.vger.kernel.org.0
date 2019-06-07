Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1884738230
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 02:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfFGAfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 20:35:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43145 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFGAe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 20:34:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so164103pgv.10
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 17:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=P2XpBHOyrxWbSiu1DkLjoTmSyPZeDSjpCd7IkQNn7bM=;
        b=AELbiTLaec/VpjR0KQeBLJpfLj/7HjdLu0rwQ+6IZxSYc2x+X6ZQiWDPF2niRmqAiA
         ewzXKLKDoSIskWt524P1lahwSOscApMIOkvRISM6ZXUrpZIL4wQ5qNZm5nqS0z9HaoHI
         em8F6OOkkyBTcDQvrYrBy0IK61cnrFOEnQ2ShH2MiTTZP0BzyTkdE52OKEPcjkoiaXPQ
         ImV/kkPPV2m8RGBmGdBKkLHXqRUkiAJEwaThR4Lc8RD+Yq1VAVu+v0NRqNwlthhgpLxc
         bDh3S68JO4h5fBSnohXvw4WQe2Esn5W4XxmC4mxIAs5hihV8SY07qQ8BSExwDa42eMJp
         UZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=P2XpBHOyrxWbSiu1DkLjoTmSyPZeDSjpCd7IkQNn7bM=;
        b=oX5JvKHaj9tHUlnhU/ua5842xnjf6H2rsVJZVnbm+9D1aVbGdfmo3ttlSzIKmR/Ms9
         OJ3RrbszIr//YzIqbmicHBJTzMStra6r6dVF8NeX1/wNrpZzkimQJXXcVxV61766dhs8
         S1livI7xXMGlGCggAsifPWLg6/qAJwafBMKWDbJIFydFho/R4YvXX68eFtDSv2XL7K9S
         YaA0rd79zjBFynQWXb0btU0EvMo/kt3tLQt5FeMUhn4V8FmDNT/zwRCPbT2cHsmjCzZG
         MmYG2350RaKnZ2uj/r9KzpkPcLOwCSKgWxoaWRkQMtnVbO+hQ1jzPUmKSIEzgK5xVMu4
         FcUQ==
X-Gm-Message-State: APjAAAVZ7YmcTnJwa31MFiAa7AEhF+9/j/2cGuPkCmBtxAbR+M7qgjte
        cAQPwyQkFz47UWq5byzXIix1SYIV
X-Google-Smtp-Source: APXvYqxqcqBuW44fJxWgcv8eFLkF7V1eugOqnfllwdAJ/wR2XEEyiZE/bANaHC1cfl6LtXWwKst5nA==
X-Received: by 2002:a17:90a:b283:: with SMTP id c3mr2729814pjr.28.1559867698957;
        Thu, 06 Jun 2019 17:34:58 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:152a:31bb:51fe:8dbb? ([2001:df0:0:200c:152a:31bb:51fe:8dbb])
        by smtp.gmail.com with ESMTPSA id s12sm234135pjp.10.2019.06.06.17.34.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 17:34:58 -0700 (PDT)
Subject: Re: [PATCH 6/8] drivers: net: phy: fix warning same module names
To:     Andrew Lunn <andrew@lunn.ch>,
        Anders Roxell <anders.roxell@linaro.org>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20190606094727.23868-1-anders.roxell@linaro.org>
 <20190606125817.GF20899@lunn.ch>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <e56b59ce-5d5d-b28f-4886-d606fee19152@gmail.com>
Date:   Fri, 7 Jun 2019 12:34:47 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606125817.GF20899@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andew, Anders,

sorry I dropped the ball on that one - I've got a patch for the ax88796b 
PHY driver that I just forgot to resend.

It'll clash with your patch, Anders - are you happy to drop the 
CONFIG_ASIX_PHY from your series?

Cheers,

     Michael


On 7/06/19 12:58 AM, Andrew Lunn wrote:
> On Thu, Jun 06, 2019 at 11:47:26AM +0200, Anders Roxell wrote:
>> When building with CONFIG_ASIX_PHY and CONFIG_USB_NET_AX8817X enabled as
>> loadable modules, we see the following warning:
>>
>> warning: same module names found:
>>    drivers/net/phy/asix.ko
>>    drivers/net/usb/asix.ko
>>
>> Rework so media coda matches the config fragment. Leaving
> No media coda here.
>
>> CONFIG_USB_NET_AX8817X as is since thats a well known module.
> Again, place base on net-next and submit to just netdev.
>
> Please rename the PHY driver asix88796.
>
>         Andrew
