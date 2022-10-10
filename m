Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD15F9A07
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiJJHeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiJJHdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:33:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B08A14098;
        Mon, 10 Oct 2022 00:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=M4V6DUHEa0iMWKs/q90JaFl9Qnfe85nSTpeyO1KArSQ=; b=yB98tdt79M0VcDWKSkNvz3O4AK
        Z0u4FYDmyapo1srbCOKG5pbltYrYfW3sqer1B8Lfo1RvQRPH4CmfYrbuERKhxjIGT8GSLEkSAet2l
        5aY4hW/BroU8v1G8z9uw38yZWXGnhFMEO5Vknyvsq1ekzVIbBBCJjkso+pH03UxR6BozshF7YEB1l
        C28cwWUeB0tdj6ziI+aBuj8t9036wL7NM4HZPnPAIC128hkk3l715B23PDn6lFKqq3KZ36HFWg+5I
        tYGxgkhHxioERF7YOR99lPcv7eEMvCCh3w3pgqeSCtHyfuzK1m5MbZuvUmfYN9C0ruu1TZuFyNL+t
        SmYa9dWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34652)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ohn0n-0004Ls-GD; Mon, 10 Oct 2022 08:15:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ohn0l-0001fj-9i; Mon, 10 Oct 2022 08:15:39 +0100
Date:   Mon, 10 Oct 2022 08:15:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 53/77] net: sfp: move quirk handling into
 sfp.c
Message-ID: <Y0PGm4OWNwc6VJuF@shell.armlinux.org.uk>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-53-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009220754.1214186-53-sashal@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:07:30PM -0400, Sasha Levin wrote:
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> 
> [ Upstream commit 23571c7b96437483d28a990c906cc81f5f66374e ]
> 
> We need to handle more quirks than just those which affect the link
> modes of the module. Move the quirk lookup into sfp.c, and pass the
> quirk to sfp-bus.c

NAK.

There is absolutely no point in stable picking up this commit. On its
own, it doesn't do anything beneficial. It isn't a fix for anything.
It isn't stable material.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
