Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2551264E9BF
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 11:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiLPKtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 05:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLPKtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 05:49:06 -0500
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579472621;
        Fri, 16 Dec 2022 02:49:05 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id vv4so5264122ejc.2;
        Fri, 16 Dec 2022 02:49:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qkya9wd5Yr+9rmD7rFH/gX7qdmvbGNpb9infzuUbUvk=;
        b=XZdM43MyeOFjsuBdNXrdOVetiXG2MlWo1QL60de7Xj5zOEIeaB4QqKI67monDZnWZw
         XWKB0SiptoLbeO30vg0xQiCRuMxbDMUxxIOjo4fOGU0HmyU105l3Ui9M0rS+Q8LwzC8e
         CvmS0dxb/rwiuKiqVV1eqRvsd3RtM+U77Ad6Zi3OwP0XdyVu0z3BNdi0UBMvVSyVib/s
         rxnDOqVgHCZWvKSApQhw57xuEUoYidRYxi7wL8WjIgZg7lhfgbYMhQPXKb4IJjTas5kG
         xz83eDo7eF7/Sird6TQwQzO5IrY19sfqUFWtk0ioqY/jGQLXZIbjsjmodczQoEOBUPtX
         g+bg==
X-Gm-Message-State: ANoB5pndx45izBvqeCMFrxyl3/wZqlgafvEz/uPSf1uUJo5ifYHWKRuy
        szqDL83T1YXwnyepobKpzYw=
X-Google-Smtp-Source: AA0mqf7TB5Fp8bws+jch7V7DDsz4ZuDB96TdPE9JghokH5/XbzB402jA/Ecyj8wZJr6/MOyC13FAGQ==
X-Received: by 2002:a17:906:2345:b0:7ad:9455:d57d with SMTP id m5-20020a170906234500b007ad9455d57dmr26648346eja.74.1671187743739;
        Fri, 16 Dec 2022 02:49:03 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id d22-20020a056402401600b004585eba4baesm710522eda.80.2022.12.16.02.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 02:49:03 -0800 (PST)
Message-ID: <6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org>
Date:   Fri, 16 Dec 2022 11:49:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PULL] Networking for next-6.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        joannelkoong@gmail.com
References: <20221004052000.2645894-1-kuba@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221004052000.2645894-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 04. 10. 22, 7:20, Jakub Kicinski wrote:
> Joanne Koong (7):

>        net: Add a bhash2 table hashed by port and address

This makes regression tests of python-ephemeral-port-reserve to fail.

I'm not sure if the issue is in the commit or in the test.

This C reproducer used to fail with 6.0, now it succeeds:
#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/socket.h>

#include <arpa/inet.h>
#include <netinet/ip.h>

int main()
{
         int x;
         int s1 = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP);
         if (s1 < 0)
                 err(1, "sock1");
         x = 1;
         if (setsockopt(s1, SOL_SOCKET, SO_REUSEADDR, &x, sizeof(x)))
                 err(1, "setsockopt1");

         struct sockaddr_in in = {
                 .sin_family = AF_INET,
                 .sin_port = INADDR_ANY,
                 .sin_addr = { htonl(INADDR_LOOPBACK) },
         };
         if (bind(s1, (const struct sockaddr *)&in, sizeof(in)) < 0)
                 err(1, "bind1");

         if (listen(s1, 1) < 0)
                 err(1, "listen1");

         socklen_t inl = sizeof(in);
         if (getsockname(s1, (struct sockaddr *)&in, &inl) < 0)
                 err(1, "getsockname1");

         int s2 = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP);
         if (s1 < 0)
                 err(1, "sock2");

         if (connect(s2, (struct sockaddr *)&in, inl) < 0)
                 err(1, "conn2");

         struct sockaddr_in acc;
         inl = sizeof(acc);
         int fdX = accept(s1, (struct sockaddr *)&acc, &inl);
         if (fdX < 0)
                 err(1, "accept");

         close(fdX);
         close(s2);
         close(s1);

         int s3 = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP);
         if (s3 < 0)
                 err(1, "sock3");

         if (bind(s3, (struct sockaddr *)&in, sizeof(in)) < 0)
                 err(1, "bind3");

         close(s3);

         return 0;
}



thanks,
-- 
js
suse labs

