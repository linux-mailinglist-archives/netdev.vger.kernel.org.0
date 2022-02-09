Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1F4AE622
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbiBIAid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiBIAic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:38:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4959DC061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:38:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 080FCB81DBE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFA3C004E1;
        Wed,  9 Feb 2022 00:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644367109;
        bh=bIVnhnwa63Aq61kKWu2n1baJuyrJ9fja/e/EyL0qSoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZFsi3nIDtIE2n6r30ESa2ntFV1AOxY1iNjbV30o3MyCyDXwYrOr2F8ioH4ZMg3Tew
         xPWANTYfZaNTG00kOsKWdxyWXSfS9sHr+n6jKp6htcfFDdBXuX/RLwZJSkdki6FiHb
         WGUeQkVxUECTmjf/v5+z1Ul6a2vB1/iSYPHi9LrqG1HgxrdgS3yCuS2P4p/5rTbdsd
         T7s1VX6xk898rY0SpunlxHRGP6ax5iiq4VcPVOuTanZ8VhMukjLa3dOrUTnuV/XN3s
         PyOk5gieunTZxkqaQ3VNRjW3uYjTBpiBRDMk3SgL/X41dZwBsAQrBWNGxWRrD3pkBY
         oASqJrIzCc7eA==
Date:   Tue, 8 Feb 2022 16:38:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [net-next] tipc: rate limit warning for received illegal
 binding update
Message-ID: <20220208163828.2be15fc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220208183157.922752-1-jmaloy@redhat.com>
References: <20220208183157.922752-1-jmaloy@redhat.com>
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

On Tue,  8 Feb 2022 13:31:57 -0500 jmaloy@redhat.com wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> It would be easy to craft a message containing an illegal binding table
> update operation. This is handled correctly by the code, but the
> corresponding warning printout is not rate limited as is should be.
> We fix this now.
> 
> Signed-off-by: Jon Maloy <jmaloy@redhat.com>

I reckon this should go to net with:

Fixes: b97bf3fd8f6a ("[TIPC] Initial merge")
