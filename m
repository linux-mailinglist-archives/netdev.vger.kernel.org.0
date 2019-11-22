Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715B21076A1
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKVRm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:42:58 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42848 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:42:58 -0500
Received: by mail-qt1-f193.google.com with SMTP id t20so8682929qtn.9;
        Fri, 22 Nov 2019 09:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ybsh6lA/totIrcvKNkQWZ+T47ePdkscz7AS6y4pe85s=;
        b=mWxI9D5fZ/17rrgB0HePIvWz9iCmkqc00py0RS7Bz0eg/XdGTqXfEE9f5y2zbe/8On
         sYdFDR/u3N+PiTwTZvedJf/iTOYaaCs5Y2MPCGOlRtr/BuS69qGW35wUbcG9Zplm3itK
         2/yzwDgO0b/fzaK064rE3jjbMIG9L6W0dUY9cpmx7KsnJky3BhsZjRiIXoIrJdbXbXZ2
         05pEOwnymCoxfRoetOrEx1qe0J4ygmSMqbcros2UoxAwf2K0KUXOikrCyO3SjTUXFSS/
         mbZiDZbObT6Zre290ShbshcFtJqeoYiIKN+4cH2ZSbCiMYLLuVdZnfCxQFfRNxtxSZKF
         DMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ybsh6lA/totIrcvKNkQWZ+T47ePdkscz7AS6y4pe85s=;
        b=ozCApYY6h9M8zJtm3HSAtm0WS5aLH3eznsqafJVZ5d2SLGOXnh7IkXQvcY/jXLkSlc
         7AAHqsrEQglGkTdioDAgJhwzBBHz4Pw64zsWUKSjKxYFQPc26xH4CRktk2ptPZXPT0bZ
         tXYwh3wv35sYDiSUYiKe/TduUKVq1iTfpkAp1+niO0cCW2PmdBhi2vhODsvByk7XbZen
         MulUmnUMYdPgeo3tzI2SJF0CffuUBbLZruNRu+UIyth+GfNJ+AQ27Q81tkTabdG8lZcA
         yP3RDeshKKxa402gbYoUWBt051VyWbonyWnzPMhC6+owNl2kVMdyeK2OWmFvXacSG2J5
         s8Ng==
X-Gm-Message-State: APjAAAULOufPWY7MO0Ie5mK8qxsvbD5fu6owA/vVl90WsXbFqTNxYsSS
        5MkZXAQ1Wj0xUba2m/4Kp9wcDWev
X-Google-Smtp-Source: APXvYqz4qMPOgtek6f+F8t5bFjPX1CezIz77S5m5CqgJVKHc+m5q1jM38sbHWlufdQP12FddfUm7cw==
X-Received: by 2002:ac8:151:: with SMTP id f17mr15205761qtg.92.1574444577098;
        Fri, 22 Nov 2019 09:42:57 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b0cf:5043:5811:efe3])
        by smtp.googlemail.com with ESMTPSA id x30sm3941085qtc.7.2019.11.22.09.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 09:42:55 -0800 (PST)
Subject: Re: error loading xdp program on virtio nic
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
 <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
 <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
 <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
 <20191121072625.3573368f@carbon>
 <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com>
 <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com>
 <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com>
 <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
 <20191122175749.47728e42@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1fc9364a-ab96-e085-1fc5-9ed29f43f815@gmail.com>
Date:   Fri, 22 Nov 2019 10:42:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191122175749.47728e42@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 9:57 AM, Jesper Dangaard Brouer wrote:
> Implementation wise, I would not add flags to xdp_buff / xdp_md.
> Instead I propose in[1] slide 46, that the verifier should detect the
> XDP features used by a BPF-prog.  If you XDP prog doesn't use e.g.
> XDP_TX, then you should be allowed to run it on a virtio_net device
> with less queue configured, right?

Thanks for the reference and yes, that is the goal: allow XDP in the
most use cases possible. e.g., Why limit XDP_DROP which requires no
resources because XDP_TX does not work?

I agree a flag in the api is an ugly way to allow it. For the verifier
approach, you mean add an internal flag (e.g., bitmask of return codes)
that the program uses and the NIC driver can check at attach time?
