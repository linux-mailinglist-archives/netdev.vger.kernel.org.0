Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C34D4120390
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLPLR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:17:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:43420 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfLPLR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 06:17:59 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igoNr-0007sX-Mu; Mon, 16 Dec 2019 12:17:51 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1igoNr-0003C6-BK; Mon, 16 Dec 2019 12:17:51 +0100
Subject: Re: [PATCH] bpf: Replace BUG_ON when fp_old is NULL
To:     Yonghong Song <yhs@fb.com>, Aditya Pakki <pakki001@umn.edu>
Cc:     "kjlu@umn.edu" <kjlu@umn.edu>, Alexei Starovoitov <ast@kernel.org>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191215154432.22399-1-pakki001@umn.edu>
 <98c13b9c-a73a-6203-4ea1-6b1180d87d97@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <566f206c-f133-6f68-c257-2c0b3ec462fa@iogearbox.net>
Date:   Mon, 16 Dec 2019 12:17:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <98c13b9c-a73a-6203-4ea1-6b1180d87d97@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/19 11:08 PM, Yonghong Song wrote:
> On 12/15/19 7:44 AM, Aditya Pakki wrote:
>> If fp_old is NULL in bpf_prog_realloc, the program does an assertion
>> and crashes. However, we can continue execution by returning NULL to
>> the upper callers. The patch fixes this issue.
> 
> Could you share how to reproduce the assertion and crash? I would
> like to understand the problem first before making changes in the code.
> Thanks!

Fully agree, Aditya, please elaborate if you have seen a crash!
