Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6572A52CF17
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 11:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiESJNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 05:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235866AbiESJNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 05:13:45 -0400
X-Greylist: delayed 423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 02:13:40 PDT
Received: from mail.sysmocom.de (mail.sysmocom.de [176.9.212.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB8156C0C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 02:13:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.sysmocom.de (Postfix) with ESMTP id EA3B019806C6;
        Thu, 19 May 2022 09:06:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
        by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nTmvwJMGprI5; Thu, 19 May 2022 09:06:33 +0000 (UTC)
Received: from [192.168.1.70] (dynamic-077-004-062-050.77.4.pool.telefonica.de [77.4.62.50])
        by mail.sysmocom.de (Postfix) with ESMTPSA id 6A0E8198012C;
        Thu, 19 May 2022 09:06:33 +0000 (UTC)
Message-ID: <97b1ea34-250b-48ba-bc04-321b6c0482c1@sysmocom.de>
Date:   Thu, 19 May 2022 11:06:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
From:   Oliver Smith <osmith@sysmocom.de>
Subject: regression: 'ctnetlink_dump_one_entry' defined but not used
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

since May 17 we see some automatic builds against net-next.git fail with:

> net/netfilter/nf_conntrack_netlink.c:1717:12: error: 'ctnetlink_dump_one_entry' defined but not used [-Werror=unused-function]
>  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~

Looks like this is a regression from your patch 8a75a2c17, I guess 
ctnetlink_dump_one_entry needs #ifdef CONFIG_NF_CONNTRACK_EVENTS?

Best,
Oliver
-- 
- Oliver Smith <osmith@sysmocom.de>            https://www.sysmocom.de/
=======================================================================
* sysmocom - systems for mobile communications GmbH
* Alt-Moabit 93
* 10559 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschaeftsfuehrer / Managing Director: Harald Welte
