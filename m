Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3050B04C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444260AbiDVGPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiDVGP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:15:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8533250067;
        Thu, 21 Apr 2022 23:12:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFC6B82A8B;
        Fri, 22 Apr 2022 06:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8884BC385A0;
        Fri, 22 Apr 2022 06:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650607954;
        bh=sQ993ibhAeZKDcNyaBxUh8xxW2w0Mr0D59fXMweNxDo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MO2Y585mR5sjxallnGbTxLm7lumX8vaQRJ1VQ77iUu+P4Lv4T6D9/Ra2zZZXIZP4H
         /9kITjFvEp3MuTorG+KCGgZgqyuxJEs+mats6svXnewEo/I3CG6U5nybxQTqbc/6vT
         v7wn5/fR9gBsCVYQNW1ck7iOwRlVdKTvKMwPPwAOcTnMQx1qU3GWBBdPr0C/rTFEuZ
         VuX+91k4L/1K4/GgRe8wz2tsXi6HLDCSSFPdH+4eFodyOQGPWGXOIM58GFHMMH6FaX
         xjZY/NAo1Q1ElIgWRaoh8aK0ZSjnRbsXQKNBR0fkkC3OHmnuL15oqqjzT5UVYcMIIr
         Oq6UNsKnGi4ZA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Yunbo Yu <yuyunbo519@gmail.com>
Cc:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] =?utf-8?B?bXQ3Nu+8mm10NzYwM++8mg==?= move
 spin_lock_bh() to spin_lock()
References: <20220422060723.424862-1-yuyunbo519@gmail.com>
Date:   Fri, 22 Apr 2022 09:12:28 +0300
In-Reply-To: <20220422060723.424862-1-yuyunbo519@gmail.com> (Yunbo Yu's
        message of "Fri, 22 Apr 2022 14:07:23 +0800")
Message-ID: <87y1zxmysz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yunbo Yu <yuyunbo519@gmail.com> writes:

> It is unnecessary to call spin_lock_bh(), for you are already in a tasklet.
>
> Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>

Why do you use unicode character "=EF=BC=9A"[1] as colon in the title?
After all recent news about left-to-right trickery all special
characters make me suspicious.

https://www.fileformat.info/info/unicode/char/ff1a/index.htm

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
