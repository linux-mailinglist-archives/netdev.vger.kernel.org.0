Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A28188D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 13:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfHEL4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 07:56:54 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56501 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728566AbfHEL4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 07:56:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 954FC13CA;
        Mon,  5 Aug 2019 07:56:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 05 Aug 2019 07:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Al9xXN
        nQBhrH5WK3FSDmxm3LAWNimy6tAVR41EbOoQQ=; b=A9uvrlAXJc+I50J4yYv0Ir
        njhMui+pMKievJoqvhsR7qCAX8IHESw0PE3P0dvm3lN4W/3hPGoLPWQFA8kBpSXB
        Cqnnitwp7jbAd71wbGvO1Ue1ZA/cxWisycY6JTBJFxnLhXSr8V0+chMy65baedAI
        NKjdrgKRkWT4gwnS/GNmvNoERCLfKzCk6mA8J4iLTlj/PFwthIrE24JL7gOyaBRa
        UDVMJotprLMK6XceCLz0b7dKn/SvY/uCRPEqXvh4t/hrEqGwLs+wX6XlLCbf2Saw
        1nW2YQkZsEsT1DHJH9F+w6eWNuS8PK5xQ/D8DGPF2bEEr/02oGp8DIcgY8WCpoog
        ==
X-ME-Sender: <xms:ghlIXS2FWKSLzdVcUUMU8mJiD-J3ILoKFZkgZrImKjY-cjo5YY8Xmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtjedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucffohhmrghinheplhhkmhhlrdhorhhgpdhgihhthhhusgdrtg
    homhenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:gxlIXa7-9dB8ga5g2ofHOavewV36avvC5Oqb2jzFVFr3snXlTc1TWA>
    <xmx:gxlIXf_WCqpNqPfCPaYxriZR-C79wDv7W4kfOYSKa5vGpFnadmmEkw>
    <xmx:gxlIXS2rd6YZ5is82cawzZhQkCzHFy1ZqAyezTOg3wQavvvy2f2zVg>
    <xmx:hBlIXT7651ilOKumXnbyviJ96-nZlQOZwz48Csm1vekuIGd_RptDNw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 887A980062;
        Mon,  5 Aug 2019 07:56:50 -0400 (EDT)
Date:   Mon, 5 Aug 2019 14:56:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>, lkp@01.org
Subject: Re: [drop_monitor]  98ffbd6cd2:  will-it-scale.per_thread_ops -17.5%
 regression
Message-ID: <20190805115648.GA19906@splinter>
References: <20190722183134.14516-11-idosch@idosch.org>
 <20190729095213.GQ22106@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729095213.GQ22106@shao2-debian>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 05:52:13PM +0800, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed a -17.5% regression of will-it-scale.per_thread_ops due to commit:
> 
> 
> commit: 98ffbd6cd2b25fc6cbb0695e03b4fd43b5e116e6 ("[RFC PATCH net-next 10/12] drop_monitor: Add packet alert mode")
> url: https://github.com/0day-ci/linux/commits/Ido-Schimmel/drop_monitor-Capture-dropped-packets-and-metadata/20190723-135834
> 
> 
> in testcase: will-it-scale
> on test machine: 288 threads Intel(R) Xeon Phi(TM) CPU 7295 @ 1.50GHz with 80G memory
> with following parameters:
> 
> 	nr_task: 100%
> 	mode: thread
> 	test: lock1
> 	cpufreq_governor: performance

Hi,

Thanks for the report. The test ('lock1') has nothing to do with the
networking subsystem and the commit that you cite is not doing anything
unless you're actually running drop monitor in this newly introduced
mode. I assume you're not running drop monitor at all? Therefore, these
results seem very strange to me.

The only thing I could think of to explain this is that somehow the
addition of 'struct sk_buff_head' to the per-CPU variable might have
affected alignment elsewhere.

I used your kernel config on my system and tried to run the test like
you did [1][2]. Did not get conclusive results [3]. Took measurements on
vanilla net-next and with my entire patchset applied (with some changes
since RFC).

If you look at the operations per seconds in the 'threads' column when
there are 4 tasks you can see that the average before my patchset is
2325577, while the average after is 2340328.

Do you see anything obviously wrong in how I ran the test? If not, in
your experience, how reliable are your results? I found a similar report
[4] that did not make a lot of sense as well.

Thanks

[1]
#!/bin/bash

for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
        online_file="$cpu_dir"/online
        [ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

        file="$cpu_dir"/cpufreq/scaling_governor
        [ -f "$file" ] && echo "performance" > "$file"
done

[2]
# ./runtest.py lock1

[3]
before1.csv

tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,610132,74.98,594558,74.40,610132
2,1230153,49.95,1184090,49.95,1220264
3,1844832,24.92,1758502,25.07,1830396
4,2454858,0.20,2311086,0.18,2440528

before2.csv

tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,607417,74.92,584035,75.03,607417
2,1227674,50.02,1170271,50.05,1214834
3,1846440,24.91,1761115,25.03,1822251
4,2482559,0.23,2343761,0.20,2429668

before3.csv

tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,609516,74.96,594691,74.85,609516
2,1231126,49.82,1176170,50.07,1219032
3,1858004,24.93,1761192,25.06,1828548
4,2460096,0.29,2321886,0.20,2438064

after1.csv 

tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,623846,75.01,598565,75.01,623846
2,1237010,50.01,1163000,50.06,1247692
3,1858541,24.99,1752192,24.98,1871538
4,2477562,0.20,2338462,0.20,2495384

after2.csv

tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,624175,74.98,593229,60.28,624175
2,1237561,45.43,1168572,50.01,1248350
3,1850211,25.03,1744378,24.90,1872525
4,2481224,0.20,2335768,0.20,2496700

after3.csv

tasks,processes,processes_idle,threads,threads_idle,linear
0,0,100,0,100,0
1,617805,74.99,590419,75.02,617805
2,1230908,50.01,1158534,50.06,1235610
3,1851623,25.06,1728419,24.94,1853415
4,2470115,0.20,2346754,0.20,2471220

[4] https://lkml.org/lkml/2019/2/19/351
