Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5416F233C67
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgGaAGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:06:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:45854 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730797AbgGaAGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:06:13 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IYt-000762-Eg; Fri, 31 Jul 2020 02:06:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IYs-0003Di-DC; Fri, 31 Jul 2020 02:06:11 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: Omit nodad flag when adding
 addresses to loopback
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200730125325.1869363-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e1efa741-9e23-bbe0-a47f-c7286c5853a4@iogearbox.net>
Date:   Fri, 31 Jul 2020 02:06:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200730125325.1869363-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25889/Thu Jul 30 17:03:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 2:53 PM, Jakub Sitnicki wrote:
> Setting IFA_F_NODAD flag for IPv6 addresses to add to loopback is
> unnecessary. Duplicate Address Detection does not happen on loopback
> device.
> 
> Also, passing 'nodad' flag to 'ip address' breaks libbpf CI, which runs in
> an environment with BusyBox implementation of 'ip' command, that doesn't
> understand this flag.
> 
> Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied, thanks!
