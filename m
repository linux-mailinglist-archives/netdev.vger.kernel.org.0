Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97ED16EEE89
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbjDZGud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbjDZGuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E551737
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 23:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD738615C6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD0CC433EF;
        Wed, 26 Apr 2023 06:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682491830;
        bh=HYxJQHKbhU/IcaC9J1q4YJQsMsqkKKC/9Kh+9AsVGuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qeXhF3g57mJRspQd5Dr6kE5fw8r198NVeXklPt4+NSEK8G6pPc+ZOhTOG1KXnCAOu
         AmAJIMTLOIih+kZotNJo6XeGwHVMHfauYPZ/45uyHeCDN8fAayyATYEsYuVa8w82H/
         qhhzJJ030vIZvbydV/YRZ32ySuv/2iDPTFbIiNSqSsu6D+QpvpjjEpDIETSGKKsb9k
         5beK9unJoGeOSDcqXk5l0TYD363ZRVaUJdfwVWwpkoQIKG3Jqs3Lg344EUKZsrbLr1
         gtCNhglYfBfS0l7l0F0QWe0JHLSLOJoMvRqCbFKfhTRtGMPxRLSpPz93WEGT9DKEhN
         2Hz0ezU/cklnQ==
Date:   Wed, 26 Apr 2023 09:50:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Ahmed Zaki <ahmed.zaki@intel.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 1/3] ice: Fix stats after PF reset
Message-ID: <20230426065026.GH27649@unreal>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
 <20230425170127.2522312-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425170127.2522312-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:01:25AM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> After a core PF reset, the VFs were showing wrong Rx/Tx stats. This is a
> regression in commit 6624e780a577 ("ice: split ice_vsi_setup into smaller
> functions") caused by missing to set "stat_offsets_loaded = false" in the
> ice_vsi_rebuild() path.
> 
> Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
