Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC9C69C83
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfGOUQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:16:56 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42026 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbfGOUQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:16:56 -0400
Received: by mail-io1-f66.google.com with SMTP id e20so5899390iob.9
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 13:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zmGWbUm7Odh8E1jd5KlJTrVigC1hDfwKGrgGHQvVf5o=;
        b=qE0tkznryrcqxjQwWWa3xxbuv3SXsW0rUFLrvvcmOYtgZJ5h8DB12Kba5jLjqQgBma
         e+CRgEJ8Y45vyRI9jdDy1C2SBQnIpqn60s3tSf+fpshE2lq/xWq8eGfXT6KiGcckrLCV
         6Rq4Nad5EfcmWqWYZs/cX6BIOtFtgZFXVcglXL8NXji8ngcH+xcgUWexd4lnC0vu/Na8
         1gWHZqumzTwqb7EwFmaNGDprUqzmKUFTZcPPMT/bC2MrzLraP24qoGDP0clw87JCmSe/
         d6Q3JkxcRpspxF13YLp4N3mUP/ZHowR6YmtBgpUd1BOfKj62kq904tlbS937vJ5Cc2rV
         jQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zmGWbUm7Odh8E1jd5KlJTrVigC1hDfwKGrgGHQvVf5o=;
        b=SFURA895dIBq27WZCfTkxmCAUcCtnaH/AWMkGe5Fo9UrAS9crcWTGZyhWHur3mzKnz
         Byb+nyk3hSTulX0193RwNmLuQWnJaDIHXoijrSnTgo+P2bYi6xSblXp1a7VAinGqs/+q
         cfEDeRMf1NBUpyi4V9bzjs1mQz6YKbDyQL9K/iN3yM9VAJSNhFN0IwQnsn6UincItjyn
         EeM0FKnYEI39egA61yWquFsa8AhUZKyE2AyqDdK2p9lm615cRikuc82Rrg+qhkauhzF5
         RFxet0PBobE0y0X3bQgLnvZfC5Iwo5UIF8JPtSg16McgmLoR9IxijGDLcNtb4kqVuqdr
         ltCQ==
X-Gm-Message-State: APjAAAXErD2J1rIMPh9BUISZa0bzCw0q7Jq9EMb7mV8CxsfHswwwWk64
        HruG+HYVMcdU5NvI0u9Mls0=
X-Google-Smtp-Source: APXvYqzZQJpbaoDcOYHZ9L0PGzzGlUMR1/Re6LSsAMw4bnISrNSqug+hr/8HEI3nyr2AFk5eLvYS6g==
X-Received: by 2002:a6b:6001:: with SMTP id r1mr22584164iog.229.1563221815752;
        Mon, 15 Jul 2019 13:16:55 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:51b4:3c95:43b6:f3d0? ([2601:282:800:fd80:51b4:3c95:43b6:f3d0])
        by smtp.googlemail.com with ESMTPSA id z19sm22809808ioh.12.2019.07.15.13.16.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 13:16:55 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v2 1/6] Kernel header update for
 hardware offloading changes.
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "Patel, Vedang" <vedang.patel@intel.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
 <0AFDC65C-2A16-47B7-96F6-F6844AF75095@intel.com>
 <20190715125059.70470f9e@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2c13cf19-0b4a-2149-1624-040191cedad9@gmail.com>
Date:   Mon, 15 Jul 2019 14:16:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190715125059.70470f9e@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/19 1:50 PM, Stephen Hemminger wrote:
> On Mon, 15 Jul 2019 19:40:19 +0000
> "Patel, Vedang" <vedang.patel@intel.com> wrote:
> 
>> Hi Stephen, 
>>
>> The kernel patches corresponding to this series have been merged. I just wanted to check whether these iproute2 related patches are on your TODO list.
>>
>> Let me know if you need any information from me on these patches.
>>
>> Thanks,
>> Vedang Patel
> 
> 
> David Ahern handles iproute2 next
> 
> https://patchwork.ozlabs.org/patch/1111466/
> 

given the long time delay between when the iproute2 patches were posted
and when the kernel side was accepted you will need to re-send the
iproute2 patches.
