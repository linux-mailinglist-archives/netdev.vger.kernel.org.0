Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2991560D6
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 22:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBGVuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 16:50:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:50370 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgBGVup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 16:50:45 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0BWM-0006k2-Kw; Fri, 07 Feb 2020 22:50:42 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0BWM-000SoA-EE; Fri, 07 Feb 2020 22:50:42 +0100
Subject: Re: [PATCH bpf] bpftool: Don't crash on missing xlated program
 instructions
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200206102906.112551-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <39e47207-efdb-51ba-f671-9d04c368cc39@iogearbox.net>
Date:   Fri, 7 Feb 2020 22:50:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200206102906.112551-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25717/Fri Feb  7 12:45:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/20 11:29 AM, Toke Høiland-Jørgensen wrote:
> Turns out the xlated program instructions can also be missing if
> kptr_restrict sysctl is set. This means that the previous fix to check the
> jited_prog_insns pointer was insufficient; add another check of the
> xlated_prog_insns pointer as well.
> 
> Fixes: 5b79bcdf0362 ("bpftool: Don't crash on missing jited insns or ksyms")
> Fixes: cae73f233923 ("bpftool: use bpf_program__get_prog_info_linear() in prog.c:do_dump()")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
