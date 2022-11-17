Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE6C62D8A8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbiKQK7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbiKQK6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:58:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800102A70E
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:55:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F7E60AE9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EDEC433C1;
        Thu, 17 Nov 2022 10:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668682533;
        bh=bqEgAabDndE4N1MKV7K/TPx0jmKHs8zrAlaQAHYeyrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A3yFt2j527JgJRVjByOwkk+SqQrGviV+aBFy1gAUA9fkkxVlb+DHav/vJYGJv2e/R
         qoIktMqgI3Nl7LCmL17SOExm8btqt2RQeIx/8RKIKmZQ0dYHDJPIY3ji8jLS83xitd
         vPoBS44GF7x/yAPtYyyVTZ4j0/TP/12PiGD7yxkGeKknZg9QK40i6ECCN5Y9pyW5fL
         WN3rtHwG+Otf8jpRYJlL1zt7LXCvpVAxwlnRyRrd2athHPYRF111lZO2IB4VoSwqKV
         rXR0hQEe8wYIo6KH1HguekTKoYC/oD/L6NqOM9ckG7XVrcaLxL+AwZH4maSEQujt63
         l+DI2otOFoMVA==
Date:   Thu, 17 Nov 2022 12:55:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH net-next] ice: remove redundant non-null check in
 ice_setup_pf_sw()
Message-ID: <Y3YTIciHsqKm2J97@unreal>
References: <20221116122032.969666-1-przemyslaw.kitszel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116122032.969666-1-przemyslaw.kitszel@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 01:20:32PM +0100, Przemek Kitszel wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> Remove a redundant null check, as vsi could not be null at this point.
> 
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
