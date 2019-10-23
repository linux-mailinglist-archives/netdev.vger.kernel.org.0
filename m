Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B871E1B3A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390962AbfJWMtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:49:33 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:34663 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390892AbfJWMtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 08:49:32 -0400
Received: by mail-il1-f196.google.com with SMTP id a13so4419953ilp.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 05:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h/KPAsx1ms/HlWrQ2kK0emHEnAforwCjQh7wYzYcuMI=;
        b=P4+pElk6eo2y/Tpz2v/gcafSgarrw29j4ARz6PVFHtOVMOvqWp0gbruHD1sOM+EMvn
         HpctW69Pc/0TgrE28/73a+77EXoFgWtxe5RQCTUVD7d0R5l9pZ0r5Ahh4z2YbxGkI2n+
         gNDGnL+0YdyBQKNUVFJluvZOs7Xucmi4tKwNFQUmEWBiiNk4E6yIaKjMAIbDLykbkzmw
         Orwj3QIHWrqBTFEz97olAMANINmMwUj+BP6JsOF9d0GKUasvgOi4Lq9DnwtpmaJWQ0sv
         ta98sGPpwGSn3W5yzL9oNh14pQHKpGhOb3QcjXdSLnHz38+8cST1q5gya3a6kCzhGlwd
         jYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/KPAsx1ms/HlWrQ2kK0emHEnAforwCjQh7wYzYcuMI=;
        b=IBtixW16B9c75BSpbM5pSYm6abYsWBuGAtwKdUv4J+BSuu8QbTSoAJguaWMJAdt29p
         xVdNrE3DgOEa2oIr8Px+tS0E073uQZ28PkBo2q7gd827I4F8v/wgiu4hOf1+sDjsU7nk
         85CG1y2Qt58r2nC2/kiPM9GBG5GZCrlsLfELDsG+vpchn4tRtaMXM9ItYMPbLA9J/ubm
         A7GQfaHXgyMqSRc5fB4EZ6EmJIny28/iqrGF4xrHO142qSnIKH4f+6ASPn+jeLzyXN/X
         zQ5n9tuKEBwo6dLH468ikOpunEEaLbi7H7VCiGZixpafXlU/mzVof1OlvJxBp6+JonzW
         b/AQ==
X-Gm-Message-State: APjAAAWVgjd0lxY1uBtNjdmNTisbOpxYCcVK7Te4Mv8Ip+fz3D9j16G1
        5qW4O1b9gmaxMyp88gANNA5xnQ==
X-Google-Smtp-Source: APXvYqwxdHOZbhD6PRxFI1JkJGP26b+HqtVpJ5HBK0s/S9wrzhI9F7+tt7ChyhwfqkNiRLoBz3BtXw==
X-Received: by 2002:a92:b308:: with SMTP id p8mr36515356ilh.182.1571834972058;
        Wed, 23 Oct 2019 05:49:32 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id g4sm7238494iof.56.2019.10.23.05.49.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 05:49:31 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        mleitner@redhat.com, dcaratti@redhat.com,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
Date:   Wed, 23 Oct 2019 08:49:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vlad,

On 2019-10-22 10:17 a.m., Vlad Buslov wrote:
> Currently, significant fraction of CPU time during TC filter allocation
> is spent in percpu allocator. Moreover, percpu allocator is protected
> with single global mutex which negates any potential to improve its
> performance by means of recent developments in TC filter update API that
> removed rtnl lock for some Qdiscs and classifiers. In order to
> significantly improve filter update rate and reduce memory usage we
> would like to allow users to skip percpu counters allocation for
> specific action if they don't expect high traffic rate hitting the
> action, which is a reasonable expectation for hardware-offloaded setup.
> In that case any potential gains to software fast-path performance
> gained by usage of percpu-allocated counters compared to regular integer
> counters protected by spinlock are not important, but amount of
> additional CPU and memory consumed by them is significant.

Great to see this becoming low hanging on the fruit tree
after your improvements.
Note: had a discussion a few years back with Eric D.(on Cc)
when i was trying to improve action dumping; what you are seeing
was very visible when doing a large batch creation of actions.
At the time i was thinking of amortizing the cost of that mutex
in a batch action create i.e you ask the per cpu allocator
to alloc a batch of the stats instead of singular.

I understand your use case being different since it is for h/w
offload. If you have time can you test with batching many actions
and seeing the before/after improvement?

Note: even for h/w offload it makes sense to first create the actions
then bind to filters (in my world thats what we end up doing).
If we can improve the first phase it is a win for both s/w and hw use
cases.

Question:
Given TCA_ACT_FLAGS_FAST_INIT is common to all actions would it make
sense to use Could you have used a TLV in the namespace of TCA_ACT_MAX
(outer TLV)? You will have to pass a param to ->init().

cheers,
jamal
