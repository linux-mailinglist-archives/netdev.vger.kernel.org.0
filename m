Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE25F4FAB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKHP3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:29:37 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36811 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfKHP3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 10:29:36 -0500
Received: by mail-io1-f65.google.com with SMTP id s3so6793905ioe.3
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 07:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QjMM7TzDwENpfLcRG8tZi/AAD20SHkYme2eBgBpgSkQ=;
        b=jTjo2O7fA+N/fpmkC29gSJX7jatDMTZbmvhKQXLa2Vic020IqResgwFHp6/Bdgu+7g
         Z5uGubUE0vOt9DLxGNNJJBV4OUAsiMm8tZQxhnR3dwJMQEhuG1nhD/5K1YR4l0TuN6CG
         Ys0WwHIgWrfw05BkD+V8WhTw4dpxMTcy/O9ZC6gO3duGw8pMlJwGjMLz3uLh4iiXabp2
         1Ugmsbr5tmJD995WMgljzXKXaGzcmfWLMwSKGi/hY6zZDODtZcMRwHgs1F1BtbewaTpj
         TQAC4Sx8K4rKkMg7VSaE7kxDfwwXlVdtu5i5OfCSeHbGXYEOIZYUXfUS01qxTTWFLRiq
         wgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QjMM7TzDwENpfLcRG8tZi/AAD20SHkYme2eBgBpgSkQ=;
        b=AqpJL61K6WQfY2e8G2vHnH6LcYMXnbh4PMur6XzlW4sziM/V85JASpuaJvvLs8Tdav
         6+D9zpdzrqYzTLyyK+tZnYnHL2H6uEdMtlM/bGYA8J5W/feiHhDG6xGEP+AqNsjvb6pz
         QIXmQu+rG3wvKSlZStR20IdKvCr8TP/FnpGO5cJwmKNokSgt3iyZxkFrl390imi39+bx
         O2H7Zp4oIe+dvFv99bw3BOaZp9JH8u9Zn1SmqyHtOlots21M0jIK8MwjTfd8nTN/HJaM
         AU/zJnt3KPEwZ+P4Y4QVr03/ERbruDCAImPdKd44gIA2hLP4MZNhO+e9wW2q2wMwvZSK
         qnTw==
X-Gm-Message-State: APjAAAXiEc3ZXFB1D00QzQ7MM8y1CCz/wuR7dR6AaRpY9CYx46EObfzf
        UUNMESOpx0Rn0h9f0mMNliJanOBm
X-Google-Smtp-Source: APXvYqxrVf71mtgFqSXmPBc/9wVOaSQwHpltLmKnyMoGFUyBOeoCLeP0jbEjIyESu8wp03oyhMvrZw==
X-Received: by 2002:a02:3b10:: with SMTP id c16mr11730202jaa.39.1573226975842;
        Fri, 08 Nov 2019 07:29:35 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:5957:ca04:7584:ed9f])
        by smtp.googlemail.com with ESMTPSA id q3sm813767ill.0.2019.11.08.07.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 07:29:34 -0800 (PST)
Subject: Re: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting and
 dumping
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        William Tu <u9012063@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
 <20191106.211459.329583246222911896.davem@davemloft.net>
 <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com>
 <c89c4f99-d37f-17c8-07e6-ee04351c8c36@gmail.com>
 <CADvbK_dDVJs23x9Y-x3TNBRhoU6pQ5xH51B_nn0SuSws+C5QRA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6fbb1c89-8123-e179-ad8c-b4368b2e3cd0@gmail.com>
Date:   Fri, 8 Nov 2019 08:29:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CADvbK_dDVJs23x9Y-x3TNBRhoU6pQ5xH51B_nn0SuSws+C5QRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/19 7:08 AM, Xin Long wrote:
> On Fri, Nov 8, 2019 at 12:18 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 11/7/19 3:50 AM, Xin Long wrote:
>>> Now think about it again, nla_parse_nested() should always be used on
>>> new options, should I post a fix for it? since no code to access this
>>> from userspace yet.
>>
>> please do. All new options should use strict parsing from the beginning.
>> And you should be able to set LWTUNNEL_IP_OPT_GENEVE_UNSPEC to
>> .strict_start_type = LWTUNNEL_IP_OPT_GENEVE_UNSPEC + 1 in the policy so
>> that new command using new option on an old kernel throws an error.
> I'm not sure if strict_start_type is needed when using nla_parse_nested().
> 
> .strict_start_type seems only checked in validate_nla():
> 
>         if (strict_start_type && type >= strict_start_type)
>                 validate |= NL_VALIDATE_STRICT; <------ [1]
> 
> But in the path of:
>   nla_parse_nested() ->
>     __nla_parse() ->
>       __nla_validate_parse() ->
>         validate_nla()
> 
> The param 'validate' is always NL_VALIDATE_STRICT, no matter Code [1] is
> triggered or not. or am I missing something here?
> 

ok, I missed that.
