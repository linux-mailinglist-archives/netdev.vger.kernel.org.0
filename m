Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2102668BA5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbjAMFnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbjAMFmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:42:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1895EE1A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 21:42:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 503BB62228
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE95C433D2;
        Fri, 13 Jan 2023 05:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673588572;
        bh=e8arXR6u1+P5a9BXLJhqH+2TjOXZC8G6AgjUQLjIBAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l7QfBtqaXctAuaMUHhJckYnBEX++9dJ9ulRwvkO0IiOaPdByyjkGLFTVrvDo6q2go
         Oc2d60kqXPbJj2M0ZaL7ALe+4lNWH4EBoHbaQ5cyeBsDTzvx4ODHeJH1JcRhCtZiqQ
         wuMC6KkA/fM/KGU/v+RfoA0xA8hRR2hRhSikFTdw+YyUr24J9Mr54C6xHcHc+4BZF7
         ylY0aTLDRc55qQT8SUR/TR31mF2n8b2L6zLuM70augRYTpAxGRu3vrxp5yw9vOeB3t
         bqtu372DZnu8dBLQ5MD3HLKz8CD/UzsubktXgkPrmtkQtDXP5lCaNamM8no+NlSv2D
         xGCyFsh+2hcvA==
Date:   Thu, 12 Jan 2023 21:42:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ehakim@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <raeds@nvidia.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <sd@queasysnail.net>, <atenart@kernel.org>
Subject: Re: [PATCH net-next v9 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <20230112214251.142346d3@kernel.org>
In-Reply-To: <20230111150210.8246-2-ehakim@nvidia.com>
References: <20230111150210.8246-1-ehakim@nvidia.com>
        <20230111150210.8246-2-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 17:02:09 +0200 ehakim@nvidia.com wrote:
> +	/* Check if the offloading mode is supported by the underlying layers */
> +	if (offload != MACSEC_OFFLOAD_OFF &&
> +	    !macsec_check_offload(offload, macsec)) {
> +		return -EOPNOTSUPP;
> +	}

SMH. Let me drop the extra brackets here when applying.
