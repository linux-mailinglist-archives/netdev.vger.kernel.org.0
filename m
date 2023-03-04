Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083746AAC3D
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCDT4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCDT4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:56:00 -0500
Received: from esmtp-1.proxad.net (esmtp-1.proxad.net [213.36.6.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0649974F
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 11:55:58 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by esmtp-1.proxad.net (Postfix) with ESMTP id 5C4F25F2F5;
        Sat,  4 Mar 2023 20:55:57 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at proxad.net
Received: from esmtp-1.proxad.net ([127.0.0.1])
        by localhost (esmtp-b23-1.proxad.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Z0jxqNbl6zCN; Sat,  4 Mar 2023 20:55:56 +0100 (CET)
Received: from zstore-5.mgt.proxad.net (unknown [172.18.94.8])
        by esmtp-1.proxad.net (Postfix) with ESMTP id D784E5DF09;
        Sat,  4 Mar 2023 20:55:46 +0100 (CET)
Date:   Sat, 4 Mar 2023 20:55:46 +0100 (CET)
From:   Adrien Moulin <amoulin@corp.free.fr>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev <netdev@vger.kernel.org>,
        edumazet@google.com, pabeni@redhat.com,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>, maximmi@nvidia.com,
        maxtram95@gmail.com
Message-ID: <267529036.43483634.1677959746359.JavaMail.zimbra@corp.free.fr>
In-Reply-To: <20230304192610.3818098-1-kuba@kernel.org>
References: <20230304192610.3818098-1-kuba@kernel.org>
Subject: Re: [PATCH net] net: tls: fix device-offloaded sendpage straddling
 records
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.12_GA_3803 (ZimbraWebClient - SAF16.2 (Mac)/8.8.12_GA_3794)
Thread-Topic: fix device-offloaded sendpage straddling records
Thread-Index: zXk1OI3ZjYu7K2PkEERKGT3t8uZEig==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Adrien, would you mind sending an official Tested-by: tag
> in reply to this patch?

Tested-by: Adrien Moulin <amoulin@corp.free.fr>

Thanks,

-- 
Adrien Moulin
