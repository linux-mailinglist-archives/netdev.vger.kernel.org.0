Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7964F42F6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383813AbiDEUFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457544AbiDEQI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:08:59 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2921F25CD;
        Tue,  5 Apr 2022 09:07:01 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C6A571EC0518;
        Tue,  5 Apr 2022 18:06:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649174815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NIHZ+oWgHNxDPqo+kf4JAqld28hQkGONJlhfcuaM2A4=;
        b=YpyH3gE3vol361+JkMCGivTB3ISpKPRQux3pAYKUECfl0l6waGULLAo/1JAE9dDOTMQLcp
        3UrC221rE5FpMTmwHAN8IkzbdYBwjYcaDJ2C6HDBDyxNcT5bt+VAEp1IEMAQ29f3s2qRXT
        SpLbJXPjUOdJaa9FzRDSsBN4mKM5QA8=
Date:   Tue, 5 Apr 2022 18:06:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/11] brcmfmac: sdio: Fix undefined behavior due to
 shift overflowing the constant
Message-ID: <YkxpIQHKLXmGBwV1@zn.tnic>
References: <20220405151517.29753-1-bp@alien8.de>
 <20220405151517.29753-7-bp@alien8.de>
 <87y20jr1qt.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y20jr1qt.fsf@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 06:25:30PM +0300, Kalle Valo wrote:
> Via which tree is this going? I assume not the wireless tree, so:

Whoever picks it up.

> Acked-by: Kalle Valo <kvalo@kernel.org>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
