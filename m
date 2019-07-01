Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFC5BEB1
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfGAOvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:51:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36786 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbfGAOvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 10:51:15 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so29500914ioh.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 07:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+Ck1eoyLCbnE3A/umEm7h9O4HYaTBBL4U6JBkwzRO+w=;
        b=nSgsCzGiHQE7orVZGPuEXR+T9WYro8E3k6V8n1hIreew8B15ZyM8skDFHiJfgG+End
         5MH3XRzT8aqAneqq01IYWxfmNG8546alOcGG9m3YyGjZTT3pUiHDYD2vDkmFK4rr57k3
         BFpODFoe/WwrcngOcxZsJoq6a4lXKJ8+1bUeNq8Q3p5yg9uCJtGjni/L9eDMklX0VF4i
         k7/piC3OQDE2To0dqSEkYYXYe6VlIKWUGXG99aJo4bNBuFjkTlKrfGvXZy3g8dpYU/nw
         JgZLzf0n0zpHxFrs8xcMHVY+2U5nrqHj7jkAMNEMU3XRJnoojWuD8EBgY8bEtq5FV9d5
         lVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Ck1eoyLCbnE3A/umEm7h9O4HYaTBBL4U6JBkwzRO+w=;
        b=py0tUnVcYPfzl1naiVaCMZkwmPlbGr6+A+q9nTXLKJv52d5fdB5CZaDozvonENFekp
         EXMUVqyEq093qYTFvX6RldhESBEO4/KemEIPgTtiSkKe9+11gFvF/ydx4st0wDSZT9UW
         xB9dJW1LO8AZcrNnMzdEBi2HAfOTIQTIbBpJ4IHwp7otueIiIDvctPB4FigRiE0sEHLc
         BJivgYjVxvCpIqo8OpWB21AVnX1iBcRxRGujaHZqJLGKMYvOo1u9KlLff0rn7jQYXx3B
         Kk18UyeSpHZFeCaRmRDHqkXtN+q7k7E6hA1nJa2IKuIL3b6r0yWcrmAlFvaqejR+4P+k
         coGQ==
X-Gm-Message-State: APjAAAV5dKWs4xOc2MuOpVC0IvlLXGLxBPcfeeuqthQYKF4D+UZw2eLx
        hG0kmiUDY1/pQen3rg7TZulIuUVn
X-Google-Smtp-Source: APXvYqxMkmzMPvfmR/SgkzNLaSKdDLAbxsxV4dfWtVjfNiMw1ALsbZJp3Mzxjp8/eUiaEc+jDXmW2w==
X-Received: by 2002:a6b:2c96:: with SMTP id s144mr26656875ios.57.1561992674477;
        Mon, 01 Jul 2019 07:51:14 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f191:fe61:9293:d1ca? ([2601:282:800:fd80:f191:fe61:9293:d1ca])
        by smtp.googlemail.com with ESMTPSA id r139sm23852785iod.61.2019.07.01.07.51.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 07:51:13 -0700 (PDT)
Subject: Re: [PATCH v3] ss: introduce switch to print exact value of data
 rates
To:     Tomasz Torcz <tomasz.torcz@nordea.com>
Cc:     netdev@vger.kernel.org
References: <c28e349c-25b7-7a09-b2b3-5e64294bb089@gmail.com>
 <20190701115242.25960-1-tomasz.torcz@nordea.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <13d80225-8b36-3990-4718-aafbb9602d7d@gmail.com>
Date:   Mon, 1 Jul 2019 08:51:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190701115242.25960-1-tomasz.torcz@nordea.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 5:52 AM, Tomasz Torcz wrote:
>   Introduce -X/--exact switch to disable human-friendly printing
>  of data rates. Without the switch (default), data is presented as MBps/Kbps.
> 
>   Signed-off-by: Tomasz Torcz <tomasz.torcz@nordea.com>
> ---
>  man/man8/ss.8 |  3 +++
>  misc/ss.c     | 12 ++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
>  Changes in v3:
>   - updated ss man page with new option
> 

ss now has Numeric option which can be used for this as well if we
broaden the meaning to be 'raw numbers over human readable'.

