Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C514E25A2CD
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 03:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgIBBzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 21:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgIBBzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 21:55:09 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19A0C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 18:55:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id b6so3629980iof.6
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 18:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Ey6Or2jiS0yjdSLj1uOiOljCl8dJpBOBkaBGqaRE3k=;
        b=ItqAtaCb9PehmJxB8FPw1AIMlHT3rwYv2EUunor4iUlaUALz4HCr44bxa7EV/40MWt
         58AeuKzC7yVrOqbreq76IsyOnu90JVHRHkDhwYTQkI8CpKpOLQmeJ5JI0lRwdn87P05P
         V98aWjOZgd+uws7jumnMmdiZpR/vH2T5pZnf3hf4j/L1WDz3i0qnRV3JRkZrTHcMhopj
         SEYNL2PBAvptoCayaNONmblQ1lpId0k1tPgShULLnEknp7nqRFT9t+7XFlseU6EY2Wmc
         NiZU3clSeOA13b9qR5FBO+9NiqGWSSQ2lyLovbW3pC2j+13h0lo9djgFB3Caafi4KamM
         xUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Ey6Or2jiS0yjdSLj1uOiOljCl8dJpBOBkaBGqaRE3k=;
        b=Nwir7FC1lrGSnqF0KkeQwfmxg3b6gRwCKSQRVZub01Y/mXFOJETRysylRpm2WfqxPT
         KnR93epeVM4CZluXH+AqYtSHxBpKFGu4s7kFHnNA/sQAnZ9mn0AGJffNy6ZQfgtIU8ph
         QkCMluLWMugcNRJv+TaXgDgdUNvMFSGsY8TswNSmwwmgAx4tWlSkO745CKawI9PZmV7E
         AwOXgJHVvDpX4BlkxtJk5I8porxs+idLYUIAs75dsEwEJw3QAEw/yctadlA0Tq3kxOr/
         bPdB6/DtEXqBZMx4Bg5wuzB21cBBc+Z/BVcZsYa43fA2DC3wPqlG41n1Mx70kV+tWmC5
         na9w==
X-Gm-Message-State: AOAM530e8Nu74PB4HoejZDIu2ejPx6B/Tr5tDM0EG7Ybj6GpWCwXRpgg
        sEuwP7xUf9Y9U62RvgHmDXvRqwPaoYbUjg==
X-Google-Smtp-Source: ABdhPJzIZ2+ZIXcgtSOV3OqcKOXcED5wpJs01g75atO0jrXZm2btbc2Qedu4kWqfuk3BdeIbdwhKKw==
X-Received: by 2002:a6b:700f:: with SMTP id l15mr1688144ioc.168.1599011707292;
        Tue, 01 Sep 2020 18:55:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id i73sm1527887ill.4.2020.09.01.18.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 18:55:06 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip xfrm: support printing
 XFRMA_SET_MARK_MASK attribute in states
To:     Antony Antony <antony@phenome.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20200828145907.GA17185@AntonyAntony.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <93e07827-51f8-2732-e7c8-25b35453374f@gmail.com>
Date:   Tue, 1 Sep 2020 19:55:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200828145907.GA17185@AntonyAntony.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 8:59 AM, Antony Antony wrote:
> The XFRMA_SET_MARK_MASK attribute is set in states (4.19+).
> It is the mask of XFRMA_SET_MARK(a.k.a. XFRMA_OUTPUT_MARK in 4.18)
> 
> sample output: note the output-mark mask
> ip xfrm state
> 	src 192.1.2.23 dst 192.1.3.33
> 	proto esp spi 0xSPISPI reqid REQID mode tunnel
> 	replay-window 32 flag af-unspec
> 	output-mark 0x3/0xffffff
> 	aead rfc4106(gcm(aes)) 0xENCAUTHKEY 128
> 	if_id 0x1
> 
> Signed-off-by: Antony Antony <antony@phenome.org>
> ---
>  ip/ipxfrm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

applied to iproute2-next. Thanks


