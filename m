Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2F89877
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfHLIL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:11:29 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:34028 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfHLIL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1565597484;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=RU3R2vspY7GTQ1mcMFwuYxxGqCDNqI+3qpXRunlvHZ4=;
        b=B62EmVF4UdL4HZwQAkHKT/mYf2+rB+hRb0hDVlNDKkg6RrdNJ7coJreVBOkx0agqG4
        nhbeH9vkhZD+25BZ4Myy4lAN0vfKhQ5kFfvQi/DFHTWYONpHB1aV2DovH9e2WBPNAoO1
        xR3Z22C7vYOlZ3h/MN6rfVFiOjWv9wOLRLBD4Ff5Yin2gtCSMi9j3f8x6eBZGzXpe8qE
        3YJsLGncf1jjzJuKH9Xd0yii3w1pvlqIY4pcxiKiQywZjIa/oJNB19yepAviwHMp30Q1
        MtVNGEvAXIvNYI3uAfVNlIOmgOLZRqFMRg2OUo1yf9bowt7R5SWGXKQblXDQsZKg9Z05
        oybA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGXsh5kU/E"
X-RZG-CLASS-ID: mo00
Received: from [192.168.40.177]
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id k05d3bv7C8BGX8A
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 12 Aug 2019 10:11:16 +0200 (CEST)
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
To:     maowenan <maowenan@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190802033643.84243-1-maowenan@huawei.com>
 <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
 <20190806135231.GJ1974@kadam>
 <6e1c5aa0-8ed3-eec3-a34d-867ea8f54e9d@hartkopp.net>
 <5018f6ca-53b5-c712-a012-a0fcda5c10c2@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <04055e63-c2c0-78e3-1b24-47be08976750@hartkopp.net>
Date:   Mon, 12 Aug 2019 10:11:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5018f6ca-53b5-c712-a012-a0fcda5c10c2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/08/2019 07.48, maowenan wrote:
> On 2019/8/7 0:41, Oliver Hartkopp wrote:

>> I compiled the code (the original version), but I do not get that "Should it be static?" warning:

> here are my steps for net/can/bcm.c,
> make allmodconfig ARCH=mips CROSS_COMPILE=mips-linux-gnu-
> make C=2 net/can/bcm.o ARCH=mips CROSS_COMPILE=mips-linux-gnu-

There were some sparse _errors_ in my setup that hide that "static" 
warning. I will use sparse by default now.

Many thanks,
Oliver

