Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF836ED002
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 18:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKBRi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 13:38:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34389 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfKBRi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 13:38:29 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so14233324ion.1;
        Sat, 02 Nov 2019 10:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FM/ey+XtV99iTTOz0BvDqFhF3qzBZV1oTNEv0Wtewg8=;
        b=NJoc2udb8RE59zirpliZR4A7prmZPWtNGMLpROvtY+og8t1Iq7nMxGFLlz3jctHcCl
         eWyOYGI+UGgqsrWezG88pnDsmS2Wb9bb8fE0Y4csSazrs4/QyrZVNPdSTwzqr5ZTxYUR
         cdLMGsnwndKYA8n5bnYBXmkn7dVCQ5OoqnZS1yNoIlPnZhbX/xg1DXP0WdOa8QHob+CG
         OxDERkr/DB8LJWNyvtVfIOIdgWJmmeb8IVNGFNK0IfTC6lmi15FjiZb/cXZZjNquaDe0
         Kj1dBoHTokI6T4isx44VwZMW8EkmeWaVxanh2EFxhNTt8XmTdjJUytaZGAusbKSe8DkF
         QwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FM/ey+XtV99iTTOz0BvDqFhF3qzBZV1oTNEv0Wtewg8=;
        b=pszKznJvJW9JnnIacSy0ioD0wiWaLHo9nxUjumdG/iQdI8lH4EHBdcyKQEHXGr4XSw
         J9AVTriv9g9UajczWegF3D5mf1+L8m+qErRXtCFnh8nZrixhtPAz+1rAglBkYGe1Oxt6
         p5oNZJVT/2Z6KRchpsNhW05wPaaYNZcvn2ZVa/ejiZ+84RVB7RGVXLfFGxLKWFXvoLJ9
         C/mMKCwfBOeUtZuHCA5YsCgZi1uDcN2uH0OopSpxmxUdRvyvQoX3SgvCvDsaddYfDu02
         F8PAiDh1Xdj8nxXuQsbMMS5Gay8MlC2GJsXZ3pOVfBem5OD05rbku8ZBPiTr4m56UKnB
         co4Q==
X-Gm-Message-State: APjAAAWE+qSNEsDoaa1miNclOQuVjlp8D47eq+G9rPSxhoeVqyh4gwMS
        raYXAsuyUcRkuZ5lSiczPrTHf4l6
X-Google-Smtp-Source: APXvYqwkpO9Qc2ww+kDXyddMHg7uJw2ku9dsELbY7RgtjF4CmFug256EnF4EbcqNOhTg9cnTzgFouA==
X-Received: by 2002:a05:6602:2547:: with SMTP id j7mr7244883ioe.77.1572716308045;
        Sat, 02 Nov 2019 10:38:28 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d194:3543:ed5:37ec])
        by smtp.googlemail.com with ESMTPSA id v10sm1571839ila.81.2019.11.02.10.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 10:38:27 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] selftest: net: add icmp reply address test
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     David Miller <davem@davemloft.net>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
References: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com>
 <0a03def6-3ea0-090f-048f-877700836df2@gmail.com>
 <CA+HUmGgDrY9A7kz7268ycAOhExA3Y1h-QhBS6xwbWYxpUODDWw@mail.gmail.com>
 <690336d7-0478-e555-a49b-143091e6e818@gmail.com>
 <CA+HUmGgKakVpS8UsKWUwm9QdCf+T2Pi1wNS-Kr7NE+TQ8ABGaQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <06dd5c8e-7eeb-a00f-e437-11897fe01ad1@gmail.com>
Date:   Sat, 2 Nov 2019 11:38:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CA+HUmGgKakVpS8UsKWUwm9QdCf+T2Pi1wNS-Kr7NE+TQ8ABGaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/19 10:09 AM, Francesco Ruggeri wrote:
> On Sat, Nov 2, 2019 at 8:11 AM David Ahern <dsahern@gmail.com> wrote:
>> On 11/2/19 9:08 AM, Francesco Ruggeri wrote:
>>> I am only using macvlans for N1 in the ipv6 test, where there are 3 nodes.
>>> How do I use veths for that?
>>
>> checkout the connect_ns function. It uses veth to connect ns1 to ns2.
> 
> I apologize in advance  for being slow ...
> I have 3 namespaces that have to share the same LAN, I am not trying
> 1-1 connections among those namespaces.
> 

How would you cable this if it were an actual network with physical nodes?
- bridge on R1 (since it is the gw for H1), with connections to R2 and
H1 into the bridge
- second connection between R1 and R2
- connection between R2 and H2

For the simulation, network namespaces represent physical nodes, veth
pairs act like a cable between the nodes / namespaces and the bridge
makes the LAN.
