Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90226704A
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfGLNly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:41:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:56688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbfGLNly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:41:54 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvo8-0000tu-72; Fri, 12 Jul 2019 15:41:52 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvo8-000Txu-1I; Fri, 12 Jul 2019 15:41:52 +0200
Subject: Re: [PATCH] tools: bpftool: add raw_tracepoint_writable prog type to
 header
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190712013539.17407-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8b01dcec-9313-18f6-08f4-24275e90fcd6@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:41:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190712013539.17407-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 03:35 AM, Daniel T. Lee wrote:
> From commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints"),
> a new type of BPF_PROG, RAW_TRACEPOINT_WRITABLE has been added.
> 
> Since this BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE is not listed at
> bpftool's header, it causes a segfault when executing 'bpftool feature'.
> 
> This commit adds BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE entry to
> prog_type_name enum, and will eventually fixes the segfault issue.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Applied, thanks!
