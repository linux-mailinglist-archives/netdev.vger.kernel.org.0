Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92399442B68
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhKBKNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 06:13:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:41558 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKBKNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 06:13:47 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhqkx-0002J9-Fg; Tue, 02 Nov 2021 11:11:03 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhqkx-0004qK-6K; Tue, 02 Nov 2021 11:11:03 +0100
Subject: Re: [PATCH bpf-next v3 2/4] libfs: support RENAME_EXCHANGE in
 simple_rename()
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>
References: <20211028094724.59043-1-lmb@cloudflare.com>
 <20211028094724.59043-3-lmb@cloudflare.com>
 <CAJfpegvPrQBnYO3XNcCHODBBCXm6uH73zOWXs+sfn=3LQmMyww@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7988de27-1718-60c1-ec03-9343d2cc460f@iogearbox.net>
Date:   Tue, 2 Nov 2021 11:11:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJfpegvPrQBnYO3XNcCHODBBCXm6uH73zOWXs+sfn=3LQmMyww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26341/Tue Nov  2 09:18:13 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/21 10:25 AM, Miklos Szeredi wrote:
> On Thu, 28 Oct 2021 at 11:48, Lorenz Bauer <lmb@cloudflare.com> wrote:
>>
>> Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
>> This affects binderfs, ramfs, hubetlbfs and bpffs.
> 
> Ramfs and hugetlbfs are generic enough; those seem safe.
> 
> Binderfs: I have no idea what this does; binderfs_rename() should
> probably error out on RENAME_EXCHANGE for now, or an explicit ack from
> the maintainers.

Thanks for the review, Miklos! Adding Christian to Cc wrt binderfs ... full context
for all patches: https://lore.kernel.org/bpf/20211028094724.59043-1-lmb@cloudflare.com/

> Bpffs is your baby...
> 
> Thanks,
> Miklos
> 

