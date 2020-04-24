Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3576F1B6C7E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 06:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgDXEXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 00:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgDXEXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 00:23:10 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE95C09B045
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 21:23:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so3434059pjh.2
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 21:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ka7FEGk7p+85cTH/y7AxVHoYYNsSKHkOcwBeJVHM3BY=;
        b=exG7+uzdXyLwKgTYAbxN3+K+m5QwG407S1Evmvmf2Q8lkso/A0353FH5CRfalTjFaB
         Wb98BArh+Q9uuQmV3q3fyFeydTYh4nl8Ai8OjjuWJb7hQ0C6emGQiqyKuxNsXCcDBTPp
         bEo53NRJLcLn3Igqj43Qawgq3VIykGWZoOT5NYvOH0Lu6ClYaAG96Snxl22F2PU2pPUq
         7+uLbi3jzg8vO4g3OcDBhBaP/VFxFOce+4MOGikxzu7NaQ+SPluqhYiXhw28yM3e3y/z
         XJEWgs8OKIFK0D4Z1P5wS6zkx+GLBP8eBBLdR7Nz9nR+pcBJAsiJc3K1j+Pb08b0STAT
         41/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ka7FEGk7p+85cTH/y7AxVHoYYNsSKHkOcwBeJVHM3BY=;
        b=HGnrv6jSHPUFngtOKNiugvcrsWrcrgjrgD5QyUv0e+UxkiHhXUxLilOw8+6BM90NW7
         PYGW4wVdBal3bfIRXqhdX5dWrrPkp/46kp0XoJtd/MJm43qpRcwDwSjcxKc910RtZBxM
         qs/2Y9cSanr3HBBbGmlXZVgNTPOXA+U5CX8cnN4mHEQyLILNVS/Ck+8ucVPove4JB7vE
         Nfz0b6J9wlsaj+Pc0a6TM5NDMFTUCogtB1jpwOCPoqed9F3NkcQ3pR7otX+/fAy3kSsc
         d1bkWVORGWi358GoJEH1Sx1hDBZNPiYOFTfmJsucIXsUh1WLDR9AYhuYowb8LIIVUuwd
         PoLw==
X-Gm-Message-State: AGi0PubGUMm2ELTeD/zvI3YLfhEBepJJm6pBtQ1X1lqh1HfLHtbLl4TQ
        AApMudUlLOpIE1ikJg25BE1vnJy5
X-Google-Smtp-Source: APiQypLypbbkPen7lvNh6EZliWmTyEo1E+MxanJd7IQJvL4Bphyl419CglWk/WH7rbTegSdp3lGKdA==
X-Received: by 2002:a17:902:8497:: with SMTP id c23mr7366429plo.335.1587702190106;
        Thu, 23 Apr 2020 21:23:10 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t103sm3725121pjb.46.2020.04.23.21.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 21:23:09 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
 <20200423073529.92152-1-cambda@linux.alibaba.com>
 <3e780f88-41df-413c-7a81-6a63fd750605@gmail.com>
 <256723ED-43E5-4123-B096-15AD417366CD@linux.alibaba.com>
 <2df5f6de-ee68-8309-8b48-a139a4fb6b36@gmail.com>
 <73F510E3-F212-47B5-B575-97D15A3311C7@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9c998b27-07c7-48e4-f3b7-a2f83d834dfa@gmail.com>
Date:   Thu, 23 Apr 2020 21:23:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <73F510E3-F212-47B5-B575-97D15A3311C7@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/20 7:56 PM, Cambda Zhu wrote:
> 

> If the value between sysctl_tcp_fin_timeout and 2 minutes is legal, should we set tp->linger2
> to TCP_FIN_TIMEOUT_MAX or return an error instead of set it to zero which means the default value?

I would not send an error.

This might break some applications that could consider an error as a serious one.

(You can reuse my patch basically)



