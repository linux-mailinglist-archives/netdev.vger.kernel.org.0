Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383CE5E750
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfGCPDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:03:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:53484 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfGCPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:03:40 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hignK-0001WL-GK; Wed, 03 Jul 2019 17:03:38 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hignK-000QbG-Ak; Wed, 03 Jul 2019 17:03:38 +0200
Subject: Re: [PATCH bpf-next] selftests: bpf: standardize to static
 __always_inline
To:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Song Liu <liu.song.a23@gmail.com>, Y Song <ys114321@gmail.com>
References: <b62ef44131bbe3b905fc42990d16b667a65c820c.1562091849.git.jbenc@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e919398f-0d2d-28e2-5d0c-d4026dbaa95f@iogearbox.net>
Date:   Wed, 3 Jul 2019 17:03:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <b62ef44131bbe3b905fc42990d16b667a65c820c.1562091849.git.jbenc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 08:26 PM, Jiri Benc wrote:
> The progs for bpf selftests use several different notations to force
> function inlining. Standardize to what most of them use,
> static __always_inline.
> 
> Suggested-by: Song Liu <liu.song.a23@gmail.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Applied, thanks!
