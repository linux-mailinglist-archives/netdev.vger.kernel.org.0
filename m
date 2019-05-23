Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE7F2847E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbfEWRGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:06:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41182 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730867AbfEWRGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:06:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so3575331pfq.8
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wn7xFxwzLuOiSwOq0q55UBVH+AV0BD//eghyk+vPhGA=;
        b=iIjcKMnvZQ3C1Z5DoSooYdTsO2iVNzgNgEC9EatJm4wYsAUf55VhXPx/m1QUgXG7zR
         ncjwvKZZQ+boCzFJRcUphYJyetWoFZoOTEB+2rPPorZ2VK2he7w3Gba76JlJ1XhzCpdb
         Qdmxu6vYJVl9BK4D654b/LqdE8SXq8oOK0xI5OZUfqu7XJZ4HiMn82wd70hG88TaYQQE
         fftW1iA3OkWBJzr2jLX569+ACMMPenDgaJpAcifXby0HK20TGZULqjCQd1q+VgPWNw+V
         xh1bUklmLTGFOrIVeKyTitUsWFnXDJnrMANEchF7FBN03+AjTa8QwHLgvX/wF0g13zSq
         uvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wn7xFxwzLuOiSwOq0q55UBVH+AV0BD//eghyk+vPhGA=;
        b=cNtRaXQPXYIhl2IGvrVDYgoQLMtCXnDlvM8T90SPWYMJSQhfg/CjMISQeoVNMRFrW8
         1emwVJwiF8y5aRiNfC4Y771JwfJsS0rlFtxXzOYXjxlBdXQl0+F/LXfDFsAhpPHjyiM5
         kk3eqmgrs79vIPivuY9/rhL5rC5l9S9AaanWQANjZ1lTSQ58bv+m2d/MWeOdJQPBRCdq
         SvqyViaH7EllOsTdO0zgk4KNW14bTIAV7kicov8lJLlBPXyf8aMg14V1RLNwvoh10xdX
         GSrTFMwsCbKkyVUi6syAavVO9XBfCk/ZxSu8aaUwQRRimilrFSRTu7ggZjGit+SpjcKq
         45Ug==
X-Gm-Message-State: APjAAAWJBdjT+V0a3/0XQWilwXsJwQaShqSMWQQHx/cH6Mg0axtRJLkh
        izVZP6/UWQtWitIVke/Akts=
X-Google-Smtp-Source: APXvYqxbPurx6wy6P06z76RdgPNrsPwGiZxZjqLP/tFMMHkaBbU1oRhFNuVyMl6w3ASa9zAxALmYaQ==
X-Received: by 2002:a63:224a:: with SMTP id t10mr60298598pgm.27.1558631197428;
        Thu, 23 May 2019 10:06:37 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id 11sm12555009pfu.155.2019.05.23.10.06.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 10:06:36 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests/net: SO_TXTIME with ETF and FQ
To:     Willem de Bruijn <willemb@google.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        jesus.sanchez-palencia@intel.com
References: <20190523164507.50208-1-willemb@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1c4e190f-5f9c-be8e-a560-9aef7f483bb4@gmail.com>
Date:   Thu, 23 May 2019 10:06:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523164507.50208-1-willemb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/19 9:45 AM, Willem de Bruijn wrote:
> The SO_TXTIME API enables packet tranmission with delayed delivery.
> This is currently supported by the ETF and FQ packet schedulers.
> 
> Evaluate the interface with both schedulers. Install the scheduler
> and send a variety of packets streams: without delay, with one
> delayed packet, with multiple ordered delays and with reordering.
> Verify that packets are released by the scheduler in expected order.
> 
> The ETF qdisc requires a timestamp in the future on every packet. It
> needs a delay on the qdisc else the packet is dropped on dequeue for
> having a delivery time in the past. The test value is experimentally
> derived. ETF requires clock_id CLOCK_TAI. It checks this base and
> drops for non-conformance.
> 
> The FQ qdisc expects clock_id CLOCK_MONOTONIC, the base used by TCP
> as of commit fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC").
> Within a flow there is an expecation of ordered delivery, as shown by
> delivery times of test 4. The FQ qdisc does not require all packets to
> have timestamps and does not drop for non-conformance.
> 
> The large (msec) delays are chosen to avoid flakiness.
> 
> 	Output:
> 
> 	SO_TXTIME ipv6 clock monolithic

s/monolithic/monotonic/

> 	payload:a delay:33 expected:0 (us)
> 
> 	SO_TXTIME ipv4 clock monolithic
> 	payload:a delay:44 expected:0 (us)
> 
> 	SO_TXTIME ipv6 clock monolithic
> 	payload:a delay:10049 expected:10000 (us)
> 
> 	SO_TXTIME ipv4 clock monolithic
> 	payload:a delay:10105 expected:10000 (us)


Thanks for the test Willem.

Acked-by: Eric Dumazet <edumazet@google.com>

