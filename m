Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D3AEE3FF
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfKDPip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:38:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:58286 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfKDPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 10:38:44 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iReRG-0006Q7-AS; Mon, 04 Nov 2019 16:38:42 +0100
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iReRG-000NQX-1D; Mon, 04 Nov 2019 16:38:42 +0100
Subject: Re: [PATCH v2 bpf-next 0/5] Bitfield and size relocations support in
 libbpf
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, yhs@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191101222810.1246166-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <00cbe8c6-20ee-1f9e-02cd-20974dfbf898@iogearbox.net>
Date:   Mon, 4 Nov 2019 16:38:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191101222810.1246166-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25623/Mon Nov  4 10:57:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 11:28 PM, Andrii Nakryiko wrote:
> This patch set adds support for reading bitfields in a relocatable manner
> through a set of relocations emitted by Clang, corresponding libbpf support
> for those relocations, as well as abstracting details into
> BPF_CORE_READ_BITFIELD/BPF_CORE_READ_BITFIELD_PROBED macro.
> 
> We also add support for capturing relocatable field size, so that BPF program
> code can adjust its logic to actual amount of data it needs to operate on,
> even if it changes between kernels. New convenience macro is added to
> bpf_core_read.h (bpf_core_field_size(), in the same family of macro as
> bpf_core_read() and bpf_core_field_exists()). Corresponding set of selftests
> are added to excercise this logic and validate correctness in a variety of
> scenarios.
> 
> Some of the overly strict logic of matching fields is relaxed to support wider
> variety of scenarios. See patch #1 for that.
> 
> Patch #1 removes few overly strict test cases.
> Patch #2 adds support for bitfield-related relocations.
> Patch #3 adds some further adjustments to support generic field size
> relocations and introduces bpf_core_field_size() macro.
> Patch #4 tests bitfield reading.
> Patch #5 tests field size relocations.
> 
> v1->v2:
> - added direct memory read-based macro and tests for bitfield reads.

Applied, thanks!
