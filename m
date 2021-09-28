Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FAF41B93A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbhI1V0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:26:20 -0400
Received: from novek.ru ([213.148.174.62]:33346 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242846AbhI1V0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:26:19 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1455F503C31;
        Wed, 29 Sep 2021 00:21:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1455F503C31
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1632864064; bh=dMDBA38/uSXkbxTsH/bk7zHUowoegagawy/x+WXzhDI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=S4KOd7zhhRoVWuK9SFxV5Doqcdkl1IQNqAGuM5nVznKr+6OKHwhJ9BdDoJgSeHmNU
         1BKvsj23z7lNdr/MhiYGPmXnyEp6fnkm4OWWZMAqKPjtsS43Y6EW2hN+2emut14JSC
         KuUJm259NlPxMD6zvEX2VeDmPF4V6a46q1AorKG4=
Subject: Re: [PATCH] net/tls: support SM4 CCM algorithm
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <1761d06d-0958-7872-04de-cde6ddf8a948@novek.ru>
Date:   Tue, 28 Sep 2021 22:24:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.09.2021 07:28, Tianjia Zhang wrote:
> The IV of CCM mode has special requirements, this patch supports CCM
> mode of SM4 algorithm.
>
Have you tried to connect this implementation to application with
user-space implementation of CCM mode? I wonder just because I have an
issue with AES-CCM Kernel TLS implementation when it's connected to
OpenSSL-driven server, but still have no time to fix it correctly.

