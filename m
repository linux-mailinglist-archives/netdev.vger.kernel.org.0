Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1816068AC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJTTKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJTTKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:10:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479591EA54A;
        Thu, 20 Oct 2022 12:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D818161B4A;
        Thu, 20 Oct 2022 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14FCC433D6;
        Thu, 20 Oct 2022 19:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666293048;
        bh=TfMfMB4r5AcA/VOzO1008S1j+Nb6+A2DEu+mlP3xJlU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rSU5YobpaloCf8sYMx8FcDfFj/hBXeLUD7i6GPRK/xFYPI6ETgO8P0Ub9M9AgyZpx
         vtMWdiOgoLOqYWytZK/a66HG3wTRctQgGhROQxKdpL7gX+g93zpc+YMwoyViEEULAg
         Pjf/izSMxIFzs2HXyrAUM6mrBitrqqYcL0ZTMLj/C64aJhWMX269kAw5yBlIEheR1S
         TR/qM0DWiEC9SAg/vqEDuPhxjQWrXjFkB7+FGvkFmmaaLJEbYi67cZfXWMXnguw8fz
         Ub2CPOsURNWtwSEFdSQHxo12KeXb5MSdYOoTEEpE7AYrukmNi/iiyTAvkDvVAqFMh6
         jKJqmhlIFAfPQ==
Date:   Thu, 20 Oct 2022 12:10:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <20221020121046.6b6b25a7@kernel.org>
In-Reply-To: <20221020144431.126124-1-linux@fw-web.de>
References: <20221020144431.126124-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 16:44:31 +0200 Frank Wunderlich wrote:
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> 
> Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")

nit, the correct formatting of tags would be:

From: Alexander Couzens <lynxis@fe80.eu>

Implement mtk_pcs_ops for the SGMII pcs to read the current state
of the hardware.

Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
