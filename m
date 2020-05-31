Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2821E9AC1
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 00:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEaWws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 18:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgEaWws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 18:52:48 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03C4C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 15:52:47 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id q14so6121925qtr.9
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 15:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XPU0/62U05SPwX2OHSSy/zgYhj1oAyPtFSDudmBUBMw=;
        b=oiMK7b55Wg7d1Mc3/Oi0vXadmSMQFJteHxs6muBZ5k4h6nPyVEgAU8qePcw+nXfOo3
         R9nhG3AdVcbq+xHJEY2kkE3YHm0dTuLsJSPE625Amg2rtfU3zYPeacYfQPtavq93jFGD
         1B8wBfrAJRepPcQpBP/vgi3PM2Y/L8ZnQqBsks88nMHHFzeHaEO6tGcDFgZZ+aIK0D+x
         DlZ8X728VstNKq18NTAlM6d3pfj5wGD0A4ta81XOJT+m5Vs8Yl1VHKids9HXqn499JHo
         dCQjc2f6z6W3H8x/XKNn5Nr2iukMoVt/GqeXGKQkWzqiKC2F2Hh7VWircj4wMe6rpL9m
         eF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XPU0/62U05SPwX2OHSSy/zgYhj1oAyPtFSDudmBUBMw=;
        b=Nvkg9cz2jtHvXG+xkixIyTVYK3i5syF17Y0SbN9BrXMXTqdroOzZHG7CncZayBJJmw
         P5y1rcTo4fFoigIasCV3j6R+nfP3eQT1VKrdludW40cUpiUzwWeU4qS5uC6uDggvN8Xg
         R4YgFsLMb6ed570qMatBCsaH9PrLqNLee32fJl3ErIp+BYM+S8aGATEjqTvJ22W8DZP2
         nxVDJnpsZ8kbO9OaESjOL+TRw5V3QmBraFvn//EX+seNxXnjl0BBobpVgmZC8yME6zD4
         o1zgY3BE5I/mMgu9yqhDrHkVW7/nv99b0hbzDAZ3OqGDSXxocpA2/RSOQizWTn8/3LWv
         QfRg==
X-Gm-Message-State: AOAM531MZ0hZFsSDYBblTDDqlrTk4EP6wlHce0Z/OooWGFg+opQ/CMFM
        HqnlGv68d+gLc1gzEHILdsc7IGyD
X-Google-Smtp-Source: ABdhPJxFApK6qRcJchjQJKmDUHyJgu+OPCxlhn4alBEiSAO63pfgSL7cmfY9tVCTBXHlvoxquybbyw==
X-Received: by 2002:ac8:7941:: with SMTP id r1mr19567924qtt.290.1590965566091;
        Sun, 31 May 2020 15:52:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:384e:54b7:a663:6db3? ([2601:282:803:7700:384e:54b7:a663:6db3])
        by smtp.googlemail.com with ESMTPSA id m94sm13962567qtd.29.2020.05.31.15.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 15:52:45 -0700 (PDT)
Subject: Re: [PATCH v2 iproute2-next 1/1] tc: report time an action was first
 used
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1590628967-4158-1-git-send-email-mrv@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5dc6b816-5d2f-d6b4-b183-ae73e7f80f69@gmail.com>
Date:   Sun, 31 May 2020 16:52:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <1590628967-4158-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 7:22 PM, Roman Mashak wrote:
> Have print_tm() dump firstuse value along with install, lastuse
> and expires.
> 
> v2: Resubmit after 'master' merged into next
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---
>  tc/tc_util.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

applied to iproute2-next. Thanks,

