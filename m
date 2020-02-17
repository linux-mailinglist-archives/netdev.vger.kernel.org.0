Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205FA160B30
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 07:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgBQGzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 01:55:24 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44935 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgBQGzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 01:55:24 -0500
Received: by mail-pg1-f194.google.com with SMTP id g3so8407702pgs.11
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 22:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=wIKi9nIJAcuX9JfUpVTXM/ZwYyn5AS6hsQ8mzRxDGCQ=;
        b=F85BmC+MOfP/eDqhQSaWaCkMStzyUCXtaWNjM/noWur8KKQblNsYGzCWaUN8kOVgOT
         JzP0byqmNj8SEDKG2AW3olv3ZE2yqs0SqCOEhpoW3vGgyRua0H9oOlj20khVjflDgJg0
         4DMaOhidsRLRgTatctkS5DgWze87fgX81PrENEkMemzOR75shSh/5m2hnZlumHKS87+V
         Mb10hzDp9rHBB46VyDCwzVF4+m1X0MFZSYYlFwROO266T+QSz6zvsoT3YHln6x6rWqPJ
         zFn7sqIVQgRviT57g5NLXjUEoa5Kgzte/FpIWC2Oml+Tvq6JmXuU22l+pvnLkajb1eao
         Ki3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wIKi9nIJAcuX9JfUpVTXM/ZwYyn5AS6hsQ8mzRxDGCQ=;
        b=gA5MjM+uOv7tlMIavRvQNxKW1ZAHj5NV3n0S9vhLoNg/wSsCj0ngYf0ppZ/uDyLJye
         615rDwlqBN7AUkdIZa8ExW+Lu4GscG+FRmloWYjoErnlOlNqh91de4hzlUSMWveJfVr/
         kG0FQIcxdZ8OgZVV3btrWNAdy+DIubKb+kfWvswxnFc59dt2LFw026dim9HZ68v3APu5
         nk5XqPI7/6mzL4socv9Kb03QPfJAiXxmxDMp8AaPtgtlqDOHmfHU/u/SBaJnqVWkJUCc
         L73IIiuwjPfKTlPsFdqLuBl0zOWGVVgFkWD4YJP9ip2LaRM57mSfa1q+Wez57rpWcLop
         lSgg==
X-Gm-Message-State: APjAAAVYhlvq74a9+5i2ClpzYw/NpuTWOpEkp1RbCGFBGxoRoXDoLYZV
        jPQfngfKrKj+J8NX6eaRHg9wQIjx75R1gg==
X-Google-Smtp-Source: APXvYqxDVEYRF5lyX7cPNhy4AaFINWKLBlAxOjbw44YuM91EiaQuNbx/cfv+inXLHNzrWSafFnuR1A==
X-Received: by 2002:a63:df0a:: with SMTP id u10mr16830577pgg.282.1581922523535;
        Sun, 16 Feb 2020 22:55:23 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m128sm15370998pfm.183.2020.02.16.22.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 22:55:23 -0800 (PST)
Subject: Re: [PATCH net-next 0/9] ionic: Add support for Event Queues
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200216231158.5678-1-snelson@pensando.io>
 <20200216.201124.1598095840697181424.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4386aa68-d8c5-d619-4d38-cb3f4d441f56@pensando.io>
Date:   Sun, 16 Feb 2020 22:55:22 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200216.201124.1598095840697181424.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/20 8:11 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Sun, 16 Feb 2020 15:11:49 -0800
>
>> This patchset adds a new EventQueue feature that can be used
>> for multiplexing the interrupts if we find that we can't get
>> enough from the system to support our configuration.  We can
>> create a small number of EQs that use interrupts, and have
>> the TxRx queue pairs subscribe to event messages that come
>> through the EQs, selecting an EQ with (TxIndex % numEqs).
> How is a user going to be able to figure out how to direct
> traffic to specific cpus using multiqueue settings if you're
> going to have the mapping go through this custom muxing
> afterwards?

When using the EQ feature, the TxRx are assigned to the EventQueues in a 
straight round-robin, so the layout is predictable.  I suppose we could 
have a way to print out the TxRx -> EQ -> Irq mappings, but I'm not sure 
where we would put such a thing.

sln

