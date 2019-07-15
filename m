Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5A69EE2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfGOWS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:18:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:33922 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732332AbfGOWSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:18:55 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9J8-0001oe-45; Tue, 16 Jul 2019 00:18:54 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9J7-000FFP-Pe; Tue, 16 Jul 2019 00:18:53 +0200
Subject: Re: [PATCH bpf] selftests/bpf: fix attach_probe on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com
References: <20190712134142.90668-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0e3e5502-4e4a-8b21-cf81-eac32d11b6ee@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:18:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712134142.90668-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 3:41 PM, Ilya Leoshkevich wrote:
> attach_probe test fails, because it cannot install a kprobe on a
> non-existent sys_nanosleep symbol.
> 
> Use the correct symbol name for the nanosleep syscall on 64-bit s390.
> Don't bother adding one for 31-bit mode, since tests are compiled only
> in 64-bit mode.
> 
> Fixes: 1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>

Applied, thanks!
