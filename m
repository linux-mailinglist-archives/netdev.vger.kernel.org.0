Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383CF50CC5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfFXNyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:54:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:44296 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfFXNyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:54:41 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfPQX-0008Hw-Ia; Mon, 24 Jun 2019 15:54:33 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfPQX-0009Lp-Am; Mon, 24 Jun 2019 15:54:33 +0200
Subject: Re: [PATCH bpf] bpf: fix NULL deref in
 btf_type_is_resolve_source_only
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        syzbot <syzkaller@googlegroups.com>
References: <20190619190105.261533-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1a45e1c2-a9b9-e53c-d723-5aaacfe1cf80@iogearbox.net>
Date:   Mon, 24 Jun 2019 15:54:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190619190105.261533-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/19/2019 09:01 PM, Stanislav Fomichev wrote:
> Commit 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
> added invocations of btf_type_is_resolve_source_only before
> btf_type_nosize_or_null which checks for the NULL pointer.
> Swap the order of btf_type_nosize_or_null and
> btf_type_is_resolve_source_only to make sure the do the NULL pointer
> check first.
> 
> Fixes: 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
