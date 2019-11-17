Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EB5FF965
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 13:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfKQMZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 07:25:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:56954 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfKQMZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 07:25:36 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWJcL-0002Mp-5E; Sun, 17 Nov 2019 13:25:25 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWJcK-000PTt-Rj; Sun, 17 Nov 2019 13:25:24 +0100
Subject: Re: pull-request: bpf 2019-11-15
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20191115221855.27728-1-daniel@iogearbox.net>
 <20191115.150906.1714221627473925259.davem@davemloft.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aa01a6e5-e155-af3d-5b74-77bff8d679ea@iogearbox.net>
Date:   Sun, 17 Nov 2019 13:25:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191115.150906.1714221627473925259.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25636/Sun Nov 17 10:57:06 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 11/16/19 12:09 AM, David Miller wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Fri, 15 Nov 2019 23:18:55 +0100
> 
>> The following pull-request contains BPF updates for your *net* tree.
>>
>> We've added 1 non-merge commits during the last 9 day(s) which contain
>> a total of 1 file changed, 3 insertions(+), 1 deletion(-).
>>
>> The main changes are:
>>
>> 1) Fix a missing unlock of bpf_devs_lock in bpf_offload_dev_create()'s
>>     error path, from Dan.
>>
>> Please consider pulling these changes from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> 
> Pulled, thanks Daniel.

Do you have a chance to double check, seems the PR did not yet get pushed
out to the net tree [0,1].

Thanks a lot,
Daniel

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/log/kernel/bpf/offload.c
   [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/log/kernel/bpf/offload.c
