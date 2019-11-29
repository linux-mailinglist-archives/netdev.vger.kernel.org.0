Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510BC10D02D
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 01:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfK2AZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 19:25:33 -0500
Received: from www62.your-server.de ([213.133.104.62]:48930 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfK2AZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 19:25:32 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iaU65-00004y-A8; Fri, 29 Nov 2019 01:25:21 +0100
Received: from [178.197.249.15] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iaU65-0003VS-21; Fri, 29 Nov 2019 01:25:21 +0100
Subject: Re: [PATCH bpf] bpf: Fix build in minimal configurations
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     rdunlap@infradead.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20191128043508.2346723-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <775e2e54-f2f8-18b6-444d-27699b7666ff@iogearbox.net>
Date:   Fri, 29 Nov 2019 01:25:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191128043508.2346723-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25647/Thu Nov 28 10:49:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/19 5:35 AM, Alexei Starovoitov wrote:
> Some kconfigs can have BPF enabled without a single valid program type.
> In such configurations the build will fail with:
> ./kernel/bpf/btf.c:3466:1: error: empty enum is invalid
> 
> Fix it by adding unused value to the enum.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
