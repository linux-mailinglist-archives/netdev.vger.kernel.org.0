Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2586370F5
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 04:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiKXDXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 22:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKXDXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 22:23:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F63C5614;
        Wed, 23 Nov 2022 19:23:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68FCE61B20;
        Thu, 24 Nov 2022 03:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79709C433D6;
        Thu, 24 Nov 2022 03:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669260216;
        bh=V6IeSAGWn79i/+Opdc0yOZ4NLpDi/ZbyJ7JXTnwe6Wc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fEZqDnYxaK9lIqNFDZNzsFGxhhuWrIKDZnGkNEb78GSCg0GB28kkbOVy/BzwTdqUV
         Xa+6IR+XUIJCFd46E5lbW/vunuvuQiCvAvZo5qso+ra72nMsNd9a1MgopJr1+/SbYC
         3jpRy+7/iSKpLcMHgclvn6I5TP/WzBeCvovMxNgNJqS3ccFIFzSW/RWptf0E6TJrRJ
         SSOPR/sKMBr5XQDUQap30i8pSIVvobxy9eyGK+xORZOCyh90HjackzQQ6h+44TPAI9
         jptcNcTbZ8curRepJdkEk6IFZINSMTQdAdV8qMbCntt5jBqiV6Qsdu+4dHUvvb0ayO
         K3HOy/33j7O3g==
Date:   Wed, 23 Nov 2022 19:23:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving
 away from softirq, part 2
Message-ID: <20221123192335.119335ac@kernel.org>
In-Reply-To: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
References: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
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

On Wed, 23 Nov 2022 10:06:20 +0000 David Howells wrote:
> [!] Note that these patches are based on a merge of a fix in net/master
>     with net-next/master.  The fix makes a number of conflicting changes,
>     so it's better if this set is built on top of it.

Please post as RFC if the patches don't apply.
