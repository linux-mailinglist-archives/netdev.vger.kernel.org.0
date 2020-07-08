Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994042193ED
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgGHW5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:57:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:33960 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGHW5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:57:44 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtJ0Y-0000NY-HT; Thu, 09 Jul 2020 00:57:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtJ0Y-000KiM-8i; Thu, 09 Jul 2020 00:57:42 +0200
Subject: Re: [PATCH bpf-next V3 0/2] BPF selftests test runner 'test_progs'
 use proper shell exit codes
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        vkabatov@redhat.com, jbenc@redhat.com, yhs@fb.com, kafai@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <159410590190.1093222.8436994742373578091.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c2f5f24f-1479-a84d-ab2a-27fa47f44d4a@iogearbox.net>
Date:   Thu, 9 Jul 2020 00:57:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159410590190.1093222.8436994742373578091.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25867/Wed Jul  8 15:50:39 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/20 9:12 AM, Jesper Dangaard Brouer wrote:
> This patchset makes it easier to use test_progs from shell scripts, by using
> proper shell exit codes. The process's exit status should be a number
> between 0 and 255 as defined in man exit(3) else it will be masked to comply.
> 
> Shell exit codes used by programs should be below 127. As 127 and above are
> used for indicating signals. E.g. 139 means 11=SIGSEGV $((139 & 127))=11.
> POSIX defines in man wait(3p) signal check if WIFSIGNALED(STATUS) and
> WTERMSIG(139)=11. (Hint: cmd 'kill -l' list signals and their numbers).
> 
> Using Segmentation fault as an example, as these have happened before with
> different tests (that are part of test_progs). CI people writing these
> shell-scripts could pickup these hints and report them, if that makes sense.
> 
> ---
> 
> Jesper Dangaard Brouer (2):
>        selftests/bpf: test_progs use another shell exit on non-actions
>        selftests/bpf: test_progs avoid minus shell exit codes

Applied, thanks!
