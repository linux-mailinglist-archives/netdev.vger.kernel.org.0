Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9871512BF
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgBCXLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:11:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:40768 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgBCXLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 18:11:09 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iykrq-0002ai-NS; Tue, 04 Feb 2020 00:10:58 +0100
Received: from [178.197.249.21] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iykrq-000VTV-Dy; Tue, 04 Feb 2020 00:10:58 +0100
Subject: Re: [PATCH bpf] bpf: Fix modifier skipping logic
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20200201000314.261392-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <87124426-f61e-2ebe-30c4-0d4a89a1a3e4@iogearbox.net>
Date:   Tue, 4 Feb 2020 00:10:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200201000314.261392-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25715/Mon Feb  3 12:37:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/20 1:03 AM, Alexei Starovoitov wrote:
> Fix the way modifiers are skipped while walking pointers. Otherwise second
> level dereferences of 'const struct foo *' will be rejected by the verifier.
> 
> Fixes: 9e15db66136a ("bpf: Implement accurate raw_tp context access via BTF")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
