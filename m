Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54E3693F48
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjBMID7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMID5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:03:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35798BBAF;
        Mon, 13 Feb 2023 00:03:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E46E9B80D2F;
        Mon, 13 Feb 2023 08:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326D2C433D2;
        Mon, 13 Feb 2023 08:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676275434;
        bh=G8JZCVHBVv5OOpt9S16JA4H4MUeT37bgecZOL4vtXR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVCImKmiHFuEQ/EAwANllCGM/Y6ZT1FB73MMCrTk30dBl9JtWCIttb3gJqJwMvDH4
         copSDR1misku9lGp45uTp7kF0KdrQToEdyQkUSqaPua8eavVykSsr51ZoUMiyi932f
         eF5FAmF0I6ymjBl8K1mRU+AQP1Gw47l2sWB0KY1LzC0Gg3wyvR/U/A2LsokTbIf9O0
         /8pY/O0Am8hbfqXCoV8HIFpYpC0VDn8Dk7rfEgcG07aft7tMz0Gud2swVwzQFkqT0C
         LtqJ4k1KSjHPjETDeaAGN6JQfkK53YzhkeFlnLDDRqihK6lTKoMpKZiRk5MKnTnKtt
         AEZgWCjEyCfDw==
Date:   Mon, 13 Feb 2023 10:03:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        quic_sramana@quicinc.com, quic_tsoni@quicinc.com,
        sudeep.holla@arm.com, vincent.guittot@linaro.org,
        Souvik.Chakravarty@arm.com, cristian.marussi@arm.com
Subject: Re: [PATCH] vhost: Add uAPI for Vhost SCMI backend
Message-ID: <Y+nu5pQs5a/MhriH@unreal>
References: <20230213043417.20249-1-quic_neeraju@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213043417.20249-1-quic_neeraju@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 10:04:17AM +0530, Neeraj Upadhyay wrote:
> Add a uAPI for starting and stopping a SCMI vhost based
> backend.
> 
> Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
> ---
> 
> SCMI Vhost backend implementation is work in progress: https://lore.kernel.org/linux-arm-kernel/20220609071956.5183-1-quic_neeraju@quicinc.com/

Excellent, and this UAPI patch should come together with kernel code
which needs this new define.

Thanks
