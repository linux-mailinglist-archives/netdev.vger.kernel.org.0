Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A727023B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfGVOXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:23:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:40330 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfGVOXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 10:23:51 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hpZEE-0001Bq-4z; Mon, 22 Jul 2019 16:23:50 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hpZED-000DqE-VC; Mon, 22 Jul 2019 16:23:50 +0200
Subject: Re: [PATCH bpf] selftests/bpf: fix sendmsg6_prog on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com, rdna@fb.com
References: <20190719090611.91743-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <38573bb9-5e3a-73f4-5475-a7b2e24758cb@iogearbox.net>
Date:   Mon, 22 Jul 2019 16:23:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190719090611.91743-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25518/Mon Jul 22 10:12:39 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/19 11:06 AM, Ilya Leoshkevich wrote:
> "sendmsg6: rewrite IP & port (C)" fails on s390, because the code in
> sendmsg_v6_prog() assumes that (ctx->user_ip6[0] & 0xFFFF) refers to
> leading IPv6 address digits, which is not the case on big-endian
> machines.
> 
> Since checking bitwise operations doesn't seem to be the point of the
> test, replace two short comparisons with a single int comparison.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
