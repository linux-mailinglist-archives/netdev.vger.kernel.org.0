Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7965A4B5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfF1TBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:01:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55631 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfF1TBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:01:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so10073983wmj.5;
        Fri, 28 Jun 2019 12:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ckoxpxJTkoCeeN4f/pv9Q0LSUSeSbayeJqjMrlXsfu4=;
        b=aeuXDOl4B/FrLr+xqHc+NSwH6W+FgWMzhO2qP7T3xYnfCoxgZfXx2BG6B4EmTh8NI1
         owzcAdBzt7lT7O71SN3bCQqrFIZfsqNZcP45OeAjKDvPUV+0yQuLQrove9lHY9B04G0q
         9IECVu8ycAPPMhz/MebVo4PbXL2AOqluLnLIl6K7uNnPb2IunSCpimP/1paoPBH8Ric8
         wsRhJDf3n6lGk4fX7DeJPbC2ec4duf8Syrd2Mi4WB1ycrqSfoie/D5XzrzckDpoJoZAj
         7EWbjv3EN98eGCctiACIKLjkP5V8JOViElmdxiI1pHcwLsxt+93p0yTLSxgmtQKUk20D
         WpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ckoxpxJTkoCeeN4f/pv9Q0LSUSeSbayeJqjMrlXsfu4=;
        b=HGKdp5basxl8wgUA0pUZ1WRjXO97eEepAIzv0/monRT35QeqPOlxcqitbegiLc/pG3
         dxnhnsv5N89OIQgR2UaP9wvJzCkhlPW88FQ8OiT5G+8QlcrUqASWgZL9DuwIcAZPqW39
         VoUWRxBskF4sbL8wx/8oED8ZeTPdap4d08QC8SNqpGUghJnZmk1XbD+Hw80KU1aFtvyy
         LVqBTRYvgOYOkZQMDQnmLlK9F+XtiIoj46yCRNFV365hCrnlTRfYganonGJoRnE64jW1
         e/+cpyOtUWNyt5PJd5L5eHg0I+2VrUoQoc8yI8LQ6259CBiFarJ9DSJi11QDLBzuIhEC
         TsMw==
X-Gm-Message-State: APjAAAWcxRMvzv8ki/+x+Nw8/rShsiAcpSO77iUzLbjhAj1NQtaaYPG8
        jaRTxkzEAKUjr9p0OsVSfp3U5ceN
X-Google-Smtp-Source: APXvYqzMnrV9MewVYZEH/cd/CrdO81xXl+6ATv+n329Tuf2QOzpW/WNm875lYRascC6GWlUaKH+Jiw==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr8321987wma.78.1561748503632;
        Fri, 28 Jun 2019 12:01:43 -0700 (PDT)
Received: from [192.168.1.17] (bkq83.neoplus.adsl.tpnet.pl. [83.28.184.83])
        by smtp.gmail.com with ESMTPSA id z5sm2980090wmf.48.2019.06.28.12.01.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 12:01:43 -0700 (PDT)
Subject: Re: [PATCH 24/43] docs: leds: convert to ReST
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-leds@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
References: <cover.1561723979.git.mchehab+samsung@kernel.org>
 <2fecbe9a9cefda64771b43c5fc67495d897dd722.1561723980.git.mchehab+samsung@kernel.org>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jacek.anaszewski@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFWjfaEBEADd66EQbd6yd8YjG0kbEDT2QIkx8C7BqMXR8AdmA1OMApbfSvEZFT1D/ECR
 eWFBS8XtApKQx1xAs1j5z70k3zebk2eeNs5ahxi6vM4Qh89vBM46biSKeeX5fLcv7asmGb/a
 FnHPAfQaKFyG/Bj9V+//ef67hpjJWR3s74C6LZCFLcbZM0z/wTH+baA5Jwcnqr4h/ygosvhP
 X3gkRzJLSFYekmEv+WHieeKXLrJdsUPUvPJTZtvi3ELUxHNOZwX2oRJStWpmL2QGMwPokRNQ
 29GvnueQdQrIl2ylhul6TSrClMrKZqOajDFng7TLgvNfyVZE8WQwmrkTrdzBLfu3kScjE14Q
 Volq8OtQpTsw5570D4plVKh2ahlhrwXdneSot0STk9Dh1grEB/Jfw8dknvqkdjALUrrM45eF
 FM4FSMxIlNV8WxueHDss9vXRbCUxzGw37Ck9JWYo0EpcpcvwPf33yntYCbnt+RQRjv7vy3w5
 osVwRR4hpbL/fWt1AnZ+RvbP4kYSptOCPQ+Pp1tCw16BOaPjtlqSTcrlD2fo2IbaB5D21SUa
 IsdZ/XkD+V2S9jCrN1yyK2iKgxtDoUkWiqlfRgH2Ep1tZtb4NLF/S0oCr7rNLO7WbqLZQh1q
 ShfZR16h7YW//1/NFwnyCVaG1CP/L/io719dPWgEd/sVSKT2TwARAQABtC1KYWNlayBBbmFz
 emV3c2tpIDxqYWNlay5hbmFzemV3c2tpQGdtYWlsLmNvbT6JAj4EEwEIACgCGwMHCwkIBwMC
 AQYVCAIJCgsDFgIBAh4BAheABQJVo39tBQkJZgNMAAoJEL1qUBy3i3wmxLQQAK8QEQ0JqZEv
 5hrxiwT+Qtkx1TULYriK9sYcY9zbi18YxbKB0C4Znh5iP5o7k26WnPGLM+w4qWvTAkHjuAI7
 aBrvb4nGRvE5s14PQ9IHgL7iL3zAAHT1azIZng9dUCCSontB+vQZu1x/Un0lVlVCvsvO7QVt
 hAZUlT3iucNMO0jpCiS3raZkNfab8M+JWP/iplaV0Kn+O7LX3A/RdLmx5ZhuT+zvyHwl2c3K
 T56UHaQnjkuHB2Ytk8HtOjNXGNYnm4nLx3ok3jEN1nWDRV/DeiPn8zz4Zebsp686OH9vvX/0
 R4dk2YEjUCY/S7CbJxXzUnLjboUAGmtTVOu/uJ7y11iS9XEoJ09HEzijQwWctJXLojcTXCFw
 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
 eGGiEQ==
Message-ID: <0b2a2452-20ca-1651-e03b-a15a8502b028@gmail.com>
Date:   Fri, 28 Jun 2019 21:01:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2fecbe9a9cefda64771b43c5fc67495d897dd722.1561723980.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

On 6/28/19 2:20 PM, Mauro Carvalho Chehab wrote:
> Rename the leds documentation files to ReST, add an
> index for them and adjust in order to produce a nice html
> output via the Sphinx build system.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  Documentation/laptops/thinkpad-acpi.txt       |   4 +-
>  Documentation/leds/index.rst                  |  25 ++
>  .../leds/{leds-blinkm.txt => leds-blinkm.rst} |  64 ++---
>  ...s-class-flash.txt => leds-class-flash.rst} |  49 ++--
>  .../leds/{leds-class.txt => leds-class.rst}   |  15 +-
>  .../leds/{leds-lm3556.txt => leds-lm3556.rst} | 100 ++++++--
>  .../leds/{leds-lp3944.txt => leds-lp3944.rst} |  23 +-
>  Documentation/leds/leds-lp5521.rst            | 115 +++++++++
>  Documentation/leds/leds-lp5521.txt            | 101 --------
>  Documentation/leds/leds-lp5523.rst            | 147 ++++++++++++
>  Documentation/leds/leds-lp5523.txt            | 130 ----------
>  Documentation/leds/leds-lp5562.rst            | 137 +++++++++++
>  Documentation/leds/leds-lp5562.txt            | 120 ----------
>  Documentation/leds/leds-lp55xx.rst            | 224 ++++++++++++++++++
>  Documentation/leds/leds-lp55xx.txt            | 194 ---------------
>  Documentation/leds/leds-mlxcpld.rst           | 118 +++++++++
>  Documentation/leds/leds-mlxcpld.txt           | 110 ---------
>  ...edtrig-oneshot.txt => ledtrig-oneshot.rst} |  11 +-
>  ...ig-transient.txt => ledtrig-transient.rst} |  63 +++--
>  ...edtrig-usbport.txt => ledtrig-usbport.rst} |  11 +-
>  Documentation/leds/{uleds.txt => uleds.rst}   |   5 +-
>  MAINTAINERS                                   |   2 +-
>  drivers/leds/trigger/Kconfig                  |   2 +-
>  drivers/leds/trigger/ledtrig-transient.c      |   2 +-
>  net/netfilter/Kconfig                         |   2 +-
>  25 files changed, 996 insertions(+), 778 deletions(-)
>  create mode 100644 Documentation/leds/index.rst
>  rename Documentation/leds/{leds-blinkm.txt => leds-blinkm.rst} (57%)
>  rename Documentation/leds/{leds-class-flash.txt => leds-class-flash.rst} (74%)
>  rename Documentation/leds/{leds-class.txt => leds-class.rst} (92%)
>  rename Documentation/leds/{leds-lm3556.txt => leds-lm3556.rst} (70%)
>  rename Documentation/leds/{leds-lp3944.txt => leds-lp3944.rst} (78%)
>  create mode 100644 Documentation/leds/leds-lp5521.rst
>  delete mode 100644 Documentation/leds/leds-lp5521.txt
>  create mode 100644 Documentation/leds/leds-lp5523.rst
>  delete mode 100644 Documentation/leds/leds-lp5523.txt
>  create mode 100644 Documentation/leds/leds-lp5562.rst
>  delete mode 100644 Documentation/leds/leds-lp5562.txt
>  create mode 100644 Documentation/leds/leds-lp55xx.rst
>  delete mode 100644 Documentation/leds/leds-lp55xx.txt
>  create mode 100644 Documentation/leds/leds-mlxcpld.rst
>  delete mode 100644 Documentation/leds/leds-mlxcpld.txt
>  rename Documentation/leds/{ledtrig-oneshot.txt => ledtrig-oneshot.rst} (90%)
>  rename Documentation/leds/{ledtrig-transient.txt => ledtrig-transient.rst} (81%)
>  rename Documentation/leds/{ledtrig-usbport.txt => ledtrig-usbport.rst} (86%)
>  rename Documentation/leds/{uleds.txt => uleds.rst} (95%)

Patches 4/9 and 24/43 applied to the for-next branch of linux-leds.git.

Thanks!

-- 
Best regards,
Jacek Anaszewski
