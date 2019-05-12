Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C991AE67
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 01:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfELXY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 19:24:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:59594 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbfELXYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 19:24:25 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPxpQ-00040D-3z; Mon, 13 May 2019 01:24:24 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPxpP-0000CF-V5; Mon, 13 May 2019 01:24:23 +0200
Subject: Re: [PATCH bpf 0/4] bpf: fix documentation for BPF helper functions
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>
References: <20190510145125.8416-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <65560150-6d56-69de-054f-d8c0d32d1298@iogearbox.net>
Date:   Mon, 13 May 2019 01:24:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190510145125.8416-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25447/Sun May 12 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2019 04:51 PM, Quentin Monnet wrote:
> Another round of fixes for the doc in the BPF UAPI header, which can be
> turned into a manual page. First patch is the most important, as it fixes
> parsing for the bpf_strtoul() helper doc. Following patches are formatting
> fixes (nitpicks, mostly). The last one updates the copy of the header,
> located under tools/.
> 
> Quentin Monnet (4):
>   bpf: fix script for generating man page on BPF helpers
>   bpf: fix recurring typo in documentation for BPF helpers
>   bpf: fix minor issues in documentation for BPF helpers.
>   tools: bpf: synchronise BPF UAPI header with tools
> 
>  include/uapi/linux/bpf.h       | 145 +++++++++++++++++++++--------------------
>  scripts/bpf_helpers_doc.py     |   8 +--
>  tools/include/uapi/linux/bpf.h | 145 +++++++++++++++++++++--------------------
>  3 files changed, 154 insertions(+), 144 deletions(-)
> 

Applied, thanks.
