Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6D15424C3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377982AbiFHCqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447467AbiFHClu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB122194BC6
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 17:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3D5D6177B
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF157C34114;
        Wed,  8 Jun 2022 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654647690;
        bh=5W0lVFzCVq8dtXQaVp/LRZSfyXpDIxUm2LbMIl+ZW6c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CU3O/L9UKCOVHxMzqKuf281eu1M1hlWA1mrvJO1NsqLc/e7GKdYifkJjV2NG3kqVx
         8JqpmyFdOmo6CBKuQnC3S1F0XJvO8xcMJyJ9BnQbj6tw1hd9O/GPzC6AQ1WQgdSWd8
         3p6dMBssaPymZlAD3K5QkN8w4BFjh7AxhJTOUIJH1/pro+zASsfKDkawj/zMyvBX1A
         2+UcksvGJ45aGCLhg5VvuTInh6KKE+FSwmEvVYYv+xAjAXT76dZFvkBcU5vlYpSYbs
         2qxgsrRWe3gDeF2ma71OmDJD8sMRsKoTybicgo9uQ1P5+NZWTnOvfXAo1PzY8D6nXS
         GyR71xiBQVFLA==
Date:   Tue, 7 Jun 2022 17:21:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anton Makarov <antonmakarov11235@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        david.lebrun@uclouvain.be
Subject: Re: [net-next 1/1] seg6: add support for SRv6 Headend Reduced
 Encapsulation
Message-ID: <20220607172129.73d7b307@kernel.org>
In-Reply-To: <4f26bfaf-3c91-fe19-ede1-d47d852c17f6@gmail.com>
References: <4f26bfaf-3c91-fe19-ede1-d47d852c17f6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jun 2022 21:41:59 +0300 Anton Makarov wrote:
> This patch extends SRv6 Headend behaviors with reduced SRH encapsulation
> accordingly to RFC 8986. Additional SRv6 Headend behaviors H.Encaps.Red and
> H.Encaps.L2.Red optimize overhead of network traffic for SRv6 L2 and L3 
> VPNs.
> 
> Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>

Thurnderbird line-wrapped the patch contents. Could you try reposting
with git send-email?
