Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85746294CB
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbiKOJtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238007AbiKOJs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:48:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA95D2D0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42085B817AE
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 09:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B2DC433C1;
        Tue, 15 Nov 2022 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668505732;
        bh=eow8JHaxuRcowbwN9UMzyRSY+Ox0lF7Pa/42AgGE5Wc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNVTcWGKf01GpKI057tjS0HPTIw/tVdEVLlo3yqpvQaGExPPgOk+i3uhrOF1ttHeI
         pHRkFkWm3XYvBiFiRpyBp8VeWvbqe7gLOEIC9mVMK1e+IcAcfaVPZ0if115ep+6/W3
         Z2LQ5ab8DDWOV+EMDjsVcDq6lNhN7oU5CK2JmiLPjNxj5o5kI8p1rnYPISiQbkRsBT
         /o9yAbcPxoaEtn7CZGUcN3eTmkdQXPy93prOmqqmumkKuyid5reL8yphuN/a/FtKeA
         opjIoqLd5Rh9rOmhYT0sMitPAt+1ry+hvDpfk2fjc+uunTXFXbIe0xeYS1F72Dm6b6
         2JdaFyZ6ga3YQ==
Date:   Tue, 15 Nov 2022 11:48:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Walter Heymans <walter.heymans@corigine.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next v3] Documentation: nfp: update documentation
Message-ID: <Y3NgfxS1JYSn5pWU@unreal>
References: <20221115090834.738645-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221115090834.738645-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:08:34AM +0100, Simon Horman wrote:
> From: Walter Heymans <walter.heymans@corigine.com>
> 
> The NFP documentation is updated to include information about Corigine,
> and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
> with new information about where to find firmware.
> 
> Two new sections are added to expand the coverage of the documentation.
> The new sections include:
> - Devlink Info
> - Configure Device
> 
> Signed-off-by: Walter Heymans <walter.heymans@corigine.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../device_drivers/ethernet/netronome/nfp.rst | 165 +++++++++++++++---
>  1 file changed, 145 insertions(+), 20 deletions(-)
> 
> v3
> * Moved changelog (this) to after scissors (---)
> 

Thanks
