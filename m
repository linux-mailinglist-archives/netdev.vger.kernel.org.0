Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4514743980C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhJYOFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhJYOFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:05:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28192C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:03:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i5so8001345pla.5
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5M79DpMGMtkGwEE/3fwSGJQR89+0LJRUG7P+Du7h9r4=;
        b=pPNYHSPwcXSM7HmCcIX5tdR34X5rgCHMBUKM3pM6oxGYv1ytiYr9I2meMGeUWcHNyh
         9gch4ZA4K0Tgc1/aEe2NXuoaYE1agBJVBNPp7Q8Qn8kWBnk4P5sMIegZqxA94d2pGMXU
         igFE7jOol2SGfC1rk4QCYsBR5SrUvItwoGrtWtyszka/8chgo3P6VSEW4MRCi9dDHbTz
         4nx5C8rqjtgazjcV5P4hGFUQXHrKA5/jMQLLtjOFFNajHNrxNf4cXR7ptLGSFLYZYy0N
         PGxx3CNH/pN66q4AaDmacCiglZa7kKTekkn5YLn4e29vc1WFlklihCaPqGbxJx8HEnHg
         k5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5M79DpMGMtkGwEE/3fwSGJQR89+0LJRUG7P+Du7h9r4=;
        b=cadZNvgvOqOuL+H090dTP8EL11+a3pRJBEsH19/GA0kNBaaD7Gsg/Ftt1BXmqlZa1U
         2P02MVUVMT2esbLO2ILq7fAogpyWexWW4uMdcXIOcr9EqYYcnGbQbTJwqN2sWRA/JU0O
         4kBSp2HUkleZzwZfvrD4xE0/y0CqINvlFkddG/slFQH7XOmPNPtZ1qWWG9wHd/a0KZYs
         Qf4Xhx0/DCBJjUxpsLHbc+B3aD8Qmx+UqPydwnnylPbWlHyG7+f07+L+IpBOR2H499YO
         1ZIoTex6a8YlEyWycU0ToILnnDwOYKIdTUT1UtpZVDNHhQgJaGl1MQfkhMU8miL6to2Y
         KFww==
X-Gm-Message-State: AOAM531//DweRbhd9XZzhNbfh5w0YclanIAppzmEn7Nz+q0ITL9dx2X/
        QIwtR6LkzAzNeeTYl9PzYeJhTrlGV4tpWw==
X-Google-Smtp-Source: ABdhPJzbRlDM9EY99DROVckirMo303PwfpeqQSjYC0IfvVSZaAMHnvLeZyJEOB/JgTJI4ueFSPEjfA==
X-Received: by 2002:a17:903:304b:b0:140:3cca:dfff with SMTP id u11-20020a170903304b00b001403ccadfffmr11570830pla.12.1635170610330;
        Mon, 25 Oct 2021 07:03:30 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id h3sm9297605pfi.207.2021.10.25.07.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:03:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: add AMT support
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20211023193611.11540-1-ap420073@gmail.com>
 <20211024164526.2e1e9204@hermes.local>
 <acab97fc-e134-47a5-0385-4dc3754a818e@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <1775071c-208a-132c-eb3e-637204d9cb02@gmail.com>
Date:   Mon, 25 Oct 2021 23:03:26 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <acab97fc-e134-47a5-0385-4dc3754a818e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David and Stephen,
Thank you so much for the review!

On 10/25/21 8:52 AM, David Ahern wrote:
 > On 10/24/21 5:45 PM, Stephen Hemminger wrote:
 >> On Sat, 23 Oct 2021 19:36:11 +0000
 >> Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >>> +	while (argc > 0) {
 >>> +		if (matches(*argv, "mode") == 0) {
 >>
 >> Try and reduce/eliminate use of matches() since it creates
 >
 > Make that do not use matches. We are not accepting that for any new
 > command line arguments.
 >
 >> lots of problems when arguments collides.  For example "m" matches
 >> mode only because it is compared first (vs "max_tunnels").
 >>
 >

Okay, I will use strccmp() instead of matches() then send the v2 patch
Thanks a lot!

Taehee
