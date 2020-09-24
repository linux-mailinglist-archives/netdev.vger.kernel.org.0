Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E2C277660
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIXQQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXQQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:16:01 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486BDC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:16:01 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u126so4164241oif.13
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=C9u6AVLkqOFw73EMzUDZyYOidQQUHkHBFceSwPdimdI=;
        b=FlXzOXoOYHJ7A2ImcOMzz1iOxF8Zezcr2uMk76a15HSJq+Mxh8+9GoAqc/megd4XX2
         Thv2J+Wz1f9NpA1291X+nf9JIj6r/denf0OD6am1kVLBmlPXtfN7rzqHPspxBX+eDyY9
         HaHsAfr1tclXn0VoaHbtnquJR0V17ecGbLAYo9FnOrgjYPInnZAjvLHI6WGQh/CgZkji
         YCcQSvfvZG4EeYcn89PD/JmAuV0LQpmW6AuNCyVwAkw7YoCKx9v0qHQChasPZEGzx272
         f1Z9zyipm0cQlebBgWuWwfdXpv/FhOzmQgyti0f6yOA/QAEzqyDSIFqSALAwNoXr/Po4
         AeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9u6AVLkqOFw73EMzUDZyYOidQQUHkHBFceSwPdimdI=;
        b=MMS6aw5MUycmnqHZ/4zPUcAK5U7NkEzAwPLJUOrK/0CFoIZ76A2EDhZeyofoOirgDX
         QnYiR57I0ENMjlg0Xw/OF1RUnW9JqeulowO7+vVoUySW6gvrSSecEuy0lE9MC6fWWazl
         9eukydHI7dFe5yMdGH+pAUwWk3K1F3IsTwo1kHzfWSFH3ipX9nQd5974eXanXTu2aIau
         pF4DNfN2jc7O2canGU3XBfvrm3F8iXgPFNbLDOMyM19AuI841UOeVMMtRR0w2sFhVnsI
         aUBJXVhwnRUhDqLMQsquvHfk5mLbMK87+DzdIC3zzh7BiKBMA+h7o2GF5iZW0eHS5Ekq
         UAMQ==
X-Gm-Message-State: AOAM530vpH4jwW6qiWxODD7y+KnRP50vlUo589biBJvAB6/ENLdZ6zS5
        fYzW1+zAmdJ33cWEHpsacV8pF6VGmohmCw==
X-Google-Smtp-Source: ABdhPJyhsU29mcj5tgdF92C2h639yXz9Mc+cQKSmBvl5p2oCs0MZ7+WIZv2M03NmhBnkxXCps3tYvw==
X-Received: by 2002:a05:6808:b19:: with SMTP id s25mr105500oij.146.1600964160547;
        Thu, 24 Sep 2020 09:16:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:5dae:5047:75c:a176])
        by smtp.googlemail.com with ESMTPSA id l15sm744780oil.24.2020.09.24.09.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 09:15:59 -0700 (PDT)
Subject: Re: RTNETLINK answers: Permission denied
To:     "Brian J. Murrell" <brian@interlinx.bc.ca>, netdev@vger.kernel.org
References: <fe60df0562f7822027f253527aef2187afdfe583.camel@interlinx.bc.ca>
 <a4b94cd7c1e3231ba8ea03e2e2b4a19c08033947.camel@interlinx.bc.ca>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5accdc00-3106-4670-d6f1-7118cae5ef9e@gmail.com>
Date:   Thu, 24 Sep 2020 10:15:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a4b94cd7c1e3231ba8ea03e2e2b4a19c08033947.camel@interlinx.bc.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 5:09 AM, Brian J. Murrell wrote:
> On Tue, 2020-09-22 at 15:04 -0400, Brian J. Murrell wrote:
>> What are the possible causes of:
>>
>> # ip route get 2001:4860:4860::8844
>> RTNETLINK answers: Permission denied
>>
>> when
>>
>> # ip route get fd31:aeb1:48df::99
>> fd31:aeb1:48df::99 from :: dev br-lan proto static src
>> fd31:aeb1:48df::1 metric 1024 pref medium
>>
>> works just fine?
>>
>> Using iproute2 5.0.0.
> 
> No-one with any thoughts on this?  Is there a better place I should be
> asking?
> 

check your routes for a prohibit entry:

$ sudo ip -6 ro add prohibit 2001:4860:4860::8844

$ ip -6 ro ls
::1 dev lo proto kernel metric 256 pref medium
prohibit 2001:4860:4860::8844 dev lo metric 1024 pref medium
...

$ ip -6 ro get 2001:4860:4860::8844
RTNETLINK answers: Permission denied

