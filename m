Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8954BEB5C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiBUTxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 14:53:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiBUTxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 14:53:03 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3AD22524;
        Mon, 21 Feb 2022 11:52:39 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id l8so13729182pls.7;
        Mon, 21 Feb 2022 11:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nz5j6wJSA8JcyV5jdjTaNW3K3w+wwFqJxUa50on0g14=;
        b=pks27cVXL7wlimgj3wPbw7CahjiXrq8XGprix4y3zT7tQF59wV18wJonjgkqghy+Sj
         X6Ex+gLtGkZOgOXBPUtRJnm67LfD0+JP3uvmoAP1T1af/j6hiKl3v2uaIuYvT9fR/R9H
         K+bgVnDtbyb8aU/gDQ0OjoXlUWxDxTTB+/PwI1JsXMBVwyw+HgzDpfwXjo990yd1KZFY
         uIXsgQihD1iPkhzcxCyrLbMXnRpFh0jIhx7rME9TMZcWcMJYyGUxPj7ImhBib3tDojwm
         F8IsYaxR6kqXQ0KQqAktxGcI2qYPCa4U3weDRR8ToNy3uJqhwKLhT+BI0e/yofVIoF7Y
         VW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nz5j6wJSA8JcyV5jdjTaNW3K3w+wwFqJxUa50on0g14=;
        b=ib15lKdY6uViDY1iy6hhV2a38q07K8zero9ydLp6P4xAixgnqs599n6ncQw1ybVmwx
         tLkQJK1WK2YbDXQ6XZZEh/lQ55spRWSqtIDIKw5kIfzD0gng3RWlziSAdz/20WmHv26H
         ZZcL9/Wd8qBREiR1GziOS4zUolL1TM2ktRdacGG+Z4w0M2dGv+gbZjtokFnWx0L8EsTO
         pJ0ipr5WKT06sBe5qFTH2qnDK8pzFTnxKwSI9xmAXVRKzSocESX7tJZbJGvodrNTIgkB
         IWgAAdBH8ExgTSWQahK0pxq+kNZnf50UDfwzgfe/7zRhp7SXH25M5lLSOK7lhjrbnCXf
         owvw==
X-Gm-Message-State: AOAM5329R5yEsFkQXXh8lUkl6pgj+H+R/MPXM/SD5lVtyM4NsUY1MXNF
        IoQuMBKjJ0DOBg56c7ai19s=
X-Google-Smtp-Source: ABdhPJyBYs7hrijAk9kpBwi66arawYeQyJwkygWr4nCOBfwSI6OJhP+5wGn9yWJ/yin4Sf19R00I8A==
X-Received: by 2002:a17:902:76ca:b0:14d:8c80:dbda with SMTP id j10-20020a17090276ca00b0014d8c80dbdamr20488200plt.152.1645473158384;
        Mon, 21 Feb 2022 11:52:38 -0800 (PST)
Received: from [192.168.0.2] (c-73-158-10-71.hsd1.ca.comcast.net. [73.158.10.71])
        by smtp.googlemail.com with ESMTPSA id c13sm14342723pfi.177.2022.02.21.11.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 11:52:37 -0800 (PST)
Message-ID: <70c598ed-315d-0232-9b92-06ba672a22d1@gmail.com>
Date:   Mon, 21 Feb 2022 11:52:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Linux 5.17-rc5
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Woody Suwalski <wsuwalski@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com>
 <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
 <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
From:   Robert Gadsdon <rhgadsdon@gmail.com>
In-Reply-To: <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/22 10:01, Eric Dumazet wrote:
> I am pretty sure Pablo fixed this one week ago.
> https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=2874b7911132f6975e668f6849c8ac93bc4e1f35

Applied this patch, and the problem is fixed, now..

Thanks..

Robert Gadsdon.
February 21st 2022.

