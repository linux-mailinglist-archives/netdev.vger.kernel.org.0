Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB40930F7AD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhBDQY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:24:27 -0500
Received: from novek.ru ([213.148.174.62]:33414 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237948AbhBDQYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:24:01 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id AC724503356;
        Thu,  4 Feb 2021 19:23:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru AC724503356
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612455797; bh=c4l/CzC8NVQ0cjgORzonnScnqpL3uTeAibuJFfUyGB8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aPth4hE3u1ael4BFNefqW3J1QarRDqK5E11Tgga7uLmmNB1TmvtXw8VgfVhgcjWic
         jOpWdgNeW7vp5socEEtGIwQxXotnK/o1o1Oq5hOC/YTMY25hjvHlV1F3MuF7ud17xm
         3Hl+tUbNPcy+mX2hmACrbJ/W+PflZ92SHlrj+OZA=
Subject: Re: [net v2] selftests: txtimestamp: fix compilation issue
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>
References: <1612452064-20797-1-git-send-email-vfedorenko@novek.ru>
 <CAF=yD-Ksu5cwE9KK9Te4Cpz+57Aa19UHxtHpHoxQMBiB4d=zgw@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <f853954e-f935-e3e5-2e2d-8acaa1cd266f@novek.ru>
Date:   Thu, 4 Feb 2021 16:23:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-Ksu5cwE9KK9Te4Cpz+57Aa19UHxtHpHoxQMBiB4d=zgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.02.2021 15:50, Willem de Bruijn wrote:
> On Thu, Feb 4, 2021 at 10:21 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>
>> PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
>> test. It could be included instead of <netpacket/packet.h> otherwise
>> the error of redefinition arrives.
>>
>> Fixes: 8fe2f761cae9 (net-timestamp: expand documentation)
> 
> Needs quotes
> 
>    Fixes: 8fe2f761cae9 ("net-timestamp: expand documentation")
> 
> When resending, can you also revise "It could be included instead .. "
> to "Include instead .."
> 
> And mention in the commit the other warning fixed at the same time.
> Thanks for including that.
> 
>> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Ok, no problem. Thanks for reviewing!
