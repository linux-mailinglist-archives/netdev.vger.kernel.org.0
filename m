Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C1D4C781D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiB1SlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbiB1Sku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1649727FC6;
        Mon, 28 Feb 2022 10:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD57B81626;
        Mon, 28 Feb 2022 18:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA87EC340E7;
        Mon, 28 Feb 2022 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646073208;
        bh=qnhOLndpwyxqYNZOfegFu0pdYxM1cOFB+jY42I57//o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=syESYL3Jt6NpQjmHn17iKwE0JD9rNTPFhThYH48t1pn/AQT+bexJipHLRtKoDNWED
         Fn+aNJfXJLWO8aqGzSUTCW4XB6DfN/H7Os8AZgq9x4uuqA19lA1bzgbrf5aZ/N/iur
         i64SSizWD0EGyBkB0S2oHZuwFlZZEsSmE3LrO1F8yVMu4Lnb0L+/77IjmUJqt89eKp
         XVls2A/I4bxeqZeeQYiAFFsvupFHwf1zQmp9Izxd6XB1tNZ+luMytBVzRbZl0K4iDx
         HTsAOn/DbMqtnIMlXeI5+cdTYsNigUmzgn+WnLV8T9dBd4l4C15HH+/dn65ocPialp
         9uLfyOkCY6WIA==
Date:   Mon, 28 Feb 2022 10:33:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lena Wang <lena.wang@mediatek.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        matthias.bgg@gmail.com, wsd_upstream@mediatek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hao.lin@mediatek.com, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net:fix up skbs delta_truesize in UDP GRO frag_list
Message-ID: <20220228103326.681e905a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <0b026eb24a0348d32b6dda94950f6517f8304456.camel@redhat.com>
References: <1645769353-7171-1-git-send-email-lena.wang@mediatek.com>
        <1645769353-7171-2-git-send-email-lena.wang@mediatek.com>
        <0b026eb24a0348d32b6dda94950f6517f8304456.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 09:46:34 +0100 Paolo Abeni wrote:
> I *think* posting a v2 could be the easier way to handle the above
> glitches. If you do so (no changes to the patch body), please retain my
> ack.

Yup, please send a v2.
