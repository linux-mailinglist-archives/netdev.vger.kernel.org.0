Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8024659B7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 00:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353788AbhLAXWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 18:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353743AbhLAXW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 18:22:26 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8E6C061748;
        Wed,  1 Dec 2021 15:19:02 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c4so55684488wrd.9;
        Wed, 01 Dec 2021 15:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EzC0k6nBAvRvAw7gyjq7IDylMxnD4ESkb6qtGxCuVII=;
        b=b1NhGGLGDb6KYltl9BhRSXXD/t88zckVMdA+cG+MNyRXy31tAoBPePRstDUAmfAEis
         Swf0av6eSnIl0luetl8jSM5F7rZlcvVW+i+UjOFkC3NbAjiQ3yC5LpiSn/bfnBdLAyII
         jfAF5Czs/zP/y5704D2W6xJtvfPDVCw844UqAJ62C4YwRIzzfk91J0TseRwpWvqyHYjE
         mDUZpvN37o1NI6u9IBECwPRw0EedjVLj5lSNJgOYqI83xnIDYcaxSVApN4xOH443gTua
         HdQ4+h5RcOV4g5WsesDuI8wm+0JIEbN3pmcdY57bt4LPdjJUyafBBm2eUJ8s3rppphPe
         /fTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EzC0k6nBAvRvAw7gyjq7IDylMxnD4ESkb6qtGxCuVII=;
        b=wzfatWYlqvN7iAfYnnKkU+Z/NqytPOIWKTbQfB46yk19wlC7vNHeJJxZoS9gH+rop1
         lQ5kZ+NJvAkuinK59ZChjxllNPNjxRhZwseLrrLl9wNyjgYANYx1KT6tUsPioQOL/vEp
         b4jLhROTQ8X+Em5/65G+xzSPPmNNvpPiWxDuT8eGXR6idoHqWmkmtp7tl60FX5pUfBUT
         m+H+cQ5heiNt7yye2hANqr25iDnDXrC5IBNCg354oU5pxBvSLeUBpYGgvsJpCUCERV3m
         fHReaY42x3ekFSvDxr093VBKh3o4YkTMABg4hACL6m+nLk/uO222Z5DZaH1ndTU0ZnEO
         8SBQ==
X-Gm-Message-State: AOAM531N+ROIEHVrg+LOvfwyOnkO4KxCm5lFWHUB0pDwhtxq6o0p0Z0H
        m9HcG/sKYgVDzgfU0AWkNtA=
X-Google-Smtp-Source: ABdhPJzKFsgXCyPxwcXAFJPUaYkK9C1dCnD88t0s+vtUJcIQvcRMvd/w+qyE7NO9HgEtfKz3D2FSDw==
X-Received: by 2002:adf:eb05:: with SMTP id s5mr9669480wrn.448.1638400741025;
        Wed, 01 Dec 2021 15:19:01 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id m3sm956221wrv.95.2021.12.01.15.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 15:19:00 -0800 (PST)
Message-ID: <3e2caa38-27a1-986f-7187-b4e333105371@gmail.com>
Date:   Wed, 1 Dec 2021 23:18:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>, David Ahern <dsahern@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
 <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
 <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
 <66dc5bcb-633d-efe8-0ccc-dcb97d08769c@gmail.com>
 <20211201230757.fuhnhgtbx5o22wgs@kafai-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211201230757.fuhnhgtbx5o22wgs@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 23:07, Martin KaFai Lau wrote:
> On Wed, Dec 01, 2021 at 03:35:49PM -0700, David Ahern wrote:
>> On 12/1/21 2:51 PM, Martin KaFai Lau wrote:
>>>
>>> To tx out dummy, I did:
>>> #> ip a add 10.0.0.1/24 dev dummy0
>>                ^^^^^^^^
>>>
>>> #> ip -4 r
>>> 10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.1
>>>
>>> #> ./send-zc -4 -D 10.0.0.(2) -t 10 udp
>>                       ^^^^^^^^^^
>>
>> Pavel's commands have: 'send-zc -4 -D <dummy_ip_addr> -t 10 udp'
>>
>> I read dummy_ip_addr as the address assigned to dummy0; that's an
>> important detail. You are sending to an address on that network, not the
>> address assigned to the device, in which case packets are created and
>> then dropped by the dummy driver - nothing actually makes it to the server.
> Right, I assumed "dropped by dummy driver" is the usual intention
> for using dummy, so just in case if it was the intention for
> testing tx only.  You are right and it seems the intention
> of this command is to have server receiving the packets.

I see, it seems we found the misunderstanding:

For dummy device, I indeed was testing only tx part without
a server, in my understanding it better approximates an actual
fast NIC. I don't think dummy is even capable to pass the data,
so was thinking that it's given that there is no receive side,
and so no "msg_zerocopy -r".

For localhost testing (with the hack), there was a server
verifying data.


>>
>>> ip -s link show dev dummy0
>>> 2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 65535 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>>     link/ether 82:0f:e0:dc:f7:e6 brd ff:ff:ff:ff:ff:ff
>>>     RX:    bytes packets errors dropped  missed   mcast
>>>                0       0      0       0       0       0
>>>     TX:    bytes packets errors dropped carrier collsns
>>>     140800890299 2150397      0       0       0       0
>>>
>>

-- 
Pavel Begunkov
