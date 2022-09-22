Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA56C5E5CD3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiIVIDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiIVIDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:03:20 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Sep 2022 01:03:19 PDT
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF4720371;
        Thu, 22 Sep 2022 01:03:18 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id DA1281008B39A;
        Thu, 22 Sep 2022 15:46:21 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 7785537C840;
        Thu, 22 Sep 2022 15:46:21 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HrTkUEA_dBjx; Thu, 22 Sep 2022 15:46:21 +0800 (CST)
Received: from mstore110.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.110])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 475C437C83F;
        Thu, 22 Sep 2022 15:46:21 +0800 (CST)
Date:   Thu, 22 Sep 2022 15:46:21 +0800 (CST)
From:   =?gb2312?B?0e7F4OWw?= <yangpeihao@sjtu.edu.cn>
To:     sdf@google.com, YrYj3LPaHV7thgJW@google.com
Cc:     bpf@vger.kernel.org, cong.wang@bytedance.com, jhs@mojatatu.com,
        jiri@resnulli.us, netdev@vger.kernel.org, toke@redhat.com,
        xiyou.wangcong@gmail.com
Message-ID: <95092865.3867028.1663832781195.JavaMail.zimbra@sjtu.edu.cn>
Subject: [RFC Patch v5 0/5] net_sched: introduce eBPF based Qdisc
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [59.82.45.1]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - GC90 (Mac)/8.8.15_GA_3928)
Thread-Index: SCxhe3wXFikQ/JFbYkIBB9tCfQa9MA==
Thread-Topic: net_sched: introduce eBPF based Qdisc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/24, sdf wrote:

> I feel like this patch series (even rfc), should also have a good example
to show that bpf qdisc is on par and can be used to at least implement
existing policies.

I recently build an example for the simplest `pfifo` qdisc based on Cong Wang's patches, 
see https://github.com/Forsworns/sch_bpf/
if you have interests. The sample is a little large, and involving modifications on libbpf, 
so I didn't attach it as a patch here. 

I also run a micro-benchmark with iperf3, see 
https://gist.github.com/Forsworns/71b70ed67d2ac53a4316bac862ce7d0f

I know it's unfair to evaluate the sch_bpf with `pfifo`, since sch_bpf is based on rbtree.
But I think it a good example for other classiful and more complicated qdiscs.
The `pfifo` is simple enough as a start :)
