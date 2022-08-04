Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD5589D7F
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 16:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbiHDOba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 10:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiHDOb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 10:31:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818CA39BAE
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 07:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=19ZoLFTQJ7nQqUfacrenw48qk72g8qs04lvudaH0dm8=; b=YUe68NhWmGXLFZfdzcc+Q1y5mb
        vTNM3LE0/zS+mvIWf8ckvT1USEqzo19bv99sP/NTip55aSp92xxyz12V8Xo+waic1LrKITako+oL6
        vhTjrHs10UydDX4hpWbvJxea6dtYV0lTkzXYwl7001bKMgugC6p0dw+8WJ60M5L/yu4s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJbsg-00CQez-NA; Thu, 04 Aug 2022 16:31:22 +0200
Date:   Thu, 4 Aug 2022 16:31:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
Subject: Re: [RFC] r8152: pass through needs to be singular
Message-ID: <YuvYOveNyi5vYCMH@lunn.ch>
References: <20220728191851.30402-1-oneukum@suse.com>
 <YuMJhAuZVVZtl9VZ@lunn.ch>
 <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
 <YuknNESeYxCjcPrD@lunn.ch>
 <d8e45a94-e16a-1152-afad-2ebb15b48d67@suse.com>
 <YuvIqCBAcZTMh0xV@lunn.ch>
 <3017563c-0085-ae88-1ef0-40d1f89ef4c5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3017563c-0085-ae88-1ef0-40d1f89ef4c5@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am sorry, but at some point a bug is a bug, even if some people like
> it.

So i guess we go with what we said last time. We can merge a change,
but if anybody reports a regression, it will be reverted. And if i
remember correctly, we did revert some stuff in this area.

But i think it would be better to consider RTL8153-BND, RTL8153-BD and
RTL8153-AD as poisoned, and make new designs with a different device.

	   Andrew
