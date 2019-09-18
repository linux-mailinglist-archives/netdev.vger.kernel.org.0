Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB7B6D30
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389494AbfIRUBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:01:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39621 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389487AbfIRUBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:01:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so466824pgi.6
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 13:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2cZKpMSiaOABnpshvoFa2tthoHcJeWejWF2Jem4urQ=;
        b=qtp+wE6fuFQn+C1DKlRr/1BfR+nv0cduIRzDWPZinreeap0AA5i8LmxE6h115hj/fN
         proTYY2zrP6hO11c2VW0XoMMputqdLbJdaahXYJcKnpS7NXrJSQWQ5yJ8iktaotg65ag
         NhLNknnubYsWuT0/3LR1i6zhM/6mqwUpySskuAbt6jZnTe1VrsGI6UDUyFiswvjAo1uz
         a4SoU70LLtlGDqeA4rr/OVeTuxahX6c00boJt9ymbEVxuVvHfVwZUZk8xIFl6JgG65f8
         F8ZYNjTKN9x+v+mxHVIcYplqMrGFJUo1rwwtF/TRnt/cu5fi8I3fp5xE3SDXgwPPRFaY
         5TXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2cZKpMSiaOABnpshvoFa2tthoHcJeWejWF2Jem4urQ=;
        b=kc1K7uMpssdM8m8oQ3/3kGM8PeOBAu71xPrj8vRbHcEirmRrR7WvuOX7cJ6Rt+R2RO
         +aEIYNfl9zN088TnuAli7A+3dcXz5MDNXEYnZmP6uX6UfGBSJkjC0+BXefi3L4UUOCYx
         3M6Iub6ILtw/kopRGlc+EPDqjZ+C1Eyx7sLyaZK2iRJx4z0XUj0qY9v6LkMIKtW9Xkao
         qzSbsbAosinIpNiHtA3UHEv9ltzPv2NNc31mcakAfpK5/4zlGjFjettR2e1cMfClJ8Ps
         5dr2FgBsbqBbGEZ5PHc3AQqJEaB4oIj6TwFKqYMa/rzDio8lq6qIXZHd9ZJ+JnTdDLrb
         xFCA==
X-Gm-Message-State: APjAAAUrMaNJZhYpEj8uk7p1KVCnacRkiM2gJYcZyiz2o1bWN157bYDu
        y8FJjsoWcsoSzHUopIBwnRk=
X-Google-Smtp-Source: APXvYqwoQzOa59Csy7GkhZTu19Ded1jjLPWyvs2SiKRYTD/+FtQ4PE9UaV6G/D03Gp3anIXh6O47oA==
X-Received: by 2002:a17:90a:9743:: with SMTP id i3mr80750pjw.9.1568836894470;
        Wed, 18 Sep 2019 13:01:34 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:5d8f:d810:4b26:617b])
        by smtp.googlemail.com with ESMTPSA id e15sm3156847pjt.3.2019.09.18.13.01.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 13:01:33 -0700 (PDT)
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, mlxsw@mellanox.com
References: <20190916094448.26072-1-jiri@resnulli.us>
 <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
 <20190917183629.GP2286@nanopsycho.orion>
 <12070e36-64e3-9a92-7dd5-0cbce87522db@gmail.com>
 <20190918073738.GA2543@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <13688c37-3f27-bdb4-973b-dd73031fa230@gmail.com>
Date:   Wed, 18 Sep 2019 14:01:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190918073738.GA2543@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 1:37 AM, Jiri Pirko wrote:
> Wed, Sep 18, 2019 at 01:46:13AM CEST, dsahern@gmail.com wrote:
>> On 9/17/19 12:36 PM, Jiri Pirko wrote:
>>> Tue, Sep 17, 2019 at 06:46:31PM CEST, dsahern@gmail.com wrote:
>>>> On 9/16/19 3:44 AM, Jiri Pirko wrote:
>>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>>
>>>>> Add indication about previous failed devlink reload.
>>>>>
>>>>> Example outputs:
>>>>>
>>>>> $ devlink dev
>>>>> netdevsim/netdevsim10: reload_failed true
>>>>
>>>> odd output to user. Why not just "reload failed"?
>>>
>>> Well it is common to have "name value". The extra space would seem
>>> confusing for the reader..
>>> Also it is common to have "_" instead of space for the output in cases
>>> like this.
>>>
>>
>> I am not understanding your point.
>>
>> "reload failed" is still a name/value pair. It is short and to the point
>> as to what it indicates. There is no need for the name in the uapi (ie.,
>> the name of the netlink attribute) to be dumped here.
> 
> Ah, got it. Well it is a bool value, that means it is "true" or "false".
> In json output, it is True of False. App processing json would have to
> handle this case in a special way.
> 

Technically it is a u8. But really I do not understand why it is
RELOAD_FAILED and not RELOAD_STATUS which is more generic and re-usable.
e.g,. 'none', 'failed', 'success'.
