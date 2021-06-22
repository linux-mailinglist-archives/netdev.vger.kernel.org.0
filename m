Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236333B0840
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhFVPKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:10:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:57082 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhFVPKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:10:22 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvi0S-0005CC-QF; Tue, 22 Jun 2021 17:08:04 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvi0S-0005Uj-0q; Tue, 22 Jun 2021 17:08:04 +0200
Subject: Re: [PATCH bpf-next v3 1/2] libbpf: add request buffer type for
 netlink messages
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <20210619041454.417577-1-memxor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <79e12ff4-186f-605e-06bf-58c8701e0187@iogearbox.net>
Date:   Tue, 22 Jun 2021 17:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210619041454.417577-1-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26209/Tue Jun 22 13:07:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/21 6:14 AM, Kumar Kartikeya Dwivedi wrote:
> Coverity complains about OOB writes to nlmsghdr. There is no OOB as we
> write to the trailing buffer, but static analyzers and compilers may
> rightfully be confused as the nlmsghdr pointer has subobject provenance
> (and hence subobject bounds).
[...]

Both applied, thanks!
