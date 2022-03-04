Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546784CCD06
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiCDFX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiCDFX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:23:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E67117064
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50EB8B82746
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 05:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBC2C340E9;
        Fri,  4 Mar 2022 05:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646371358;
        bh=6laP1gcGgkFBt5cNC78yIifXQ5VRlmgMy3QL6AdFtL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VX7Tkim1oNOYJ0dHYVW9NNUiexZlOun5zQfNWXp9XkGn1IlQh62kWLN2RN+YubYbR
         bHJsGfP7wgn7NMy2AMpN7dwzjLJNZO5/lWRmvhcSjlvYWHBhNyHkyyh/KIp8q2kdpJ
         Uydz2BizNrgM09gbGxhZJk0zkSO9z+A3ByUxaVfdKOL16kayVVcPkwsutOLK8pXr0N
         hYf+lvtV6TP0rcwqGTiN/Jg+MtCU9BbX1eEtI/V/Hki+zKafzCOtjpIgB6sG58rM8p
         xlD1M8QpAAaiRd+WMKSKZ2esrypc5ZNv5hMsjqyu4WjFDvU/6RICqBCHAVI8p1ELsR
         U2tiPbZsROi6Q==
Date:   Thu, 3 Mar 2022 21:22:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, dsahern@gmail.com,
        menglong8.dong@gmail.com
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
Message-ID: <20220303212236.5193923d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220304045353.1534702-1-kuba@kernel.org>
References: <20220304045353.1534702-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 20:53:53 -0800 Jakub Kicinski wrote:
> -	return false;
> +	return __SKB_OKAY;

s/__//

I'll send a v2 if I get acks / positive feedback.
