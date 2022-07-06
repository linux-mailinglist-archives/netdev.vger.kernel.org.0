Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48D35692EB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiGFT6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiGFT6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:58:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2C11ADB1;
        Wed,  6 Jul 2022 12:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB13B81EB5;
        Wed,  6 Jul 2022 19:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA66EC341C8;
        Wed,  6 Jul 2022 19:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657137488;
        bh=HafG7D5C2mU7+7hsuowZQ2J6LPO+uk5WMARyqJgqnWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VxoCbt+x3l5jZX7ENcAhWshBoMmU2KaKTehZYJrw/Cw2NTPdckUuv9I2EOOP5bNsc
         0EH+nLFiHLouTLJRd02oXYWPDhZhy9xn97YhOBGpzidACNMM+QTg9WqAnot1OzNvzF
         G79I/42RlZuZM/vYkxN9a700rCO+FKpBZtke3/sTctONf4bcewr/TAxtX3J1vypPj5
         jv99xZXJevosgHB5UwM1PoujL8U3L6Kry+uMu9klNc55pSt0ZuF6R+AXzpK/xR7cKb
         slsHbFnMVzHpa2b2b3JC4h8iBAWfiGt7EmHOYrw3TjtGHtzKVtUq7tzYV/laxj5iGl
         OBGWEhypV6WUA==
Date:   Wed, 6 Jul 2022 12:58:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next] net/sched: remove return value of
 unregister_tcf_proto_ops
Message-ID: <20220706125806.4362d1ad@kernel.org>
In-Reply-To: <a92ed8b2b01e499b986ad7b9b0fe93a8@huawei.com>
References: <20220704124322.355211-1-shaozhengchao@huawei.com>
        <20220705184326.649a4e04@kernel.org>
        <a92ed8b2b01e499b986ad7b9b0fe93a8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 01:52:38 +0000 shaozhengchao wrote:
> 	Thank you for your apply. This patch does just remove the
> return value and change the function type from int to void. It
> doesn't remove the function.

I understand. I'm asking you to replace the word "useless" with
"unused". Additionally I'm asking to consider if instead of returning
an error code the function should print a warning if error has occured. 
