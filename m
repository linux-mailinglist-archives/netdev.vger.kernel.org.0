Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F8342DC05
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhJNOvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhJNOvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:51:47 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88246C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:49:42 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id 77so5639326qkh.6
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YnKMh+lCIaaJ/tGF0K8dBVIkId79yhlhLUd6D68sUqo=;
        b=mL9vX5C7gvKLCi7cC0XlXsRRcGjVTQvjGU5CBS6lwHAjPEQxiB0PD9U0auv3WG/ph9
         1vIHXa/KWhPEGTfOXSD95ZhNVKxw48aauKrK7riPmCXVIsstkOiov03LCaK6m63qr+oU
         W5tKwIGgltCetFPzZAG44qP/RNUdXHzxAGmi3FPOVXayQvL/UaRPvT9wOQFLK6hz6kXa
         Fkh7SSHFJSp4uzUPvbI7QgSETx8RUbrM8Az/wMzsdzSyv4Uvkf7/X8VhYyNfbKm2waC9
         LfcmXw6kZAEcmGw35hoW7mI6HHp7PIT+4ddHGThN3S5QFaK5JVVGym63t5zSnUfezGZl
         Qc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YnKMh+lCIaaJ/tGF0K8dBVIkId79yhlhLUd6D68sUqo=;
        b=mlJuOUw0u7nFqZ7jZsrE5/lE7/5DE1vw01tlyzDgTWCMGhIIuwE3ouImZo5s/XNXhq
         zzNzttLJDjrP/oMXWLJL9JaMD0TYXNBh3tunUyx33M7wZzu9CIZO1yzCjovz8Sw2B1vd
         13SIKsxi5ubS6HNCZd+W8ULC+gNwGiZ1H5iPSpKG0hxjd5j2ibplZaLrdqvTK902bNcG
         CTUyKThPXl/pqQpYmQx3r/0NRn1iwqdIPCKHBmuOnMAljOD/SEOa7TUATEugTIWvHLiO
         YK/w4piFjNkZ3rPg9tLZyF3q85ixBtl79ymQfWsQIZnCCpLEm6pp/byf3guKqzW0pmtL
         NT/Q==
X-Gm-Message-State: AOAM530vqFDdPzhKNTo8e430MxHk5u5lg45a9uzlBloLQZg6LgNs2Z9x
        gKG+zo3EIUAFIbTdiZIpWb4oFOOBJ6A=
X-Google-Smtp-Source: ABdhPJyea6XFFBCnnT7fcWTejxc2Sk9pmNR6W4QhJG3lURlaRHh4V47l64AAuYQg9TetD1dVzxNHZw==
X-Received: by 2002:a05:620a:19a6:: with SMTP id bm38mr5382857qkb.26.1634222981720;
        Thu, 14 Oct 2021 07:49:41 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id n79sm1369250qke.97.2021.10.14.07.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:49:41 -0700 (PDT)
Message-ID: <37c44da6-8fb6-3e28-3c5d-d700a3f8f3ab@mojatatu.com>
Date:   Thu, 14 Oct 2021 10:49:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Anybody else getting unsubscribed from the list?
Content-Language: en-US
To:     Willy Tarreau <w@1wt.eu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
 <20211014143754.GA16946@1wt.eu>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211014143754.GA16946@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-14 10:37, Willy Tarreau wrote:
> Hi Jamal,
> 
> On Thu, Oct 14, 2021 at 10:18:12AM -0400, Jamal Hadi Salim wrote:
>> I was trying to catchup with the list and i noticed I
>> have stopped receiving emails since the 11th. I am leaning
>> towards my account being unsubscribed given i had to
>> resubscribe last time.
>>
>> Anyone else experiencing the same problem?
> 
> No (not yet at least), I received your message via the list. Maybe
> your domain or server has been bouncing for some time ? It used to
> happen to me many years ago and got unsubscribed from a few of the
> lists a few times due to long outages on my side.

I asked my colleagues and they have all been unsubscribed. So likely
a domain issue. We will resubscribe again.
Our domain runs off google, not sure what is going on there. This
has happened about 2 times in 3 months (and maybe once in 20 years
prior to that).

cheers,
jamal

