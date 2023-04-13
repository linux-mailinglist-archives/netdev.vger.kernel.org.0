Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8F36E05E2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDMETm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjDMETZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:19:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD85903C
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17D9C600BE
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4F4C433D2;
        Thu, 13 Apr 2023 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359496;
        bh=ogvQZn516d/ke63x3wBxc366In/8R13ov0cJrL/8QXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ITxnvMAlY4R5KkQ78Vt74Woe1uhzp5xYLQLQw5vS//MjN1lrucFVIzNWYfCAqVoRu
         d9rtj2DLF4EldO6K5JpB4AXweL6f05WNlqexSdNpwC9Djcbxwqthru5RjH5ovoFRCj
         NkQsDwHPQbUpJQiE4T0fsSBwuFZL+mzH/xNd77EqQAUVkaCtJB+MJhgQx/HCttprGx
         zOns88dpueFJtoBnVDlSpzpSODU9DOw1KsNHVQMFy7CUGwcas3OiIsoU6iUcp/EKDt
         t6JX/oaGdZ1ToFLl5m30YBNfqRYxJIv4BYc9mcOccQnnRM+2aThRTStN4T0nzKRq0b
         g15a24Na5ctOw==
Date:   Wed, 12 Apr 2023 21:18:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next 0/3] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230412211814.273fd0a5@kernel.org>
In-Reply-To: <c433e59d-1262-656e-b08c-30adfc12edcc@gmail.com>
References: <20230411201800.596103-1-kuba@kernel.org>
        <c433e59d-1262-656e-b08c-30adfc12edcc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 09:41:16 +0300 Tariq Toukan wrote:
> Happy holidays! I was traveling and couldn't review the RFCs.
> 
> Dragos and I had this task in our plans after our recent page pool work 
> in mlx5e. We're so glad to see this patchset! :)

I may end up sending some hacks for mlx4 depending on what results I get,
I wonder if the reaction will be as enthusiastic :)
