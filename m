Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FFE522643
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiEJV0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiEJV0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:26:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05317D3;
        Tue, 10 May 2022 14:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0806178B;
        Tue, 10 May 2022 21:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAAFC385CD;
        Tue, 10 May 2022 21:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652217968;
        bh=kR2kpr/WthoIHNv/CMjDoYh09YdTh0O5cNq+3yPSmP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GBX1NGtj8+fZSAQU+zwr0peTmOEVQ78ODOb3Wddpp7aNGpjggHfepUfk6+Nzrm2a/
         4Mb5YfAjDAXSJbQ+s95159HCT5EMsN01iONNmvHtL5QZdw2woEEamTn2S322glxmub
         UusdklfhDjjriBLJ/xbJFUsdrCie6t5oZCoHdwOR/SiZp4ajxO9QMWAaVZkWg+7vnG
         n4EPDUpFbnKaC1a+hyyujBMtwYISNrdhodogQOKP5B5315uwxIm4lxaMe+UySXQkPU
         heKBoimsFsohAPxifQJnp0o0EAJZMZ+75l5x01H0s4cmf3MgK9rolX7PpiS6YvqGcY
         JPJ0gu3Ji1TjQ==
Date:   Tue, 10 May 2022 14:26:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <20220510142606.34d83121@kernel.org>
In-Reply-To: <20220510094014.68440-1-nbd@nbd.name>
References: <20220510094014.68440-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 11:40:13 +0200 Felix Fietkau wrote:
> Padding for transmitted packets needs to account for the special tag.
> With not enough padding, garbage bytes are inserted by the switch at the
> end of small packets.
> 
> Fixes: 5cd8985a1909 ("net-next: dsa: add Mediatek tag RX/TX handler")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

You should answer all questions and address or dispute all feedback.
