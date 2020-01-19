Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C58141EF9
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 17:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgASQFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 11:05:48 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34778 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASQFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 11:05:48 -0500
Received: by mail-qt1-f196.google.com with SMTP id 5so25813261qtz.1
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 08:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Eb+Os0Kf+WyHa4B/mcosDTImjo0WKSXl99zSUu1UpU=;
        b=VUs/kwWdGbl2T0PTVmvBZbIrDd5ioD2A5luldHuCizfn3GPqyfbusrBwrOM2Jlu3sw
         //uCub9hBcS5/+q4CK6vkTBZqaF8PM5QUiBSUhTgLBTQTbdtwlg90K3+q7fkGviDj1Ro
         v3CtsHh4ghJDmdHUiaRigPtT4Hw+ZVT+S/CsCgLd3jHM9WqwBz6C4f9GPUHZKoGXOhX7
         iOnquSTtGLqUKLekoZInW7cMEaxfDad/pkJYYKZbGxcmGUMORnXN0Jgkxoyfk63zAjJd
         sc7GJeVta+X3HmsYpW37fKRgd/ac7qeZPP6lIuDFdcZ3xubAU0UUzHLh4KX3a1TmBjcy
         nh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Eb+Os0Kf+WyHa4B/mcosDTImjo0WKSXl99zSUu1UpU=;
        b=qD8D43FJIgYqmg5iY9br+rTZwryhHccIxbpuISdEGzj6kYmM61wyV+H6mVPf8UtAWB
         EJHUQotwr+G8qUAPUBm+8adyma1XgfxjKWr4xd3Ziq3MLATBVFWnmffP+SUcCx8cceoH
         yFj8qtV07/97I5sfJwfVaZKkhObAxniptPc3JFGURqD9ssjefMEdYJtfVf0/aUhLCt5Q
         90Wfn6k/89XTmA+pHGD7u+gGJZ6kgF2yR2RTHzC+EppPmuFEYIgmSVmxwj7uVJJm7cxv
         OJYYY2JaTatW+xItxgvJCjJZYo/rMoLZ7Bb3edO+oV11di4bqAlNjOOt2DMQKiw3oDq2
         BCMw==
X-Gm-Message-State: APjAAAV6HY1WVUZgyAoeJYSZCQZeYafq/b25wxCmFAg0VyRY/+UXbZN1
        5G2DeHoc9UEE3Vp6TpHD1iI=
X-Google-Smtp-Source: APXvYqxKiw4GeYnbJUBJhq6z6+p+LYehTPxiJIsxKHemkiVg9zP1aJf130+rCUfDMd1WotL2c7XGkw==
X-Received: by 2002:ac8:2a06:: with SMTP id k6mr16857705qtk.145.1579449947406;
        Sun, 19 Jan 2020 08:05:47 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2dab:9c0b:8f93:c8be? ([2601:282:803:7700:2dab:9c0b:8f93:c8be])
        by smtp.googlemail.com with ESMTPSA id s33sm16601311qtb.52.2020.01.19.08.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 08:05:46 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] ip: xfrm: add espintcp encapsulation
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
 <b7f74a02-ff87-1cd5-c3cb-7b620bd11fe2@gmail.com>
 <20200119154401.GA194807@bistromath.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <263b8a2b-6d46-546d-1195-7c76ec88534e@gmail.com>
Date:   Sun, 19 Jan 2020 09:05:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119154401.GA194807@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/20 8:44 AM, Sabrina Dubroca wrote:
> 2020-01-19, 08:31:32 -0700, David Ahern wrote:
>> On 1/19/20 3:32 AM, Sabrina Dubroca wrote:
>>> diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
>>> new file mode 100644
>>> index 000000000000..2d1f561b89d2
>>> --- /dev/null
>>> +++ b/include/uapi/linux/udp.h
>>> @@ -0,0 +1,47 @@
>>> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
>>> +/*
>>> + * INET		An implementation of the TCP/IP protocol suite for the LINUX
>>> + *		operating system.  INET is implemented using the  BSD Socket
>>> + *		interface as the means of communication with the user level.
>>> + *
>>> + *		Definitions for the UDP protocol.
>>> + *
>>> + * Version:	@(#)udp.h	1.0.2	04/28/93
>>> + *
>>> + * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
>>> + *
>>> + *		This program is free software; you can redistribute it and/or
>>> + *		modify it under the terms of the GNU General Public License
>>> + *		as published by the Free Software Foundation; either version
>>> + *		2 of the License, or (at your option) any later version.
>>> + */
>>> +#ifndef _UDP_H
>>> +#define _UDP_H
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +struct udphdr {
>>> +	__be16	source;
>>> +	__be16	dest;
>>> +	__be16	len;
>>> +	__sum16	check;
>>> +};
>>> +
>>> +/* UDP socket options */
>>> +#define UDP_CORK	1	/* Never send partially complete segments */
>>> +#define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
>>> +#define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
>>> +#define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
>>> +#define UDP_SEGMENT	103	/* Set GSO segmentation size */
>>> +#define UDP_GRO		104	/* This socket can receive UDP GRO packets */
>>> +
>>> +/* UDP encapsulation types */
>>> +#define UDP_ENCAP_ESPINUDP_NON_IKE	1 /* draft-ietf-ipsec-nat-t-ike-00/01 */
>>> +#define UDP_ENCAP_ESPINUDP	2 /* draft-ietf-ipsec-udp-encaps-06 */
>>> +#define UDP_ENCAP_L2TPINUDP	3 /* rfc2661 */
>>> +#define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
>>> +#define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
>>> +#define UDP_ENCAP_RXRPC		6
>>> +#define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
>>> +
>>> +#endif /* _UDP_H */
>>
>> Hi Sabrina:
>>
>> I am confused about this header file. It is not from the kernel's uapi
>> directory, so the kernel does not care about the values and where did
>> you get the file?
> 
> Uh? It's right there:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git/tree/include/uapi/linux/udp.h
> 

ah, but not in Dave's net-next which is what I use to sync iproute2 uapi
headers. I will hold onto this patch until ipsec-next merges into net-next.
