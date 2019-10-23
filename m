Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E40E264B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405917AbfJWWQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:16:31 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:37182 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405897AbfJWWQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 18:16:30 -0400
Received: by mail-pl1-f175.google.com with SMTP id u20so10795949plq.4
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 15:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+7t66STX4Hn1i8Vsy0ks1HuW3L4Ws+OIPc30fjxEav4=;
        b=qVebF51LYqsqDZcBu6kE4KHSEGjya94kCsSzGrl13tk0G1soQc/aa54929gT1QGIFw
         6Z7EalxkzqN9twMVE6Mlws5oad7lEG0BT8fT9wQlDW29AiEOlBtjjf76VqxvxTM+fpVJ
         4HK0oOPCD6nrjTMUFDxPr+zYofhe7diMh++PaA7+w4s3BX/mvPs3XHUJIk+EoyFaqFX7
         TuOIGarCzlr4h4FQjH3CNSpBaYy4YKA2e3oQMniiSNb+xS74dvzKnAI+yjGLyWfuHmmU
         NvlQiMoqQbV7wT9zLzM7IwHY2ya7n2lnvfluOk0JlSta5GSBuXjLU+qnr5kVL4bk2q32
         oq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+7t66STX4Hn1i8Vsy0ks1HuW3L4Ws+OIPc30fjxEav4=;
        b=A/KPJh24FTzjuFmuNkVUVK18VCZp3eCUF3ELfqqsq6zODv27znldEnwLfZqWIGj066
         7XeROBSTPUYl+4WW7x1hCKsjCQC74WgkxvoOiJr1z/0UvjOk+iFYAp4cky5yFDKSDIOV
         ZDtgWaDSTCQEEgo77AGVx8mH2zQ+L9RNRDsFEPPCB0atP6bsNs6QsA/HXgRlmzMVyfoL
         dLZk7nRcQ7wuep0v+vhzHe+3W6+ZDu3Xo/HWLeUG5PQOGCwG6KuSYr/Iaq906VFcUQdj
         JGk3nHx4EgRxi3Ui58fFsCyF8gJsiexPG9TlSMjMDni31Jpuzamffw2R+QfH0STWIbmX
         LWBA==
X-Gm-Message-State: APjAAAXE0DLH2nfhDR1KLy2FWTtfXh9QX7vF+h5x9sPhmRVpo43yvdne
        KoRp37PK5gpecSszhElNnWY=
X-Google-Smtp-Source: APXvYqzW+q9Qv1taD4elO4alFppjWJ3DMPISIYRBkQd/RqtMWYge2HFz/d3pG/GBgFHYOMwZsMWbDQ==
X-Received: by 2002:a17:902:aa46:: with SMTP id c6mr12472240plr.197.1571868989898;
        Wed, 23 Oct 2019 15:16:29 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:1ced:5275:cdfd:ff77])
        by smtp.googlemail.com with ESMTPSA id 184sm11228354pfu.58.2019.10.23.15.16.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 15:16:28 -0700 (PDT)
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
 <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
 <20191021155630.GY2185@nanopsycho>
 <0f165d72-bb54-f1cb-aaf7-c8a20d15ee49@gmail.com>
 <20191022055945.GZ2185@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f1facd1c-00e4-e276-3898-b59e9d7281a2@gmail.com>
Date:   Wed, 23 Oct 2019 16:16:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022055945.GZ2185@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 11:59 PM, Jiri Pirko wrote:
> Mon, Oct 21, 2019 at 06:11:33PM CEST, dsahern@gmail.com wrote:
>> On 10/21/19 9:56 AM, Jiri Pirko wrote:
>>>
>>> I forgot to update the desc. Uppercase chars are now allowed as Andrew
>>> requested. Regarding dash, it could be allowed of course. But why isn't
>>> "_" enough. I mean, I think it would be good to maintain allowed chars
>>> within a limit.
>>
>> That's a personal style question. Is "fib-rules" less readable than
>> "fib_rules"? Why put such limitations in place if there is no
>> justifiable reason?
> 
> You mean any limitation?
> 

I mean why are you pushing a patch to limit what characters can be used
in names, and why are you deciding '-' is not ok but '_' is?

It just seems so random and not driven by some real limitation (e.g.,
entries in a filesystem).
