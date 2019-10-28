Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8585E6FD2
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 11:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388290AbfJ1Ko7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 06:44:59 -0400
Received: from mail.jv-coder.de ([5.9.79.73]:51714 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732891AbfJ1Ko7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 06:44:59 -0400
Received: from [10.61.40.7] (unknown [37.156.92.209])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 6CA929F7D6;
        Mon, 28 Oct 2019 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1572259497; bh=5JNSbrJraKNtfEOW/Y/SSiZAnTUWwvSO739g19EqHLQ=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=Ec7dBlyCzGP12sig57kfDZVbZaQc+hH3Brr14ZLMNFik/U84R+hBUB6coWb4EfKok
         BvAnSV75+LKGPNfmrw3Y3waHtBek/STlB0ncvPqDxdxlXj/BjABFjn7W8U+6IHXiBv
         NFDCNzM8SU8SkXjb1Q7+H6gvigrup8JB7qYm/qX8=
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tom Rix <trix@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
 <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
 <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <5b45c8f6-1aa2-2e1e-9019-a140988bba80@jv-coder.de>
Date:   Mon, 28 Oct 2019 11:44:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,HELO_MISC_IP,RCVD_IN_DNSWL_BLOCKED,
        RDNS_NONE autolearn=no autolearn_force=no version=3.4.2
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.jv-coder.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 25.10.2019 um 12:22 schrieb Sebastian Andrzej Siewior:
> On 2019-10-25 12:14:59 [+0200], Joerg Vehlow wrote:
>> Here is one of the oops logs I still have:
>>
>> [  139.717273] CPU: 2 PID: 11987 Comm: netstress Not tainted
>> 4.19.59-rt24-preemt-rt #1
> could you retry with the latest v5.2-RT, please? qemu should boot fine…
>
> Sebastian
I was unable to reproduce it with 5.2.21-rt13. Do you know if something
changed in network scheduling code or could it be just less likely?
