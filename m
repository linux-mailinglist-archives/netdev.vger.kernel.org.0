Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F794F09BF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfKEWqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:46:13 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37658 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbfKEWqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:46:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id q130so1176707wme.2
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7xwWVXiuG1tLPN6CPka9ylUlJIP2hCJ9RzlJKfzF5/I=;
        b=G5KV+1mriyllS9vliRA/FB2eSB8+Y1pVuDH+yOGI9/dlU6p4f0CEBcf1v3g2sqUVJJ
         2ZuBQ9rKXI0+Unyi+pLfp6ghnwr3XOeicCMuKJ0jFCjXXJlMRdxRxf3s3fKZcJdPdWWN
         oeQTWKOv+Pi/dicJidS5o5yDQuS2gidH2b8t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7xwWVXiuG1tLPN6CPka9ylUlJIP2hCJ9RzlJKfzF5/I=;
        b=djnEzJdNS8gW5NOYYw+1Am8a8O/ZNciW1SKVnZQanN9Sof0XM/LcFDClRqrBBGMQvE
         43/T5X5VOr6HBLR2Ldl/qSRdl8jG++wh0YGQG2F23/ptJFMGiLdjJ3tiFYO6JK5gfbeK
         s7+WZN4I68IlLzKxJj6Vpd/MtFuOjFEJmYWvbVY9kID0ItQSZ3AK6wtfYDa+BdSxZ4mm
         S1gR8c82eeVFkTJ5n0aDj7SQaQhymXx/SfjptVNf9tfLmkIP+A3xuwfm0JuPSA14l6E2
         jA5pw4Sn5ZXd3l+YDz6YHXkYiXp4J44ZhuWf1c4CnqG35XYyLFNVPRYqJZBqjPwzE+N/
         9t1A==
X-Gm-Message-State: APjAAAWxpTKeJTo8IZ83dQovuTtHeeRili9WsQyQHdpF+keIKS2OD/yb
        AFZ4aDSeKQfHhL4LAPehsSEY7dDLcbjzNQ==
X-Google-Smtp-Source: APXvYqyILKyWyx8z/N+HI9ObpIe8L/xuTBO+aWfJYAW3owIrX4/P2lrMpGLQn5+ocDXByWt/4qGYzg==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr1055811wmk.85.1572993971089;
        Tue, 05 Nov 2019 14:46:11 -0800 (PST)
Received: from [192.168.1.149] (ip-5-186-115-54.cgn.fibianet.dk. [5.186.115.54])
        by smtp.gmail.com with ESMTPSA id i3sm22220902wrw.69.2019.11.05.14.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:46:10 -0800 (PST)
Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
To:     Li Yang <leoyang.li@nxp.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Qiang Zhao <qiang.zhao@nxp.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
 <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
 <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
 <CADRPPNQ4dq1pnvNU71vNEgk1V5ovrT9O2=UMJxG45=ZSRdJ4ig@mail.gmail.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <f48df0c7-77f1-268f-8588-7eff5e9fd7c5@rasmusvillemoes.dk>
Date:   Tue, 5 Nov 2019 23:46:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CADRPPNQ4dq1pnvNU71vNEgk1V5ovrT9O2=UMJxG45=ZSRdJ4ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2019 21.56, Li Yang wrote:

>> No, this patch cannot be dropped. Please see the kbuild complaints for
>> v2,23/23 about use of IS_ERR_VALUE on not-sizeof(long) entities. I see
>> kbuild has complained about the same thing for v3 since apparently the
>> same thing appears in ucc_slow.c. So I'll fix that.
> 
> When I made this comment I didn't notice you have removed all the
> architectural dependencies for CONFIG_QUICC_ENGINE.  If the
> QUICC_ENGINE is only buidable on powerpc, arm and arm64, this change
> will not be needed.
> 
> BTW, I'm not sure if it is a good idea to make it selectable on these
> unrelavent architectures.  Real architectural dependencies and
> COMPILE_TEST dependency will be better if we really want to test the
> buildability on other platforms.

Well, making QUICC_ENGINE depend on PPC32 || ARM would certainly make
things easier for me. Once you include ARM64 or any other 64 bit
architecture the buildbot complaints start rolling in from the
IS_ERR_VALUEs. And ARM64 should be supported as well, so there really
isn't much difference between dropping all arch restrictions and listing
the relevant archs in the Kconfig dependencies.

Rasmus


