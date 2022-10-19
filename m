Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A39C604B04
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiJSPRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiJSPQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:16:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F6DB06;
        Wed, 19 Oct 2022 08:09:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g27so25710221edf.11;
        Wed, 19 Oct 2022 08:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FsK6D2EcEarsvcUmqw3tszIjhZoyFqfrl8GwrgBvxW0=;
        b=M8GlvtbyG4JohVHZeHH0E5EIn1v/UHCWXcf83Tdnxdu7SzSAFHPqhZRUQpeWgACN7W
         PQ2dCU1m3KTZoieLTfzwQIXoQHaIIuWnfS80ATkBM796ObX7L07fNiv88WTn2DbhXP/D
         twnZUmXPbLmXIV/NSjz+kHaU95+MUvYXTEtIMApABhx/SVt5R1qlaepQ3cfHTS4TAzmB
         Uai0OKTCN/CfWQ8BTOKpeQZ/cSwDMWE0E+E7VHXu1u/1kxA+0OBaj+k5bla+qpGgBc+b
         db8gGsQFPQ4CX7I7Gfnhs9Pgm45D29M5o6bSrlcKz91efQdyUSxyXapnrUPzhLr4cnRS
         le8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FsK6D2EcEarsvcUmqw3tszIjhZoyFqfrl8GwrgBvxW0=;
        b=H9mAeht5QTr9FLYIVYE8hL6DwiPmhBRiQ3JDNYvIyITsNFyH+N4j4Y6bK6TFvzfDt/
         xfksvzivaiTrZxRLsv4otWWUa3cpuViNembmO9cX97fiw/ddHUM6kAMznzHIn3T0Ar8I
         gJA7QpqpWJRl9Tv1PtEJFIS34flOD6K3M0Lwh/QGhhPRj2TONZUoNmNgq0wkWwpNo2rW
         zDxlAuAeuTsOanK4CLXaegkLrQHkYgxfZYykB0g43JurlId1m6BFXRkfJNQ2DFTwugCS
         9bYPsBbq1ouV58FzeIkQHE8mXHF8L/9LlE7guTKwpZaWvW1YLcmFRki8RhW1ONy+bmoa
         5vTg==
X-Gm-Message-State: ACrzQf1JmOqfBT48ExkK38XrGqCtbspKkYdtCswAcY7/ECDCRfWbbTCq
        unn5hZ6Eo/4KhHIBhmoU51Q1EagWq9M=
X-Google-Smtp-Source: AMsMyM4QeQXHGNpz0csIxioO6j1olYXj5owzzkOdQ4O2BFleAeAZZFEwSERIP9nY6oL5+eluroGOuA==
X-Received: by 2002:a05:6402:2d8:b0:458:c152:67bd with SMTP id b24-20020a05640202d800b00458c15267bdmr7941831edx.308.1666192072118;
        Wed, 19 Oct 2022 08:07:52 -0700 (PDT)
Received: from [192.168.8.100] (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id k10-20020a170906578a00b007306a4ecc9dsm9189924ejq.18.2022.10.19.08.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 08:07:51 -0700 (PDT)
Message-ID: <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
Date:   Wed, 19 Oct 2022 16:06:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_CQE_F_COPIED
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/22 09:43, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> On 10/14/22 12:06, Stefan Metzmacher wrote:
>>> Hi Pavel,
>>>
>>> In the tests I made I used this version of IORING_CQE_F_COPIED:
>>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=645d3b584c417a247d92d71baa6266a5f3d0d17d
>>> (also inlined at the end)
>>>
>>> Would that something we want for 6.1? (Should I post that with a useful commit message, after doing some more tests)
>>
>> I was thinking, can it be delivered separately but not in the same cqe?
>> The intention is to keep it off the IO path. For example, it can emit a
>> zc status CQE or maybe keep a "zc failed" counter inside the ring. Other
>> options? And we can add a separate callback for that, will make a couple
>> of things better.
>>
>> What do you think? Especially from the userspace usability perspective.
> 
> So far I can't think of any other way that would be useful yet,
> but that doesn't mean something else might exist...
> 
> IORING_CQE_F_COPIED is available per request and makes it possible
> to judge why the related SENDMSG_ZC was fast or not.
> It's also available in trace-cmd report.
> 
> Everything else would likely re-introduce similar complexity like we
> had with the notif slots.
> 
> Instead of a new IORING_CQE_F_COPIED flag we could also set
> cqe.res = SO_EE_CODE_ZEROCOPY_COPIED, but that isn't really different.
> 
> As I basically use the same logic that's used to generate SO_EE_CODE_ZEROCOPY_COPIED
> for the native MSG_ZEROCOPY, I don't see the problem with IORING_CQE_F_COPIED.
> Can you be more verbose why you're thinking about something different?

Because it feels like something that should be done roughly once and in
advance. Performance wise, I agree that a bunch of extra instructions in
the (io_uring) IO path won't make difference as the net overhead is
already high, but I still prefer to keep it thin. The complexity is a
good point though, if only we could piggy back it onto MSG_PROBE.
Ok, let's do IORING_CQE_F_COPIED and aim 6.2 + possibly backport.

First, there is no more ubuf_info::zerocopy, see for-next, but you can
grab space in io_kiocb, io_kiocb::iopoll_completed is a good candidate.
You would want to take one io_uring patch I'm going to send (will CC
you), with that you won't need to change anything in net/. And the last
bit, let's make the zc probing conditional under IORING_RECVSEND_* flag,
I'll make it zero overhead when not set later by replacing the callback.

-- 
Pavel Begunkov
