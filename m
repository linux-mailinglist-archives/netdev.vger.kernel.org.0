Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8B62327E8
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgG2XMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:12:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:56496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgG2XMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:12:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0vFP-0007K5-P6; Thu, 30 Jul 2020 01:12:31 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0vFP-000MzR-If; Thu, 30 Jul 2020 01:12:31 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: don't destroy failed link
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        YiFei Zhu <zhuyifei@google.com>
References: <20200729045056.3363921-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c0562bf8-aad2-3b60-3eb6-eac2bc549c83@iogearbox.net>
Date:   Thu, 30 Jul 2020 01:12:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200729045056.3363921-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25888/Wed Jul 29 16:57:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 6:50 AM, Andrii Nakryiko wrote:
> Check that link is NULL or proper pointer before invoking bpf_link__destroy().
> Not doing this causes crash in test_progs, when cg_storage_multi selftest
> fails.
> 
> Cc: YiFei Zhu <zhuyifei@google.com>
> Fixes: 3573f384014f ("selftests/bpf: Test CGROUP_STORAGE behavior on shared egress + ingress")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
