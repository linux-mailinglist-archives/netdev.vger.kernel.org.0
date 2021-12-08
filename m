Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6E646CBCB
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbhLHD6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhLHD6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:58:16 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E63C061574;
        Tue,  7 Dec 2021 19:54:45 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso1496407otf.0;
        Tue, 07 Dec 2021 19:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RUogFM0kx8hG5CML308BJba4rCWmtzMw1GcR/PSkUeo=;
        b=Do3nPkhUAb7ueDg6r2mwveq1BQ8yKc6tqRcSxlGMZLxTOVHKvA1VTkQAbdiPvxtVO9
         psHxrzlESuaoJT897lNOG+PS75cDROXr5+2Ql+wQj3fnWrW2OHYMQ4HyH1M/Ql1HrcSH
         qjeI/YTaUk6pWWu6gkUFvZ4jQy81xOR9IUu6WPvTo1XTkQPnAriAXJ0iWqzzBVpE7FIV
         LxAdjDvjQGH9PU6cLvg84poWg+d/VAyd2bwd0meC/QPH6uHfKTUxaelFGlvx34CZtaJp
         RrYULP7UkJCg2L/oa3xxa+7VBhd4sMjI8vsUQ3DjD1w6I8DqF/6cj3ZPPDUyEl2MO3wB
         ok9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RUogFM0kx8hG5CML308BJba4rCWmtzMw1GcR/PSkUeo=;
        b=o3McFKcFBcAz7JVG160kE+xJDyAz634TtixqGzW00X6P+f4jmAcMKnuTLOjB7AitQD
         FhKQIg+6l/+N/azIc01Ap//502EHNiqPC8reU+vxbDtyIv5kT1OgYyALDdvBvAkpksm2
         fVTiTWM2169LNZMRO6QpQLnBDbpabEskQbuRRCj4Zg+rKN9ez+/aIEoZ6UJMrPOyljHE
         Lfanf34G2Q9CBPly+QBD5K3fu9SuqOItDnrpoNIhKdQj2hGcGjpOPippF66fycRy0VBO
         hxn9iyY3RvFlTsc5EsBN3yl4/oiwIzht8AkX4UeSP27Ah9Rqj+zWSsFTW/whBpAdFaIB
         QWBg==
X-Gm-Message-State: AOAM532AnP6+uii4rIlnn75MuSSI+NZi5lIpz4yV1LgEiHYkP/yHzk4h
        MXA5ei2KSUwNmtRQxRxe6kg=
X-Google-Smtp-Source: ABdhPJxx2XN/X1EPFbGOO2uGv5+eyt1AMPMJ91EHnz2jR+ocwXiBRYSlPB75x+WnjaNuHXr+QAieAw==
X-Received: by 2002:a9d:d68:: with SMTP id 95mr38087169oti.188.1638935684516;
        Tue, 07 Dec 2021 19:54:44 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 586e51a60fabf-a8853e8734sm15873fac.5.2021.12.07.19.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 19:54:44 -0800 (PST)
Message-ID: <ec6245eb-4bee-f3f3-6bc1-c91ef2b06aa4@gmail.com>
Date:   Tue, 7 Dec 2021 20:54:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: selftests/net/fcnal-test.sh: ipv6_ping test failed
Content-Language: en-US
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>, lkp <lkp@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>,
        "Li, ZhijianX" <zhijianx.li@intel.com>
References: <PH0PR11MB4792DFC72C7F7489F22B26E5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com>
 <20211207075808.456e5b4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2918f246-7a48-4395-42bb-d50b943480c6@gmail.com>
 <PH0PR11MB47924ED34AE948FB0E6CF933C56F9@PH0PR11MB4792.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <PH0PR11MB47924ED34AE948FB0E6CF933C56F9@PH0PR11MB4792.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 8:50 PM, Zhou, Jie2X wrote:
> hi,
> 
>   man ip, the output about exit value is like following.
>   "Exit status is 0 if command was successful, and 1 if there is a syntax error.  If an error was reported by the kernel exit status is 2."
>   Did the following COMMAND have syntax error? If not, should I still change the expected rc from 2 to 1?

strace of ping6 shows it is failing with '1'.

As for 'ip', it returns the exit code of the command run. iproute2 code,
lib/exec.c, cmd_exec().
