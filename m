Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C7B482813
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 18:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiAARpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 12:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiAARpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 12:45:25 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B7AC061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 09:45:25 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q3so21646567pfs.7
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 09:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SDSXlOcXodSnlvM7J21wWZupnQy2iDygaGuwZjjUF0M=;
        b=lbgQYQ1Ex6wNggtqSVrM3W3ytVwLA6xnGXliAqwOvVOQglzjyEhCbeyw5eO3+6ByCK
         PH/4eDqqvLD6lQwVV+kpOr2oGXKbBKZUq6+zs/Lm0m/WhWzpYRe4XhgBEo5v0CW+0z5E
         KsgWTkK7AhN4FHTNi2mhmTCjGJoMV7tyd6tZnQk09Q4g+7gI+P28vdYoiCGsD4FrSH9Q
         AFa0Kyzlk+eh62sUxyDe2h7kj/uOujmvf/G+B5mybhaGjHOuWIlAEq5wzk2VUcOkmQPT
         pIAzQgwqw1rDszU6R4OONBkxUbtteEOSmva7BcNywRV7wpG9KqxE61fs2JnM4q8B60yV
         FrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SDSXlOcXodSnlvM7J21wWZupnQy2iDygaGuwZjjUF0M=;
        b=ItAxuL15zCPf/ziwZbAEFAu8LUtbKVhks4NV/yDVrjTNbeqvo+aUViJ5LbNY7zWV7W
         6jEJZVZ9vBCkS7PHm9zuMyIKUPBvOexUrHSI0LKQfqDsxt3CapxY6pqljACj5zcsl4kJ
         b/l5fwVe/Zfp8C1NtvK/WJX1psWNys/b+y3+25jqVIHc/JobGTjuyMvnTwccCrVJ1BcQ
         v/0sCYgN9TRPVUCWyfZzBRw+we7zyotwBTMeStHb6ADbFp5FoCDuJZ9sADUqO66Sy995
         Pr4KArdqlGjREecQrhfUI5LHY36IppSVWosTpgocnBPn+lY3GBMeUszlKbvP6juTIwuj
         FyKQ==
X-Gm-Message-State: AOAM532YUHmaBSSZ0DcCvbk3NYb3pAFmqk03BzKnnf2e6++9cVbhivfZ
        Apw3sVGzQdAr1kB4wqlAmrk=
X-Google-Smtp-Source: ABdhPJzLPtUnanhMzvMWQa9oP5W78WAWeyJAyTq8GuvyXtl76sBj44qJRRCd1EkLjod/aexKvIIPYw==
X-Received: by 2002:a05:6a00:1a43:b0:4bb:8507:9568 with SMTP id h3-20020a056a001a4300b004bb85079568mr39270670pfv.42.1641059124780;
        Sat, 01 Jan 2022 09:45:24 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:15d3:103e:dff7:3c99? ([2600:8802:b00:4a48:15d3:103e:dff7:3c99])
        by smtp.gmail.com with ESMTPSA id s8sm33042382pfk.165.2022.01.01.09.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 09:45:24 -0800 (PST)
Message-ID: <46a8f724-9a20-baf4-e774-d2c1a3d1e9c5@gmail.com>
Date:   Sat, 1 Jan 2022 09:45:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v3 01/11] net: dsa: realtek-smi: move to
 subdirectory
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20211231043306.12322-1-luizluca@gmail.com>
 <20211231043306.12322-2-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211231043306.12322-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/2021 20:32, Luiz Angelo Daros de Luca wrote:
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
