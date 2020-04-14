Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20DE1A8C48
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632954AbgDNURR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:17:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:54510 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2632798AbgDNUQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 16:16:20 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORVK-0002Ww-MB; Tue, 14 Apr 2020 21:45:54 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORVK-000AlG-9Q; Tue, 14 Apr 2020 21:45:54 +0200
Subject: Re: [PATCH-next] bpf: Verifier, remove unneeded conversion to bool
To:     Zou Wei <zou_wei@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1586779076-101346-1-git-send-email-zou_wei@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ab62b97e-844f-3493-e30d-9e57c625fa35@iogearbox.net>
Date:   Tue, 14 Apr 2020 21:45:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1586779076-101346-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/20 1:57 PM, Zou Wei wrote:
> This issue was detected by using the Coccinelle software:
> 
> kernel/bpf/verifier.c:1259:16-21: WARNING: conversion to bool not needed here
> 
> The conversion to bool is unneeded, remove it
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Applied, thanks!
