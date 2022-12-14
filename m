Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BCB64C48B
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbiLNH6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbiLNH6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:58:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4119002
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 23:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC562B816A7
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E506C433EF;
        Wed, 14 Dec 2022 07:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671004685;
        bh=dhpSqATSrJPp/AOUBtUMTMDB+s80lj/0WgB9ryJ7LsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n10UaHvU5FcYRYkFIQAyHprgU3AtIEaHAbck6HRcz8yeT7tu5GGs92pjXXWJjglPM
         FSe3UUR+sGerhLLPbNANaZ4Il+9d22idu3UEI8qgBsUigOwyTWQAbO1UfEQkokXrCU
         vC5rIR4rHjgKUqCrs9HVlsCDlExkp/WyfHub5wvlLhyQdw4/eDGxW7Ltpnd5qi8FPl
         geL86Bfhv9Q9+HxSDBLPPVCNQnJ00fgSLvLOMo5kokBeARl7rvc334YeBbV0S/ZNEg
         CBXdlEl8qNjNLCzsySndn6BUyuGVmmIb5sv7g4VT/7XYixJZXOg/Shgk3amWS1tpXN
         awit6SSDhMf/Q==
Date:   Wed, 14 Dec 2022 09:58:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net v2 0/5] net: wangxun: Adjust code structure
Message-ID: <Y5mCCQ3mrwD/gSSi@unreal>
References: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 02:41:28PM +0800, Jiawen Wu wrote:
> Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
> And move the same codes which sets MAC address between txgbe and ngbe
> to libwx.
> 
> Changelog:
> v2:
>   - Split patch v1 into separate patches
>   - Fix unreasonable code logic in MAC address operations
> 
> Jiawen Wu (5):
>   net: txgbe: Remove structure txgbe_hw
>   net: ngbe: Remove structure ngbe_hw
>   net: txgbe: Move defines into unified file
>   net: ngbe: Move defines into unified file
>   net: wangxun: Move MAC address handling to libwx
> 

From Jakub (copy/paste):
# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.2-rc1 is cut.

Thanks
