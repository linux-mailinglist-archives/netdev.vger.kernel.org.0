Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C0E151FD4
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBDRqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:46:52 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:33302 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbgBDRqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:46:51 -0500
Received: by mail-wr1-f48.google.com with SMTP id u6so10920184wrt.0
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 09:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PViOF49b8qn6ahEHi/SP9r5V6sh5UEmUDNaREM4YCcQ=;
        b=EMGUhIk+XjYOFFJ3c9Yw3ZqrdR9DZ0pwnH3NWzXLRrAB1X9+yUtTC0xYli0RVOF9gH
         fJJymtOT/mru9YC5at4CF4sfyHeKhH/YwKp3e5LIAxYoyBDzgr07fDgtxFFNlsOtGo8i
         gDTm+xUVbltGFTGL/Fsr1govVdyfisDPy4OX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PViOF49b8qn6ahEHi/SP9r5V6sh5UEmUDNaREM4YCcQ=;
        b=TdjkVP5PloaRukll30WB0Q7+xJTO4fjC6FOJxjF66e08tYgq64fLqdU+vTXcRsxG7T
         Qd+rlwxnC6aBsX/0kki+j+Rc1UKCNPZwT+NG6cJf06tKOK5Iu3XJdriNgyjOV5gN9wMl
         J9WqwRcatum9p1GJpU+dsOC7KDzNAWzerD0m+8dtkQgPlUsGPSij7TNgA1jQyUGRxcLB
         x+1odE5SSybNIgn94Uwps88Fwea0uQcCj9A6feaNRg2OsM5wkT2cIbRXFKYXNaqbLfrL
         eKQ/3kdC7K8qxJIPcd0DWJ0Mlwbnc/7+qNu4KsCM1rH/t7F/+Op5JtZC1d1Xrs+dogxg
         pzig==
X-Gm-Message-State: APjAAAXLT+WmdK9VdhJW4yLhGZz738gootCuN/9eosCLM1YRjt1wJ9or
        FS3mcHai60MemiWuLf37+jrksg==
X-Google-Smtp-Source: APXvYqz/5K1UcEofQ7ReFArUC3/pSsCxsk1ESNnijG4XViMGDX+qWejI4E6tiwr2otz0ieBIzUMe4g==
X-Received: by 2002:a5d:65cf:: with SMTP id e15mr22722363wrw.126.1580838409275;
        Tue, 04 Feb 2020 09:46:49 -0800 (PST)
Received: from rj-aorus.ric.broadcom.com ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id z8sm30866368wrq.22.2020.02.04.09.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 09:46:48 -0800 (PST)
Subject: Re: RFC: Use of devlink/health report for non-Ethernet devices
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>
References: <f8e67e40-71d4-f03c-6bc0-6496663af895@broadcom.com>
 <20200204064854.GK2260@nanopsycho>
From:   Ray Jui <ray.jui@broadcom.com>
Message-ID: <e16de31a-791b-ed27-43a1-5d0e214b0631@broadcom.com>
Date:   Tue, 4 Feb 2020 09:46:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200204064854.GK2260@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On 2020-02-03 10:48 p.m., Jiri Pirko wrote:
> Tue, Feb 04, 2020 at 12:01:37AM CET, ray.jui@broadcom.com wrote:
>> Hi Jiri/Eran/David,
>>
>> I've been investigating the health report feature of devlink, and have a
>> couple related questions as follows:
>>
>> 1. Based on my investigation, it seems that devlink health report mechanism
>> provides the hook for a device driver to report errors, dump debug
>> information, trigger object dump, initiate self-recovery, and etc. The
>> current users of health report are all Ethernet based drivers. However, it
>> does not seem the health report framework prohibits the use from any
>> non-Ethernet based device drivers. Is my understanding correct?
> 
> The whole devlink framework is designed to be independent on
> ethernet/networking.
> 
> 

Great. This is what I thought it is. Thanks for confirming.

>>
>> 2. Following my first question, in this case, do you think it makes any sense
>> to use devlink health report as a generic error reporting and recovery
>> mechanism, for other devices, e.g., NVMe and Virt I/O?
> 
> Sure.
> 
> 

Thanks.

>>
>> 3. In the Ethernet device driver based use case, if one has a "smart NIC"
>> type of platform, i.e., running Linux on the embedded processor of the NIC,
>> it seems to make a lot of sense to also use devlink health report to deal
>> with other non-Ethernet specific errors, originated from the embedded Linux
>> (or any other OSes). The front-end driver that registers various health
>> reporters will still be an Ethernet based device driver, running on the host
>> server system. Does this make sense to you?
> 
> Should not be ethetnet based driver. You should create the devlink
> instance in a driver for the particular device you want to report
> the health for.
> 
> 

Okay thanks!

>>
>> Thanks in advance for your feedback!
>>
>> Thanks,
>>
>> Ray
>>
>>
