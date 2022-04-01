Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316454EE6AB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiDADZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244503AbiDADZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8985620F
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6125761A39
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513CFC2BBE4;
        Fri,  1 Apr 2022 03:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648783397;
        bh=TdghI3yWjnSgDLeGphrpSNGgSwr3brq9O1h8jZPjRiw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XLbiiPkARW+Pr6bDK8m6vVgdJig3jk1syqty7u6Rqdi6bdZ7pYwyikavLk6UTw7rQ
         IsQiJfMJMQvX0nXvryy2BgTQXTaoy3d4wGfHgDGvdivB4BRbb73qU8JH9GOFu5VHnV
         30mJrgahXSiLp3QPhRLmoPzBzws01l1XThaDNk8qwuY0cQ+/FA4jjz8YSV9N8kAwej
         ncI35L/C806KM76RL9dOkq9vmq7cFDdJoKaWjzWnpUmH2RG7mIyYB7wl24/Ss2x9bo
         uDSela8bfeWC1spFC1eDhsLfK9Y+ffnishr1v4BXuv5yyxJ4zvom3gMz0dB2fjpzjp
         hSktj9zLv9OGg==
Date:   Thu, 31 Mar 2022 20:23:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RFCv4 PATCH net-next 3/3] net-next: hn3: add tx push support
 in hns3 ring param process
Message-ID: <20220331202316.6f78748e@kernel.org>
In-Reply-To: <20220331084342.27043-4-wangjie125@huawei.com>
References: <20220331084342.27043-1-wangjie125@huawei.com>
        <20220331084342.27043-4-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 16:43:42 +0800 Jie Wang wrote:
> Subject: [RFCv4 PATCH net-next 3/3] net-next: hn3: add tx push support in hns3 ring param process

BTW this patch is missing an s in hns3 in the subject ;)
