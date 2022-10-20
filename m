Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50DC605478
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJTA2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJTA2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:28:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1EF193ED6
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 17:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72F936171B
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806F2C433D6;
        Thu, 20 Oct 2022 00:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666225713;
        bh=02W9vGw+S4NLpxD/zMPU2H0uffVVfaom4iPmGZMAVr4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LnDFqHOqNCyOEjBbYnAzgQKMPEEDMHavsygkLgentESRkl1mgtRKgkpkgoHgEz6sI
         c0yip0lMrLVsvtxk/AFx6H4dUQD6wOlYj0yPs23u0ZmUdOfTrhrwliJ1GV/sXDqKUF
         Biwad5qItDO1e8TqgQ0S7dsq94gX/0xo4GO81ZsRgmfgAhTRKEfWSD9s8UuIs8h7Cu
         XUDjauryubhcR/+mF2W+NC8dQh2C8Cc6YK24XKqTlJc7P/XDDRGCzfWml4Cpw276AH
         8JGdkCi0Khb3iu1V0uTQddAzwjYO2OVwB0XOaKKb3SH4FEyR5C9CUZawP0E0ncWOjJ
         a62OsK71cHsLA==
Date:   Wed, 19 Oct 2022 17:28:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net
Subject: Re: [PATCH net] net: hns: fix possible memory leak in
 hnae_ae_register()
Message-ID: <20221019172832.712eb056@kernel.org>
In-Reply-To: <Y06i/kWwJNT5mbj8@unreal>
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
        <Y06i/kWwJNT5mbj8@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 15:58:38 +0300 Leon Romanovsky wrote:
> The change itself is ok.

Also the .release function is empty which is another bad smell?

> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Thanks!
