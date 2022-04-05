Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A84B4F44D5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380789AbiDEUEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449068AbiDEPtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:49:22 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5081AC416
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:32:55 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-de3eda6b5dso14647923fac.0
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 07:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ivJYvZsvt7ky870kySOEvvcIgoIQIiZaS+YGUJaC3r4=;
        b=hXRnD80j8Etd5b5jkVA0uCWIhWdA9qtN4cS4aw/ynb2Yiwoe/PTHMDv3ZapGZH70d+
         cCSDL0MuCJPemXXifx9k/9+lZA2ASnneLbNZQm0kbfHIEEk9j7bN++vlVb6crrRw8CP6
         2lGRSplq5tS7s7jrXfw0YHUm0EX8XXTLsBXCWZts23o/y2MqzP4NMAjdRmpzLmQ4fah7
         ImIQajsAMR9xIuHY02LvCzW8JNjVllxtuBH7oWDjE9dotD1W8yLE4IP7JaQKFgCFnYav
         P1T8kPCKAD4H4bW6W6+xlOHCfrHoT1kGt9TssmrPK8EsIIWdZhJZMLSFTPwKtFoZXsA0
         g6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ivJYvZsvt7ky870kySOEvvcIgoIQIiZaS+YGUJaC3r4=;
        b=spOH/XklLaAhX3A7PmD8dft5ZFfgLhU7DJ2H9t4AHPtmTrarDekhip8J8Z3e1NMS21
         RpwMa1zarWdNABxZHsJwclU01G3jGe8gnzOAwVsYemHR+NKWw068ak2uhiDtLB0twbdq
         Rs3vuOL6U5YJ/2DtuYjulxghI8XDsW2mJ4NC3T4AYKXedxKI9tvisw3T4iNJPUGjEeHL
         BL3JhXCbaYgfh1vsoEsS82FBs/FcGvYBImnGkjGgPxnikqAVqEiThP6yj3u7Ckp8TdGN
         DzPqR9yJ8qGznwi+cfQm/Y1NHZx+1N6+kaa2jW9gtz4tdG71+XynWscLKAYht9VZHuW9
         39Fw==
X-Gm-Message-State: AOAM530FC/Xk9iBkfiNNhWvEDyhMXMjvEE1rlCkTvsOXINjEXNDFJ220
        wsOgKZZEgdsu35vtkSIXCRuUK9j55s4oiuUx
X-Google-Smtp-Source: ABdhPJw105QKvn8r6IcZ5QDIC0SfjldK74e89kyVg2dU7rseWAaIYJ8bSMIwZNSR+aTO4XIB/8dzwg==
X-Received: by 2002:a05:6870:a106:b0:de:de08:4e42 with SMTP id m6-20020a056870a10600b000dede084e42mr1651672oae.247.1649169174908;
        Tue, 05 Apr 2022 07:32:54 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:85c0:1655:e794:7870? ([2601:282:800:dc80:85c0:1655:e794:7870])
        by smtp.googlemail.com with ESMTPSA id g18-20020a9d6c52000000b005af7c7cb702sm5653645otq.34.2022.04.05.07.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:32:54 -0700 (PDT)
Message-ID: <f174108c-67c5-3bb6-d558-7e02de701ee2@gmail.com>
Date:   Tue, 5 Apr 2022 08:32:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: Matching unbound sockets for VRF
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Cc:     netdev@vger.kernel.org
References: <20220324171930.GA21272@EXT-6P2T573.localdomain>
 <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
 <YkBfQqz66FxYmGVV@ssuryadesk>
 <2bbfde7b-7b67-68fd-f62b-f9cd9b89d2ad@gmail.com>
 <20220404124104.GA18315@EXT-6P2T573.localdomain>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220404124104.GA18315@EXT-6P2T573.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/22 6:41 AM, Stephen Suryaputra wrote:
> On Sun, Apr 03, 2022 at 10:24:36AM -0600, David Ahern wrote:
>> On 3/27/22 6:57 AM, Stephen Suryaputra wrote:
>>>
>>> The reproducer script is attached.
>>>
>>
>> h0 has the mgmt vrf, the l3mdev settings yet is running the client in
>> *default* vrf. Add 'ip vrf exec mgmt' before the 'nc' and it works.
> 
> Yes. With "ip vrf exec mgmt" nc would work. We know that. See more
> below.
> 
>> Are you saying that before Mike and Robert's changes you could get a
>> client to run in default VRF and work over mgmt VRF? If so it required
>> some ugly routing tricks (the last fib rule you installed) and is a bug
>> relative to the VRF design.
> 
> Yes, before Mike and Robert's changes the client ran fine because of the
> last fib rule. We did that because some of our applications are:
> 1) Pre-dates "ip vrf exec"
> 2) LD_PRELOAD trick from the early days doesn't work
> 
> On the case (2) above, one concrete example is NFS mounting our images:
> applications and kernel modules. We had to run less than full-blown
> utilities and also the mount command uses glibc RPC functions
> (pmap_getmaps(), clntudp_create(), clnt_call(), etc, etc.). We analyzed
> it back then that because these functions are in glibc and call socket()
> from within glibc, the LD_PRELOAD doesn't work.
> 
> From the thread of Mike and Robert's changes, the conclusion is that the
> previous behavior is a bug but we have been relying on it for a while,
> since the early days of VRFs, and an upgrade that includes the changes
> caused some applications to not work anymore.
> 
> I'm asking if Mike and Robert's changes should be controlled by an
> option, e.g. sysctl, and be the default. But can be reverted back to the
> previous behavior.
> 

It has been 3-1/2 years since that patch. Rather than add more checks to
try to manage unintended app behavior, why not work on making your apps
consistent with the intent of the VRF design? If adding `ip vrf exec
VRF` before commands works, that is a very simple solution and the
reason for the command (handle code that is not VRF aware).

I'm guessing that option will not work for all cases (e.g., NFS which I
think Ben has asked about as well, cc'ed), but working towards making
the code align with VRF design is the longer term win.
