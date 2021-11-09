Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C744B254
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbhKISIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241503AbhKISIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:08:39 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8540C061764;
        Tue,  9 Nov 2021 10:05:53 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v20so22383738plo.7;
        Tue, 09 Nov 2021 10:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iPx8PtVjRAEJKaeRj9ASLlLQi+k77E7ZU8+NhiKqr+4=;
        b=K/rq1xmrnqRYOU8htMZi8icnBxQVoLaIMcP3+xEYScFUOmRScZSgrW4NVsF4wt75G+
         EVpvVjPWqUwqlEVSG1K6d2o5+mfLZNLNMwXCdqnt0/d6JU+VHn4SUuLCjoO8z/xT9vyH
         zwoQvUBg8ckkk/FX5lK/DGbXrMf0nSORPSAug2Z1U+gFf4A8e9sdf+SXrBZXTMfmzZmV
         O7br7BigyvmGO1gNxBDg6MKc41Yb2ktULIlgchTCAiGeZNTh1ORNJukdyUV0gmT1wH91
         RHTd3gWMzwipii10Q1j/OAKY9OUaadKxnuCkEIr4lGlq+v98VVmPXkb2DqoaBS5gCARL
         sbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iPx8PtVjRAEJKaeRj9ASLlLQi+k77E7ZU8+NhiKqr+4=;
        b=jTfC+QRQsT3FEvJB+01L92uJIiA6144hm4dx8/UFypWbU1jtcIOqH2M4uqgj1btTek
         kZnTxwDB+ffTuY3T08uMEW7du//F1Rbyqh5OHj6eUG2hEabKTWPaITFKw7jagnEp2Llq
         tP2lvArh+QHALcPXt9MZZssXlZW+vqKqqY/RsuubGwtMhUcAbqmkbNkbyxFawQ3apy7p
         vnM6mPi2s0kFQuD2dr+ylMQUwjPQHpTRG72gJZ+Vl5C76Meq8qTueoYv84DDV1MoFe2n
         dAHxvlZtnYISpLEi3V/LsRHjzEoGtly+JVFD4sIJ9KCDlDWXnoByoCVGmvWeU8tKGZNh
         pVYA==
X-Gm-Message-State: AOAM532YkJp6zpt6GGTbo+jmQbDikuP5A7W5Z4aoxuMfJzgBpbiNM0fF
        dXzK0rFS6xwPc8lROrIxZ3wiQN3Ueus=
X-Google-Smtp-Source: ABdhPJxJ22pFfHKuPonDK/7TnI595Kz1tk2HSRtNtiZFKTJy0meyv4agoCIyFU0XKyzBOZxt2w3USQ==
X-Received: by 2002:a17:90a:8c0a:: with SMTP id a10mr9259230pjo.58.1636481153003;
        Tue, 09 Nov 2021 10:05:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z2sm21384375pfh.135.2021.11.09.10.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:05:52 -0800 (PST)
Subject: Re: [PATCH v2 2/7] net: dsa: b53: Move struct b53_device to
 include/linux/dsa/b53.h
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-3-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f71396fc-29a3-4022-3f7a-3a37abb9079c@gmail.com>
Date:   Tue, 9 Nov 2021 10:05:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109095013.27829-3-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 1:50 AM, Martin Kaistra wrote:
> In order to access the b53 structs from net/dsa/tag_brcm.c move the
> definitions from drivers/net/dsa/b53/b53_priv.h to the new file
> include/linux/dsa/b53.h.
> 
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---
>  drivers/net/dsa/b53/b53_priv.h |  90 +----------------------------
>  include/linux/dsa/b53.h        | 100 +++++++++++++++++++++++++++++++++
>  2 files changed, 101 insertions(+), 89 deletions(-)
>  create mode 100644 include/linux/dsa/b53.h

All you really access is the b53_port_hwtstamp structure within the
tagger, so please make it the only structure exposed to net/dsa/tag_brcm.c.
-- 
Florian
