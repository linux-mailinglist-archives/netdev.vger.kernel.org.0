Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFEE353068
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 22:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhDBUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 16:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBUxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 16:53:55 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A6BC0613E6;
        Fri,  2 Apr 2021 13:53:53 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v4so5616879wrp.13;
        Fri, 02 Apr 2021 13:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ad8+4vvgRoJKzOknFf9IRYyd66+3erW31k5BSaoEf+c=;
        b=HidmHgb/sOyGVcW6jXrCNrf2v+UDiio7uzj5SRxhMvG4eSX99KUviTX2Ap+jVWBQ2m
         QzC2OIDsKtO1z+W0UA8TMXsm8/FoCe8hhbU5ygfurtvrOQiRD8Qkohrj+cOeqyz5Jfb0
         S1nZsipoKDD86piMqTa/J1kh/3qg0uxzzz55px4GI+yMEmPk5PM7SSed9ogHCOah8rGc
         qMNR3cHpfg8xnXbKY16fCbDy1Jjf4PSuAt2ADLtCZDSfGQUP+WBrt4PlP1ppfNs30OEQ
         OHL7jctzIfiwf3f/xPinjVEYrxkUAsyYnSDM18aUCwZMj7sDOq3T2jQEEGZ3yS0LlRE3
         YFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ad8+4vvgRoJKzOknFf9IRYyd66+3erW31k5BSaoEf+c=;
        b=Aie+PezEGUafvOcLntAaZzEjbO22U8jY0LbMFyboCKzOOSW0g+Otgj7PL1W0PeMJA8
         aicY8cAVMpivJrEcIOr+1SceX9xWvY6Ao/xZj36Yc8zqPtlc+RYvacBPCC9WB1TTjfbu
         lY+oN6jOB0RjDWUnEhu3NMk1XHErJXwMFPE/EXB9e4Uc9A6FyzcA4tYCgePRDRCHUm9o
         jvHQh2tQ/WoEGtylZYqCQljj80bjhFLd8dChowl+cKYftCVK14PraRII8vIhZHXltLe8
         3Fl+3rHzSbnCVhMbXL7Cj6e6B+Nb7GbOjjQQiG8ZqEoygWefR2CmDQnWV2hWdMmP5btj
         hacA==
X-Gm-Message-State: AOAM532WvbHVUrwNySE8MhnYaPXc0HnhyyuxdwzbI0eAG0lY32iQQUo0
        QepBWRVHlOohfS6Fw/aup81UzJ1Hhqk=
X-Google-Smtp-Source: ABdhPJwHo63N6QReuQKjsCqtKZ0sJst31jeXRGWCzZkl6Pv7kkREq/WwysS/uvQnmmsTQxvVKaCAig==
X-Received: by 2002:adf:fa11:: with SMTP id m17mr3596191wrr.287.1617396831566;
        Fri, 02 Apr 2021 13:53:51 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.24.151])
        by smtp.gmail.com with ESMTPSA id h9sm13277017wmb.35.2021.04.02.13.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 13:53:51 -0700 (PDT)
Subject: Re: [PATCH] net: initialize local variables in net/ipv6/mcast.c and
 net/ipv4/igmp.c
To:     Phillip Potter <phil@philpotter.co.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210402173617.895-1-phil@philpotter.co.uk>
 <d2334631-4b3a-48e5-5305-7320adc50909@gmail.com> <YGdeAK3BwWSnDwRX@equinox>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <37f4c845-e63b-87b8-29ec-b28d895326cd@gmail.com>
Date:   Fri, 2 Apr 2021 22:53:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YGdeAK3BwWSnDwRX@equinox>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/21 8:10 PM, Phillip Potter wrote:
> On Fri, Apr 02, 2021 at 07:49:44PM +0200, Eric Dumazet wrote:
>>
>>
>> On 4/2/21 7:36 PM, Phillip Potter wrote:
>>> Use memset to initialize two local buffers in net/ipv6/mcast.c,
>>> and another in net/ipv4/igmp.c. Fixes a KMSAN found uninit-value
>>> bug reported by syzbot at:
>>> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
>>
>>
>> According to this link, the bug no longer triggers.
>>
>> Please explain why you think it is still there.
>>
> 
> Dear Eric,
> 
> It definitely still triggers, tested it on the master branch of
> https://github.com/google/kmsan last night. The patch which fixes the
> crash on that page is the same patch I've sent in.

Please send the full report (stack trace)

Thanks.



