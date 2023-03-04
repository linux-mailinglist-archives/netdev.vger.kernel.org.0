Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8301B6AA936
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 11:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCDKlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 05:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCDKlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 05:41:08 -0500
Received: from esmtp-1.proxad.net (esmtp-1.proxad.net [213.36.6.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCA411E85;
        Sat,  4 Mar 2023 02:41:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by esmtp-1.proxad.net (Postfix) with ESMTP id 3EAB4827E5;
        Sat,  4 Mar 2023 11:41:06 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at proxad.net
Received: from esmtp-1.proxad.net ([127.0.0.1])
        by localhost (esmtp-b23-1.proxad.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id peo0MIIwF8E7; Sat,  4 Mar 2023 11:41:05 +0100 (CET)
Received: from zstore-5.mgt.proxad.net (unknown [172.18.94.8])
        by esmtp-1.proxad.net (Postfix) with ESMTP id C29C3824A7;
        Sat,  4 Mar 2023 11:40:59 +0100 (CET)
Date:   Sat, 4 Mar 2023 11:40:59 +0100 (CET)
From:   Adrien Moulin <amoulin@corp.free.fr>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Message-ID: <942662230.43320473.1677926459270.JavaMail.zimbra@corp.free.fr>
In-Reply-To: <20230303171756.38a8a43e@kernel.org>
References: <61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr> <20230303171756.38a8a43e@kernel.org>
Subject: Re: TLS zerocopy sendfile offset causes data corruption
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.12_GA_3803 (ZimbraWebClient - SAF16.2 (Mac)/8.8.12_GA_3794)
Thread-Topic: TLS zerocopy sendfile offset causes data corruption
Thread-Index: aC9LENSJAJFdB5ChhtNYIe4PtK1SOg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: "Jakub Kicinski" <kuba@kernel.org>
> Would you be able to test potential fixes? Unfortunately testing
> requires access to the right HW :(
> 
> I think the offset needs to be incremented, so:

I confirm that this completely fixes the issue in my testing, thanks !
