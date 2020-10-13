Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550BF28C702
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 04:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgJMCFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 22:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgJMCFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 22:05:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E225C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 19:05:47 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id r10so13638146ilm.11
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 19:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJsaD8bPdy1Qz/9syntqHSJI75fj0kwd5NS1dqij4E0=;
        b=gclyF6ODKozT1FFjouilAduZaTZ6yhG5JQt1Ni0TXeKrSpPCR7XX0vnpc1EbuFdMRa
         GVBz3ll4LS0NhpiBZ2/piEynqV+Gh9+TrgVK1WNKjGiqZfduFeaD1GJBBg+rgtgx1rdK
         YLx5Z+48tIf1vUFNIyAw1tl5Gq9Gdnwq/MxPYsrXzuxnGeWssm6UVgikZY8qbVKINtjL
         UP7h+iIYx5kIlyRX494ZlY/EUhykH+/kHWRG9NA/GQ5HQi+tF8rYJrWWT1eR/eo48BGP
         CF6PhKd3IWYMXb3lGS7UguUuli10CrTEJhxTXZevQiI+0fAiWa53kLYaEfQaS7AxROWW
         Zs5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eJsaD8bPdy1Qz/9syntqHSJI75fj0kwd5NS1dqij4E0=;
        b=pHfpwR504A5N89liuZiFkIJSuUk8A2fCO2EZpOK7qasXK5KbgrBlal7jSnV3QTO0tM
         MNGYvarY6vP0J1rgVaCupptZ3jUf0DzcaDk+ZiaVtgp3y3kf6t29zIOiIckRdy/bwbhH
         QZMSrZVuDuhlD/xdiWv30pvT7Ka40XYl/oIujbMtck2E76XfID+F6J+mGzVKUNHuUAfr
         R8dntzGsSBlJf2njfRNSeaaHufLmQ2osZSW0CX2M2OtX3dL58U+kamuEujTibVBsJtmW
         ssF1SC3prSfoob0uxGAetXd+p6JlCD4EhlvphRaWrBlxZbMUpDJM8fyQ415OsGcaZVM1
         9p3w==
X-Gm-Message-State: AOAM5314UI/FLL7C8d442Sf6PtMJW95BpIJbG8V2EoPWjwMkr6b6UFbH
        xlHbGq16/lN8AUjuTIpQS1w=
X-Google-Smtp-Source: ABdhPJxpoxjmpUjE9rg+60uoa1QumIjglWtlL4YbzGkFlf4boiZToEPOcXBlcoP0RdXmlOEm/+iw8A==
X-Received: by 2002:a92:d850:: with SMTP id h16mr1246409ilq.281.1602554746970;
        Mon, 12 Oct 2020 19:05:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id c2sm8073611ioc.29.2020.10.12.19.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 19:05:45 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vlad@buslov.dev>, Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20200930165924.16404-1-vladbu@nvidia.com>
 <20200930165924.16404-3-vladbu@nvidia.com>
 <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com>
 <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com>
 <87imbk20li.fsf@buslov.dev>
 <81cf5868-be3d-f3b0-9090-01ec38f035e4@mojatatu.com>
 <87ft6n1tp8.fsf@buslov.dev>
 <5d4231c5-94d2-4d14-292f-e68d015ea260@mojatatu.com>
 <87d01r1hi8.fsf@buslov.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d9468ce9-78a7-f5a4-baaa-479fbe4380c9@gmail.com>
Date:   Mon, 12 Oct 2020 20:05:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87d01r1hi8.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 9:38 AM, Vlad Buslov wrote:
> 
> On Fri 09 Oct 2020 at 15:45, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-09 8:15 a.m., Vlad Buslov wrote:
>>>
>>> On Fri 09 Oct 2020 at 15:03, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>>>> Which test(s)?
>>>> I see for example d45e mentioning terse but i dont see corresponding
>>>> code in the iproute2 tree i just pulled.
>>>
>>> Yes. The tests d45e and 7c65 were added as a part of kernel series, but
>>> corresponding iproute2 patches were never merged. Tests expect original
>>> "terse flag" syntax of V1 iproute2 series and will have to be changed to
>>> use -brief option instead.
>>
>> Then i dont see a problem in changing the tests.
>> If you are going to send a v3 please include my acked-by.
>> Would have been nice to see what terse output would have looked like.
>>
>> cheers,
>> jamal
> 
> Sure. Just waiting for everyone to voice their opinion regarding the
> output format before proceeding with any changes.
> 

go ahead and send a v3 with example output. cc Jamal and Cong

