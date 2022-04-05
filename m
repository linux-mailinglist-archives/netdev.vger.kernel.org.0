Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8288E4F5425
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356749AbiDFE1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242853AbiDEUTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:19:53 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395D866605;
        Tue,  5 Apr 2022 12:59:59 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 02F261EC0502;
        Tue,  5 Apr 2022 21:59:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649188794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SvIU4eZcn93NftxXsNKHCqdzPzPfwZZgm8Wxx1MOMuw=;
        b=ERFM06xopatlGBGjisa0wjOdN0qLVRBqPKrPMnxeoDehohByrncOvmrmUK6A4PmNO7Ez5m
        wFOT6A8rq5EnhmsBat3Qv1yScS9n9rdDtyCOYOPiptL56MJeA8O5oinRrLTLtoD36ewkCF
        ETPMHWvzo68dXPESkf4I9nzAIyAqb5U=
Date:   Tue, 5 Apr 2022 21:59:52 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 03/11] bnx2x: Fix undefined behavior due to shift
 overflowing the constant
Message-ID: <YkyfuMAaghi+gev9@zn.tnic>
References: <20220405151517.29753-1-bp@alien8.de>
 <20220405151517.29753-4-bp@alien8.de>
 <20220405125342.1f4d0a1a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220405125342.1f4d0a1a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 12:53:42PM -0700, Jakub Kicinski wrote:
> I think this patch did not make it to netdev patchwork.
> Could you resend (as a non-series patch - drop the 03/11
> from the subject, that way build bot will not consider
> it a partial/broken posting)? Thanks!

Yeah, will give vger some time as it sounds like it is clogged at the
moment. Which would explain why my patches haven't appeared in multiple
patchworks, if they depend on vger, that is...

I'll do what you suggest tomorrow if it doesn't appear by then.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
