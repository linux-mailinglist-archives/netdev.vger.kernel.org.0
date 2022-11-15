Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48C62904C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiKODCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiKODCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:02:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890581B1E5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 18:59:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24C94B81677
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7F2C433D7;
        Tue, 15 Nov 2022 02:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668481167;
        bh=2v+KARNW4vw+JKvPNo03G4f8Vr0ehSLDtTrOCmSieQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u5pqNWb7DWe5Kt5Q+sdmwwBmEtXrcRg6WxM1Y4MPLj2yIc/SV/1eLflMaFJJwyrEW
         aZQW9k9DWNVMPgq3zfN4l8gdkW/Wkz5I/DgpAVgWHfUl2yTMdlJr6VkBo9hE59N4vR
         Hk5Y6ddcg0Lh4NYPs60DKn0Q05g9jyr3xTEHjlz6h+VHgXcMFFLGuPf6cS/lqvJI4b
         lwy76dbCReqTPmhQB+oS0R68W6Lp8W0XyZRVJ4lLE7SAmcZzkPoCbbREAqFCr6f1rD
         ltMygr7t4JGcPStFtTWZnkdwcTqKLpoA8mm1CbMDuQwcZny+y8CBvgiTv8+ZB5KP6/
         jx1JwCZ8tafIQ==
Date:   Mon, 14 Nov 2022 18:59:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hao Lan <lanhao@huawei.com>
Cc:     <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <linyunsheng@huawei.com>, <liuyonglong@huawei.com>,
        <chenhao418@huawei.com>, <wangjie125@huawei.com>,
        <huangguangbin2@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <xiaojiantao1@h-partners.com>
Subject: Re: [PATCH net-next 0/2] net: hns3: Cleanup for static warnings.
Message-ID: <20221114185926.23148f9e@kernel.org>
In-Reply-To: <20221112081749.56229-1-lanhao@huawei.com>
References: <20221112081749.56229-1-lanhao@huawei.com>
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

On Sat, 12 Nov 2022 16:17:47 +0800 Hao Lan wrote:
> Most static warnings are mainly about:
> Patch #1: fix hns3 driver header file not self-contained issue.
> Patch #2: add complete parentheses for some macros.

You need to say what static checker was used.
I think it's documented in the "researcher guidelines" doc.
In case patch 2 was based on a warning from checkpatch please
drop it from the series, we don't take checkpatch-based cleanups.
