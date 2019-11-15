Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458C1FE75F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKOWGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:06:16 -0500
Received: from www62.your-server.de ([213.133.104.62]:48284 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKOWGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 17:06:15 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVjjK-0005Ds-5s; Fri, 15 Nov 2019 23:06:14 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVjjJ-0006Th-PA; Fri, 15 Nov 2019 23:06:13 +0100
Subject: Re: [PATCH bpf] selftests: bpf: xdping is not meant to be run
 standalone
To:     Jiri Benc <jbenc@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
References: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <427e0b06-679e-5621-f828-be545e6ca3b1@iogearbox.net>
Date:   Fri, 15 Nov 2019 23:06:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/19 1:42 PM, Jiri Benc wrote:
> The actual test to run is test_xdping.sh, which is already in TEST_PROGS.
> The xdping program alone is not runnable with 'make run_tests', it
> immediatelly fails due to missing arguments.
> 
> Move xdping to TEST_GEN_PROGS_EXTENDED in order to be built but not run.
> 
> Fixes: cd5385029f1d ("selftests/bpf: measure RTT from xdp using xdping")
> Cc: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Any objections if I take this to bpf-next as otherwise this will create an ugly
merge conflict between bpf and bpf-next given selftests have been heavily reworked
in there.

Thanks,
Daniel
