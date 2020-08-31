Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2062574F1
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 10:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgHaIHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 04:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgHaIHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 04:07:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4FDC061573;
        Mon, 31 Aug 2020 01:07:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w13so4960424wrk.5;
        Mon, 31 Aug 2020 01:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kj7OGziR3MgIah9Mcm+KkptCh/JY3xwVQZr8wUniyVM=;
        b=p9VzVxLsWY+zFrqOBhD8usiIwGyeYSin57HeGT7R6Xf8R91XweDGVUBZ6VKfH3GmBn
         KxHKBQEi8JYTnSniF1P95yk4suvegVJ3RLh5l4j/brsOY+o+iWgjJ8Nm48/l/8hrYDcy
         4ATHbKHUCDSmBK3O9wBA/N/U57cAMhat4YOuWe2VgeELCGhm5BVqu/2uOo8jZwcbe+W3
         AFapjovrOT1GYeZKF8zuYBhEJxFfTHNwP4mDcdiwsPSVqefWu3eNYiEKt/xNH8a32/+i
         Cu9uYFJAuSEJXLExTW+U4TEOJK8Ec5giI5d7PWFeQR9wyyb88PfPZFPBN8Xl+l5gR9Aw
         C7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kj7OGziR3MgIah9Mcm+KkptCh/JY3xwVQZr8wUniyVM=;
        b=itozRpctWtKClQAmvChgwknf0uWV8wapqkr3weAy0sZV+RVdS3jJhL26ME17kXMUSo
         IpoikaLncwGo2/7ooaMsRjQat59Oup7S3zPd1ci3+RXwZO1Anws7g/LXM90L2OPDdDLi
         2IeJgeEdlA4SwyoOpxcmyFgJueicp/TlnICy1A8dFgq7hoL/K6lYLC37jzjdq0YdNm8u
         j/91ez3BgjmubC4T54sNkh+aYken453fUAlPkjh/I6qewba/VQXJ+DLOtDqwvAD7tVKn
         6Owrxe4m3WLncJ+0i0PckSYXgj0Qg3EXGTl+XInfnJiL9KS/zbpSanatwaE94F6H/OEV
         MOEA==
X-Gm-Message-State: AOAM5325KnZCDBmrGG2wqAxGUBu2YiyY7zpbU045mjpXmJGyPwsMvVMZ
        Kr2F0QIHsAWhi/ogwm5yiX45DEdJ26M=
X-Google-Smtp-Source: ABdhPJzPjGh0MYKkT+308s50rP4IFYltMNUoUmJAMlK+uKkiT8cgBV5yT/IwFBTBrbaI9hP+3C1rvQ==
X-Received: by 2002:adf:9ed4:: with SMTP id b20mr492462wrf.206.1598861240600;
        Mon, 31 Aug 2020 01:07:20 -0700 (PDT)
Received: from [192.168.8.147] ([37.164.5.65])
        by smtp.gmail.com with ESMTPSA id k22sm8675238wrd.29.2020.08.31.01.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 01:07:20 -0700 (PDT)
Subject: Re: [PATCH v3] net: Use standardized (IANA) local port range
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Bart Groeneveld <avi@bartavi.nl>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
References: <20200828203959.32010-1-avi@bartavi.nl>
 <20200828204447.32838-1-avi@bartavi.nl> <20200828145203.65395ad8@hermes.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bf42f6fd-cd06-02d6-d7b6-233a0602c437@gmail.com>
Date:   Mon, 31 Aug 2020 10:07:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200828145203.65395ad8@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/28/20 2:52 PM, Stephen Hemminger wrote:
> On Fri, 28 Aug 2020 22:44:47 +0200
> Bart Groeneveld <avi@bartavi.nl> wrote:
> 
>> IANA specifies User ports as 1024-49151,
>> and Private ports (local/ephemeral/dynamic/w/e) as 49152-65535 [1].
>>
>> This means Linux uses 32768-49151 'illegally'.
>> This is not just a matter of following specifications:
>> IANA actually assigns numbers in this range [1].
>>
>> I understand that Linux uses 61000-65535 for masquarading/NAT [2],
>> so I left the high value at 60999.
>> This means the high value still does not follow the specification,
>> but it also doesn't conflict with it.
>>
>> This change will effectively halve the available ephemeral ports,
>> increasing the risk of port exhaustion. But:
>> a) I don't think that warrants ignoring standards.
>> 	Consider for example setting up a (corporate) firewall blocking
>> 	all unknown external services.
>> 	It will only allow outgoing trafiic at port 80,443 and 49152-65535.
>> 	A Linux computer behind such a firewall will not be able to connect
>> 	to *any* external service *half of the time*.
>> 	Of course, the firewall can be adjusted to also allow 32768-49151,
>> 	but that allows computers to use some services against the policy.
>> b) It is only an issue with more than 11848 *outgoing* connections.
>> 	I think that is a niche case (I know, citation needed, but still).
>> 	If someone finds themselves in such a niche case,
>> 	they can still modify ip_local_port_range.
>>
>> This patch keeps the low and high value at different parity,
>> as to optimize port assignment [3].
>>
>> [1]: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.txt
>> [2]: https://marc.info/?l=linux-kernel&m=117900026927289
>> [3]: See for example commit 1580ab63fc9a03593072cc5656167a75c4f1d173 ("tcp/dccp: better use of ephemeral ports in connect()")
>>
>> Signed-off-by: Bart Groeneveld <avi@bartavi.nl>
> 
> Changing the default range impacts existing users. Since Linux has been doing
> this for so long, I don't think just because a standards body decided to reserve
> some space is sufficient justification to do this.
> 

Agreed.

There is a sysctl, allowing admins/distros to opt-in to whatever IANA values of the days
if they really want.

We have already many issues caused by ephemeral range being too small.

For instance I often have to debug issues caused by some distros
changing sysctl_tcp_rfc1337 to 1, hurting some real applications.

