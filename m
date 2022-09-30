Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF455F0F3B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiI3Psz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiI3Psv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:48:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0E81B3A79;
        Fri, 30 Sep 2022 08:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 288FD622A9;
        Fri, 30 Sep 2022 15:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BD1C433C1;
        Fri, 30 Sep 2022 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664552928;
        bh=WTsfxcCetaWj0z8nC52kBDNmHS2wbkEsuXxoixeoHhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uG0CqsCRUl99ZNVOtxt+lwLOYX7DyRUFTgEGXyJEld2WTszxirzfu4ihujgXl4rRB
         Spcyf+MnYU2CKw9dy21QHdBixmZ/rsdwesQojAJJMvAGpC4HJWsLgzlqPy4iGMIpWL
         pFWjHOczcvbXFsJ+/Ii+Ghzcys5c80dNejmUTBzoT56JxbBwDCcf75q33zeYw2mXt/
         Gz5pW3h6Ltj+g+BI3YvakbU3keG6XRayJETrm7ugsjs4z6DgmsnVcAhI4GuHczaeHL
         wKgMgC6DqaTDMmzT0GCtIoAJQsz/wpJkHKGQZbCmstM+d2gMHP2cTJDEM5J0tVgfC2
         FMbUOhaLOGe1Q==
Date:   Fri, 30 Sep 2022 08:48:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     netdev@vger.kernel.org, wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        alex000young@gmail.com, security@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH] eth: sp7021: fix use after free bug in
 spl2sw_nvmem_get_mac_address
Message-ID: <20220930084847.2d0b4f4a@kernel.org>
In-Reply-To: <20220930040310.2221344-1-zyytlz.wz@163.com>
References: <20220930040310.2221344-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 12:03:10 +0800 Zheng Wang wrote:
> This frees "mac" and tries to display its address as part of the error
> message on the next line.  Swap the order.
> 
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> 
> Reported-by: Zheng Wang <hackerzheng666@gmail.com>
> 
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>

Is there reporter and author the same person with different email
addresses or two people?

