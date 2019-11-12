Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DAEF9C66
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfKLViv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:38:51 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37194 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLViu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:38:50 -0500
Received: by mail-ed1-f68.google.com with SMTP id k14so31994eds.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7IQIL9Get0wH/ZS5WQf63zxHfLvK+H+M/awmh5weoiw=;
        b=JCEURPSWzNcF9XSqELGSHXmST8B3GdT6C05UTs0TnmG9kydtaMiFOMx0ATjifTbB7j
         Oc956Qd90UJysuHgj1qcmna+TsLSgjyG2H6/99Ll+vAx5RCdBPegXoOs9X8c22NaP2UM
         Nx605+uN8FT8bGPKtw8cj5ey2wnveJNhd//psg/B7AMEW5LP9KDSxwOiyg8jJ+f8Vrp3
         mH8BkXzMZgYusWJ+QTi/Y1n+cD2112fd55JvD5bMmwCQgKQzs4O9EbgexJdmLmsIrld9
         bo9thaN1pi15glVjQaZoGyYnxZvVdO5J34mwLhMr63HjPIEgh4n+86h2uVtIoJ0WZG+1
         +6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7IQIL9Get0wH/ZS5WQf63zxHfLvK+H+M/awmh5weoiw=;
        b=e463AKMZDYks8HAIhX08edDfHObq8NYQBUE5tvzQNv8yxZId1XB7ml7FuYGE2x3jER
         h4p9BosamCpQ/K7h0vbQFgCV0kRmpdBFZol55aO4lK708xvoSb5Y3NNSb01yQH0OMIHs
         +TJcGSOvJ0dytyZjMn80m2M5DeW67txOFPa21UcjH4FCNQRkL500Es8F7GjtEuePmv8w
         jvT9runZOc3fAzFXUSH62bnjfhqlSvzUGO2iTIV4QfirmfFFdthpyNfnomkw+hBDrnBL
         DzPDnyM075fBHSJSXzaHfXfFhoqiXUz9xp7mKSMqTyOhFaxHAZ3N8xVl4e6/G1509PJU
         pEkg==
X-Gm-Message-State: APjAAAUW8TxOfLlm27VQwwVgagwJJKI019pz+h9BWImS+UtY/ysCKcWb
        fEuz+K+ogg8Ch3mc2JVO+Hkjac1i
X-Google-Smtp-Source: APXvYqy/bW0x40JoiXaEbsWiTN4T7zX8fwPbOgTKUg4SgwQzlkcyBNaGLRxzk0I6wdm/Ec05H9ZywQ==
X-Received: by 2002:a05:6402:1156:: with SMTP id g22mr36063428edw.233.1573594728403;
        Tue, 12 Nov 2019 13:38:48 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d18sm3074edy.79.2019.11.12.13.38.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:38:47 -0800 (PST)
Subject: Re: [PATCH net-next 09/12] net: mscc: ocelot: publish ocelot_sys.h to
 include/soc/mscc
To:     Vladimir Oltean <olteanv@gmail.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6f92f3bd-9d97-9cea-b485-843521dcee9a@gmail.com>
Date:   Tue, 12 Nov 2019 13:38:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112124420.6225-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 4:44 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The Felix DSA driver needs to write to SYS_RAM_INIT_RAM_INIT for its own
> chip initialization process.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.h                      | 2 +-
>  {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h (100%)

This was not done before for include/soc/mscc/ocelot_hsio.h but you need
an update to the MAINTAINERS file to catch that file now:

$ ./scripts/get_maintainer.pl -f include/soc/mscc/ocelot_hsio.h
linux-kernel@vger.kernel.org (open list)

expected:


Alexandre Belloni <alexandre.belloni@bootlin.com> (supporter:MICROSEMI
ETHERNET SWITCH DRIVER)
Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
(supporter:MICROSEMI ETHERNET SWITCH DRIVER)
"David S. Miller" <davem@davemloft.net> (odd fixer:NETWORKING DRIVERS)
netdev@vger.kernel.org (open list:MICROSEMI ETHERNET SWITCH DRIVER)


> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index 325afea3e846..32fef4f495aa 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -18,12 +18,12 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/regmap.h>
>  
> +#include <soc/mscc/ocelot_sys.h>
>  #include <soc/mscc/ocelot.h>
>  #include "ocelot_ana.h"
>  #include "ocelot_dev.h"
>  #include "ocelot_qsys.h"
>  #include "ocelot_rew.h"
> -#include "ocelot_sys.h"
>  #include "ocelot_qs.h"
>  #include "ocelot_tc.h"
>  #include "ocelot_ptp.h"
> diff --git a/drivers/net/ethernet/mscc/ocelot_sys.h b/include/soc/mscc/ocelot_sys.h
> similarity index 100%
> rename from drivers/net/ethernet/mscc/ocelot_sys.h
> rename to include/soc/mscc/ocelot_sys.h
> 


-- 
Florian
