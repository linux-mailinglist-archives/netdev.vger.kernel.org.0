Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0945510C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 00:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241557AbhKQXXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 18:23:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:56086 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241580AbhKQXXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 18:23:24 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnUE0-000FpW-QH; Thu, 18 Nov 2021 00:20:20 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnUE0-000Lm6-IW; Thu, 18 Nov 2021 00:20:20 +0100
Subject: Re: linux-next: manual merge of the bpf-next tree with the jc_docs
 tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Dave Tucker <dave@dtucker.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
References: <20211118101339.6ec37e14@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <69ce8d2b-8ae8-29aa-96c9-f2c0356dbea5@iogearbox.net>
Date:   Thu, 18 Nov 2021 00:20:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211118101339.6ec37e14@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26356/Wed Nov 17 10:26:25 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 12:13 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the bpf-next tree got a conflict in:
> 
>    Documentation/bpf/index.rst
> 
> between commit:
> 
>    1c1c3c7d08d8 ("libbpf: update index.rst reference")
> 
> from the jc_docs tree and commit:
> 
>    5931d9a3d052 ("bpf, docs: Fix ordering of bpf documentation")
> 
> from the bpf-next tree.
> 
> I fixed it up (the latter removed the line updated by the former, so I
> just the latter) and can carry the fix as necessary.
Ack, sounds good. Dave's rework fixed it implicitly.
