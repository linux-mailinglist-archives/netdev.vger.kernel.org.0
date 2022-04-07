Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A4E4F7510
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbiDGFKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiDGFKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFD448300
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CDA9B826B2
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5BFC385A0;
        Thu,  7 Apr 2022 05:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649308120;
        bh=cdGbUjgtlL8UKGfa6Ef4o4LVuoVpNuN6MAcdP14LlxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AGnQdnv1BFgNaeeOVPjg7jQdh8+V+h19Svr6SizknNSs60saRHrnD9uEnRKJ69NSy
         RDOlPL5ZjATRRuBEH1OR1ZFdeSlIsLGIvvCBOTdOmDBMOndag+ODsXxCK//EVoyRUv
         fKJTD8pAzjaUwDwcXTTIMmWFP2vxDx4fPYVP1dHFnwFkhg/CndR8PUO4TbRLoXa3Mw
         xFgXcf1Wc2fNeqA4t+R+M+3pbtcHqBIOqoPLFNCstujk1eNwPulhucWUmQKOIIV+Mf
         EG5myElycMESH5qEYT7QiW1XmqfPU8eMjRtroX3I8PbjVUnaHs3DG8beSz+09E5AbM
         GcEKyXTr07Ziw==
Date:   Wed, 6 Apr 2022 22:08:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v3] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <20220406220839.4f16acf6@kernel.org>
In-Reply-To: <20220406093635.1601506-1-iwienand@redhat.com>
References: <20220405204758.3ebfa82d@kernel.org>
        <20220406093635.1601506-1-iwienand@redhat.com>
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

On Wed,  6 Apr 2022 19:36:36 +1000 Ian Wienand wrote:
> As noted in the original commit 685343fc3ba6 ("net: add
> name_assign_type netdev attribute")
> 
>   ... when the kernel has given the interface a name using global
>   device enumeration based on order of discovery (ethX, wlanY, etc)
>   ... are labelled NET_NAME_ENUM.
> 
> That describes this case, so set the default for the devices here to
> NET_NAME_ENUM.  Current popular network setup tools like systemd use
> this only to warn if you're setting static settings on interfaces that
> might change, so it is expected this only leads to better user
> information, but not changing of interfaces, etc.
> 
> Signed-off-by: Ian Wienand <iwienand@redhat.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
