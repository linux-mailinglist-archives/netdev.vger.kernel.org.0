Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77AF43055
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfFLTkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:40:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54310 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfFLTkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:40:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so7754418wme.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 12:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VdTOwX6J8lplz0+uQgCEjs7d7Ofk790x+Vs8JVocanU=;
        b=XJjrLGUR6kLdNinRJhhDHzOuZnzCintB5q4Y4vTTriz8z9ayvREh5fDn4VBnJi/ku2
         dT33noVah+IaFtoo5IaOTriiN8jTZjibrBhzxK5TUSu6KuAALSY70ggFh9QdIO+xHBG5
         FREqHJmumLaosdLC21QjsTG0SgBrqcUDeyzBCXHjtJUS4kQJGlwMDaYv62WvqBAze5tm
         rgGBJOUn3YEB3GCcrLvIyoa3PPORWmk8LdmM3OZ3EfTahzug428vd5Gqj+DwcCoOWJ+P
         eTvsJNLt0CLMD0X34NiEoAvNmhzk5gjXzoMT4/IcnaVsP1cNNF2IsA20e1/IlrAv4og2
         o0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VdTOwX6J8lplz0+uQgCEjs7d7Ofk790x+Vs8JVocanU=;
        b=NFVJ+MtRc6MtPuv1KorSBJhiTxS+R2xuz84KyAyVGBcNLdD3SycfPwDo6TpAUJLTad
         njqoHhwhg6o9TnsY9n5SHX+GFKaA6XsLFn/qptONzOgOzp1QB/hHWuZNWyDgIE5XSdQe
         ompJY+QKFQQhQFWNAgXU2D9yAgeYnGkFInVE04aHhUnEb7fTmo36IAf+PjBWt9D7EbdA
         MDGtZETw1P3TCjicOomr5bsHPcuDUXMGj1DXUo2dJs0ZwPNQRknYPnIcipsTWTC2A4u9
         RukaZWtaa6Ya8WX7disX+BgEm34mTYQylMWN40UrQiOQijKrVBBWAhLwmQD340GrerHX
         +3Cw==
X-Gm-Message-State: APjAAAWOWWvD54h9/YJd2yYUoxwYOrzk4p7RUhshaPhJKWQkXq8I2DFi
        tx84m/fOZqvOQeie901wTkYzG80g
X-Google-Smtp-Source: APXvYqzyc65eMROmQmhYkUmUKatnR5I2EgQ13VLlfz+/f3f4qZ9HC/EC2UzoeQ8chbpi7Az+mKSLvQ==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr561620wme.177.1560368445733;
        Wed, 12 Jun 2019 12:40:45 -0700 (PDT)
Received: from [10.67.49.123] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r6sm291885wrp.85.2019.06.12.12.40.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 12:40:45 -0700 (PDT)
Subject: Re: [RFC, net-next v0 0/2] Microsemi PHY cable
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
        netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch
References: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 mQGiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz7QnRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+iGYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSC5BA0ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU4hPBBgRAgAPAhsMBQJU
 X9LxBQkeXB3fAAoJEGFXmRW1Y3YOj4UAn3nrFLPZekMeqX5aD/aq/dsbXSfyAKC45Go0YyxV
 HGuUuzv+GKZ6nsysJ7kCDQRXG8fwARAA6q/pqBi5PjHcOAUgk2/2LR5LjjesK50bCaD4JuNc
 YDhFR7Vs108diBtsho3w8WRd9viOqDrhLJTroVckkk74OY8r+3t1E0Dd4wHWHQZsAeUvOwDM
 PQMqTUBFuMi6ydzTZpFA2wBR9x6ofl8Ax+zaGBcFrRlQnhsuXLnM1uuvS39+pmzIjasZBP2H
 UPk5ifigXcpelKmj6iskP3c8QN6x6GjUSmYx+xUfs/GNVSU1XOZn61wgPDbgINJd/THGdqiO
 iJxCLuTMqlSsmh1+E1dSdfYkCb93R/0ZHvMKWlAx7MnaFgBfsG8FqNtZu3PCLfizyVYYjXbV
 WO1A23riZKqwrSJAATo5iTS65BuYxrFsFNPrf7TitM8E76BEBZk0OZBvZxMuOs6Z1qI8YKVK
 UrHVGFq3NbuPWCdRul9SX3VfOunr9Gv0GABnJ0ET+K7nspax0xqq7zgnM71QEaiaH17IFYGS
 sG34V7Wo3vyQzsk7qLf9Ajno0DhJ+VX43g8+AjxOMNVrGCt9RNXSBVpyv2AMTlWCdJ5KI6V4
 KEzWM4HJm7QlNKE6RPoBxJVbSQLPd9St3h7mxLcne4l7NK9eNgNnneT7QZL8fL//s9K8Ns1W
 t60uQNYvbhKDG7+/yLcmJgjF74XkGvxCmTA1rW2bsUriM533nG9gAOUFQjURkwI8jvMAEQEA
 AYkCaAQYEQIACQUCVxvH8AIbAgIpCRBhV5kVtWN2DsFdIAQZAQIABgUCVxvH8AAKCRCH0Jac
 RAcHBIkHD/9nmfog7X2ZXMzL9ktT++7x+W/QBrSTCTmq8PK+69+INN1ZDOrY8uz6htfTLV9+
 e2W6G8/7zIvODuHk7r+yQ585XbplgP0V5Xc8iBHdBgXbqnY5zBrcH+Q/oQ2STalEvaGHqNoD
 UGyLQ/fiKoLZTPMur57Fy1c9rTuKiSdMgnT0FPfWVDfpR2Ds0gpqWePlRuRGOoCln5GnREA/
 2MW2rWf+CO9kbIR+66j8b4RUJqIK3dWn9xbENh/aqxfonGTCZQ2zC4sLd25DQA4w1itPo+f5
 V/SQxuhnlQkTOCdJ7b/mby/pNRz1lsLkjnXueLILj7gNjwTabZXYtL16z24qkDTI1x3g98R/
 xunb3/fQwR8FY5/zRvXJq5us/nLvIvOmVwZFkwXc+AF+LSIajqQz9XbXeIP/BDjlBNXRZNdo
 dVuSU51ENcMcilPr2EUnqEAqeczsCGpnvRCLfVQeSZr2L9N4svNhhfPOEscYhhpHTh0VPyxI
 pPBNKq+byuYPMyk3nj814NKhImK0O4gTyCK9b+gZAVvQcYAXvSouCnTZeJRrNHJFTgTgu6E0
 caxTGgc5zzQHeX67eMzrGomG3ZnIxmd1sAbgvJUDaD2GrYlulfwGWwWyTNbWRvMighVdPkSF
 6XFgQaosWxkV0OELLy2N485YrTr2Uq64VKyxpncLh50e2RnyAJ9Za0Dx0yyp44iD1OvHtkEI
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <027749b1-ed08-f173-ab63-169f5ab5f71d@gmail.com>
Date:   Wed, 12 Jun 2019 12:40:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19 1:57 AM, Raju Lakkaraju wrote:
> This series of patches add the Microsemi PHY cable diagnostics command 
> with PHY Netlink Interface.
> 
> 1. phy_netlink.c and phy_netlink.h files add for PHY diagnostics features
> implementation through PHY Netlink interface.
> 2. phy.c contain the generic functions of "PHY diagnostics". This layer
> independ of the communication layer (i.e. Netlink or IOCTL etc)
> 3. mscc.c contain the 4-pair ethernet PHY driver along with
> PHY diagnostics feature.

Andrew just submitted a similar feature set, except that his changes are
much more comprehensive, and also build on top of ethtool-nl, meaning he
has payed attention to the work that was going on within the netdev
community.

Your submission on the other end appears to be looking for the minimum
amount of code necessary to support the Microsemi PHYs product lines and
does not try very hard to possibly think about an abstraction layer for
other PHYs but Microsemi, that does not really give maintainers
confidence that you have.

Can you review Andrew's patch series and see if you find something
missing for you to plug in support for the Microsemi PHYs?

> ------------
> # nl-app eth0 request
> GroupID = 2
> GroupName = phy_monitor
> 
> Cable Diagnostics Request:
> Operation Status : Success
> Cable Pairs mask : 0xf
> Timeout count    : 84
> Cable diagnostics results:
>     Pair A: Correctly terminated pair, Loop Length: 0 m
>     Pair B: Correctly terminated pair, Loop Length: 0 m
>     Pair C: Correctly terminated pair, Loop Length: 0 m
>     Pair D: Correctly terminated pair, Loop Length: 0 m
>  
> Application git repository path:
> -------------------------------
> https://github.com/lakkarajun/bbb_nl_app
> 
> Raju Lakkaraju (2):
>   net: phy: mscc: Add PHY Netlink Interface along with Cable Diagnostics
>     command
>   net: phy: mscc: Add PHY driver for Cable Diagnostics command
> 
>  drivers/net/phy/Kconfig       |   6 ++
>  drivers/net/phy/Makefile      |   1 +
>  drivers/net/phy/mscc.c        | 128 ++++++++++++++++++++++++
>  drivers/net/phy/phy.c         |  17 ++++
>  drivers/net/phy/phy_netlink.c | 226 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h           |  88 ++++++++++++++++
>  include/linux/phy_netlink.h   |  48 +++++++++
>  7 files changed, 514 insertions(+)
>  create mode 100644 drivers/net/phy/phy_netlink.c
>  create mode 100644 include/linux/phy_netlink.h
> 


-- 
Florian
