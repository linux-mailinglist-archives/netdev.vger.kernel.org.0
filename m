Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47ED5E634E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiIVNMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIVNMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:12:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1622E6B7;
        Thu, 22 Sep 2022 06:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A1F6334D;
        Thu, 22 Sep 2022 13:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAE6C433C1;
        Thu, 22 Sep 2022 13:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663852361;
        bh=a6Pxb5FFcGLIPM2aP832Xw0KLYvfxKAw3qHbhN0ERD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hh+K4+W0G3XOml4vAkNGhfWn+eLNdj84S+ahAtP7IfFPcfKTdo+ShyATLdsYeJ2Tp
         T8cVu912jI1euX5jECyamUX1zOzuNggm15syBmpdFEIBIZpnp9auZuSG5havJ2P8J3
         nGWPjditWNKEeaBEglYc/7NQX4/JR2f58kkQil/YzG4DnEJvrlaZ1+l/KtFtE5AE3G
         KTJq85TV9lbB5Ft25aCbn6tQoem3crBz2XMSd4bkAqSzQCaRUNn/NieW68daYd2+Bl
         bQJe/QLfhVgu9dhUvmKbTmytz3YtOZ7mP/IBJZCTMAx87rdS/kKemcAVdLyDdUlrXj
         BNrpzp92+cHiA==
Date:   Thu, 22 Sep 2022 06:12:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [net-next] selftests: Fix the if conditions of in
 test_extra_filter()
Message-ID: <20220922061239.115520b2@kernel.org>
In-Reply-To: <1663850569-33122-1-git-send-email-wangyufen@huawei.com>
References: <1663850569-33122-1-git-send-email-wangyufen@huawei.com>
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

On Thu, 22 Sep 2022 20:42:49 +0800 Wang Yufen wrote:
> The socket 2 bind the addr in use, bind should fail with EADDRINUSE. So
> if bind success or errno != EADDRINUSE, testcase should be failed.

Please add a Fixes tag, even if the buggy commit has not reached Linus
yet.
