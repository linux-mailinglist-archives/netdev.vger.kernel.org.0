Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C242446CC1
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfFNXT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:19:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:40528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfFNXT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:19:59 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvUD-00088p-JZ; Sat, 15 Jun 2019 01:19:57 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvUD-000UtC-En; Sat, 15 Jun 2019 01:19:57 +0200
Subject: Re: [PATCH bpf-next] samples/bpf: fix include path in Makefile
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20190614064318.16313-1-prashantbhole.linux@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <94d7d941-8fdb-58f9-f6ba-d7c539fc7984@iogearbox.net>
Date:   Sat, 15 Jun 2019 01:19:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190614064318.16313-1-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/14/2019 08:43 AM, Prashant Bhole wrote:
> Recent commit included libbpf.h in selftests/bpf/bpf_util.h.
> Since some samples use bpf_util.h and samples/bpf/Makefile doesn't
> have libbpf.h path included, build was failing. Let's add the path
> in samples/bpf/Makefile.
> 
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>

Applied, thanks!
