Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD6645248
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLGCwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLGCwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:52:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C1A2BB38;
        Tue,  6 Dec 2022 18:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A706615A3;
        Wed,  7 Dec 2022 02:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E591C433D6;
        Wed,  7 Dec 2022 02:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670381550;
        bh=dX+YujGKo9z0CIdbzfoEM3aU+aApO6o2u9oJSwQyIlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P7mImKxihvfJuQTFOuaW4GZjnnsN4JjrFBI/rysTWxiZEYsHiFLrA5/GuqtrcWsS+
         rXORWYsbOtac2evGBanSz6RUqjIK2Solx+vsdnwcAu5SRYYAnuB+ugEc96hsC3EVQ3
         nFU0MliFN+Q+3xbuEd4qVSB6g/n2js4EeWMIokBsR7wRov+8Qm2TSibBHW9vGUNQ00
         f1IwHlkErpc2Tgwh8j8Z7Q5hT18zi6uB3Vsx2Xi8RXHL5vfUKZr5ZbeiEcTYvLWYYm
         Q3ASMYDsI9NuVIPxo/7AQVk2RBB3zQQb4mPta49/mfAn4VnjYXqrwXImNOeqEVlvLz
         lw8WN5sHBIslg==
Date:   Tue, 6 Dec 2022 18:52:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: mdio: Reorganize defines
Message-ID: <20221206185229.3f948615@kernel.org>
In-Reply-To: <20221202204237.1084376-1-sean.anderson@seco.com>
References: <20221202204237.1084376-1-sean.anderson@seco.com>
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

On Fri,  2 Dec 2022 15:42:37 -0500 Sean Anderson wrote:
> prerequisite-patch-id: 53145a676b9582dde432d31e0003f01a90a81976

Hm, what is this? It's not a commit ID known to our trees...
