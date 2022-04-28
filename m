Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E89C513A19
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350237AbiD1Qqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350239AbiD1Qqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:46:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A21B2477
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EDD620B6
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762BDC385A9;
        Thu, 28 Apr 2022 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651164200;
        bh=K0GnLctCOZQ+mfIprR9tjcWQVNWUb9aplXYMLJrrL0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MneMPehbZm+09kJ0F52dIfKwQY8dj0XeIHfAdepY0GJfNcdklF4RnjOjnrbyL7Vhx
         EguG3T+3mqy3fcxxGkhF5sX1xnienNMi/3doPYBKfbXCYt0MZ8jR3SPiXHfsaLGWai
         3EikCye/dh8aqmLmZAqByGoKGGaKqcXBitdm3xDihNK6+dHcfI1lbxDH2G6hvT5fY6
         poQ+n/WKu6BffQDn5H515yzRP/TeI4/7hzOKwp9PgtgcfjBfGhvMyDbdUNTnwdH0c/
         +EiGyRLy4kCtFtOFjfChR9G20syofV/yAByj0BDkBoMGcQb/HKkrjtnwdrBYKeC0UG
         AIO7yleKG5PWQ==
Date:   Thu, 28 Apr 2022 09:43:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 1/1] ixgbe: ensure IPsec VF<->PF compatibility
Message-ID: <20220428094319.04bf97fd@kernel.org>
In-Reply-To: <20220427173152.443102-1-anthony.l.nguyen@intel.com>
References: <20220427173152.443102-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 10:31:52 -0700 Tony Nguyen wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The VF driver can forward any IPsec flags and such makes the function
> is not extendable and prone to backward/forward incompatibility.
> 
> If new software runs on VF, it won't know that PF configured something
> completely different as it "knows" only XFRM_OFFLOAD_INBOUND flag.
> 
> Fixes: eda0333ac293 ("ixgbe: add VF IPsec management")
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Shannon Nelson <snelson@pensando.io>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Commit f049efc7f7cd ("ixgbe: ensure IPsec VF<->PF compatibility") in
net, thanks!
