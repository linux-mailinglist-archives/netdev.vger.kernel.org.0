Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20B7FD765
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKOHy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:54:29 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43094 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfKOHy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:54:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id y23so9614640ljh.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 23:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+C6UFetkkOkabjlrx29bRj2f/pHq6ZunDxUzZ7B8oJI=;
        b=Tj7gXOnqtuG0wJhNZbvfhuhFF7Ajj+d/fkSs7BOhJuk6zYcUK3pqsPz4KlpJ5C6cZu
         CQ9MRWf2wM06ny9O2bnOKcTBNvY1ewmlHc0/L/nIx34DK3gZJOIMBOt6MJMcRJUnM6lj
         Sty8aREsnWc3bR9ednCLj5/uDLng1EyPh4j+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+C6UFetkkOkabjlrx29bRj2f/pHq6ZunDxUzZ7B8oJI=;
        b=ginfGiQLyYKeixTS3gzCt+HXiltgcQvFvmzqOkxE1Cy//X3Og77ph7NHHG8NqFfYlp
         4udmmgHfyIqRiTKgGuLqHa+hd0c9yMRfONsgJuSmUKkV5FfUFu+JEckmE30o8uMGsHrL
         ZAcEAwGO+be4oXt23W6Th4ZGe6dYPBsE70v6AsuT4f/QCc+Yn9LLj/mOlzccE16ZH+LJ
         MoG8sDC+Lua3OpXmAkP3yffKf0JhhrRC4NZRJsNZQKf/rmh2JaF74eMln3pdVZorn+OM
         3L3mNIJ1h+25+CRn+Twv9L67S6m4eEGAHlNb2nyUL3pILuRFN9LW3uhpp8Zs6wwg15w4
         3Z3w==
X-Gm-Message-State: APjAAAWlGavLg59CHSoiMsUr/GPtTxbMQt5oFIjBSs9mRmK3jN2Rf7uB
        nAQImD+qMznkQfp3jYv+7b4dXL+KboGaFLZz
X-Google-Smtp-Source: APXvYqwtca4V1MXOZa/BxeDe/jqUfjT4UHa/rribPRAykBqSAV8Y1dWumBHX7aG8dBwq5CyNgx3uLQ==
X-Received: by 2002:a2e:8809:: with SMTP id x9mr9979158ljh.82.1573804466324;
        Thu, 14 Nov 2019 23:54:26 -0800 (PST)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id w11sm4254332lji.45.2019.11.14.23.54.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 23:54:25 -0800 (PST)
Subject: Re: [PATCH v4 46/47] net: ethernet: freescale: make UCC_GETH
 explicitly depend on PPC32
To:     Li Yang <leoyang.li@nxp.com>, Timur Tabi <timur@kernel.org>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
 <20191108130123.6839-47-linux@rasmusvillemoes.dk>
 <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
 <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <29b45e76-f384-fe16-0891-cc51cfecefd4@rasmusvillemoes.dk>
Date:   Fri, 15 Nov 2019 08:54:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2019 06.44, Li Yang wrote:
> On Thu, Nov 14, 2019 at 10:37 PM Timur Tabi <timur@kernel.org> wrote:
>>
>> On Fri, Nov 8, 2019 at 7:04 AM Rasmus Villemoes
>> <linux@rasmusvillemoes.dk> wrote:
>>>
>>> Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
>>> change anything. In order to allow removing the PPC32 dependency from
>>> QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
>>> dependency.
>>
>> Can you add an explanation why we don't want ucc_geth on non-PowerPC platforms?

It's not that "we" don't want to allow building this on non-PPC per se,
but making it build requires some surgery that I think should be done by
whoever might eventually want it. So _my_ reason for lowering this
dependency from QUICC_ENGINE to UCC_GETH is exactly what it says above.

> I think it is because the QE Ethernet was never integrated in any
> non-PowerPC SoC and most likely will not be in the future. 

Well, that kind of thing is impossible to know for outsiders like me.
Maybe one can amend the commit log with that info:

"Also, the QE Ethernet has never been integrated on any non-PowerPC SoC
and most likely will not be in the future."

Rasmus
