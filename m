Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D98598CF9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiHRT6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbiHRT6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:58:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C57D0772;
        Thu, 18 Aug 2022 12:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9973B823F8;
        Thu, 18 Aug 2022 19:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD0CC433D6;
        Thu, 18 Aug 2022 19:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660852682;
        bh=0GAsuDOlR0lDda6hiUVXgwjjgMJTvI8YozfrfujS6pY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M+3NzAVxvU0dSUj702HHHBkl32oLGBYtPphnSh7JfraPOd4A2NfVqL5QuQONgcY0g
         sKCOZUK63WFyHbTqZ/zs681TEnK6yHFLK97Ly0dDyy0FtLFyJhO4MkUOzxoryEZXpm
         iNouZiMYJeOr4npmZU99J6JEcPDPIaNASnHWrKaNIfvWc/2ITzP8PXp2ExHuhO97b0
         C7YCcYoMCpZHb74c20ql9NiJ8ITjwM2Tg6pSQ9O1ukYw0uiFUIA6fdXqLPEe1q3h+h
         Gxcwf2SoTiVBCoNvejloHtfv9TmZuTLgmOIXhiTuE991dFbSKmwbdJfpLVjWFhIHDf
         DBElgb1Vn7bLg==
Date:   Thu, 18 Aug 2022 12:58:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     wei.fang@nxp.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net 2/2] net: phy: at803x: add disable hibernation
 mode support
Message-ID: <20220818125801.54472864@kernel.org>
In-Reply-To: <Yv6TA9xfx4m2+YrH@lunn.ch>
References: <20220818030054.1010660-1-wei.fang@nxp.com>
        <20220818030054.1010660-3-wei.fang@nxp.com>
        <Yv6TA9xfx4m2+YrH@lunn.ch>
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

On Thu, 18 Aug 2022 21:29:07 +0200 Andrew Lunn wrote:
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Any guidance on net / net-next and Fixes, Andrew?

Seems like a "this never worked" / "we haven't supported such platforms"
case, perhaps?
