Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20E966A3A5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjAMTss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjAMTsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:48:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE60149E8;
        Fri, 13 Jan 2023 11:48:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E911B821D4;
        Fri, 13 Jan 2023 19:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A91BC433D2;
        Fri, 13 Jan 2023 19:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673639317;
        bh=dEa1FyCgbAjv9xYhXVkI/5nSgOJkvHr+IX3k5eDJk5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ur+Z8glLx18dTQfYrZNs4J8kSLQjukrQNxplQqS564D8K6XPIp/bq5IJuzhk8bYr8
         TxnKyT8AP3hootJ6PENoWOb/PCEBOU1pdQRXnHYbIi3wa6qrzzA7N3YgbtR3bNOIjd
         zO+jguOf3HPjUoKn76zFJEVEJsta8cX7kNRD2jP7KaFrdkmPIKrR+tszuoPvpCsGDD
         gN+vtJCNaebhzMSU2CXVKb5zUsD9jBDJqHcWISNp/ir1+7kVRqQqPBWfejnq2Ksor7
         02LG19UkdAAjBWfcAcWkWk8rK6uwcg0I1t7qMSpj0be7/yxKE3yiMm4+kGYoZbaRtw
         9p/y79O8kIHew==
Date:   Fri, 13 Jan 2023 11:48:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dust.li@linux.alibaba.com
Subject: Re: [PATCH v6] sock: add tracepoint for send recv length
Message-ID: <20230113114835.33b7db5c@kernel.org>
In-Reply-To: <20230111065930.1494-1-cuiyunhui@bytedance.com>
References: <20230111065930.1494-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 14:59:30 +0800 Yunhui Cui wrote:
> Add 2 tracepoints to monitor the tcp/udp traffic
> of per process and per cgroup.
> 
> Regarding monitoring the tcp/udp traffic of each process, there are two
> existing solutions, the first one is https://www.atoptool.nl/netatop.php.
> The second is via kprobe/kretprobe.

Applied, thanks!
