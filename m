Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B38A2FAD4B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbhARWYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:24:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:45654 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388562AbhARWYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:24:46 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l1cwI-0009N5-UU; Mon, 18 Jan 2021 23:23:58 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l1cwI-000IuS-Ns; Mon, 18 Jan 2021 23:23:58 +0100
Subject: Re: [PATCH v12 bpf-next] bpf/selftests: fold
 test_current_pid_tgid_new_ns into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>, netdev@vger.kernel.org
Cc:     andriin@fb.com, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org, andrii.nakryiko@gmail.com
References: <20210114141033.GA17348@localhost>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a84db358-c291-db0b-2807-326e2a4669ec@iogearbox.net>
Date:   Mon, 18 Jan 2021 23:23:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210114141033.GA17348@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26053/Mon Jan 18 13:33:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 3:10 PM, Carlos Neira wrote:
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds test cases into test_progs.
> 
> Changes from v11:
> 
>   - Fixed test failure is not detected.
>   - Removed EXIT(3) call as it will stop test_progs execution.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

(Seems kernel patch-bot didn't sent a reply here, was applied few days ago, just fyi.)
