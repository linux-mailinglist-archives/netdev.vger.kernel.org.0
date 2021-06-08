Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D52E3A056B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 22:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhFHVA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:00:58 -0400
Received: from novek.ru ([213.148.174.62]:60402 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233988AbhFHVA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:00:57 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2021 17:00:56 EDT
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 0F43B50048B;
        Tue,  8 Jun 2021 23:49:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 0F43B50048B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1623185400; bh=gDD54G8wjksTjk2nvyCoV1yuxaYYJHATQuKZyY57tz4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LIxGfllljjWPr4Yp9zzKCDOQA3Tl3ueOR3vhYBFQIrGmJYgkg65j/HTZqrAOWq91V
         1ToFRtsXFlZ7uOvNlMaGKVRxzSh1H0HzpuOrofBbQAvGeWOGy+udaOCBYvFh3TGUNh
         5uoxb6VtiWGx4xxaFTaqx01Z8qlrZCczo74eYHmw=
Subject: Re: quic in-kernel implementation?
To:     Alexander Ahring Oder Aring <aahringo@redhat.com>,
        netdev@vger.kernel.org
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <6b4027c4-7c25-fa98-42bc-f5b3a55e1d5a@novek.ru>
Date:   Tue, 8 Jun 2021 21:51:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.06.2021 16:25, Alexander Ahring Oder Aring wrote:
> Hi,
> 
> as I notice there exists several quic user space implementations, is
> there any interest or process of doing an in-kernel implementation? I
> am asking because I would like to try out quic with an in-kernel
> application protocol like DLM. Besides DLM I've heard that the SMB
> community is also interested into such implementation.
> 
> - Alex
> 

Hi!
I'm working on test in-kernel implementation of quic. It's based on the
kernel-tls work and uses the same ULP approach to setup connection
configuration. It's mostly about offload crypto operations of short header
to kernel and use user-space implementation to deal with any other types
of packets. Hope to test it till the end of June with some help from
Jakub.
Vadim
