Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565FD6C8A1D
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjCYCJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjCYCJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D49C16A;
        Fri, 24 Mar 2023 19:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B547C62C9B;
        Sat, 25 Mar 2023 02:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C434EC433D2;
        Sat, 25 Mar 2023 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710179;
        bh=CSHGlWPcjZ1EJ54tx6XFABSsuyyW0FQgsLgbFME25Fw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SK7bNm0exZh3BtJ/0vc/6aSNMm4Fj74UAW+7zz4XFUdPplxnE8RopCprJPB2cVs4N
         qI4zwq8Qm3VyPPSD5I3N0jwbf8/vFJFmvK6Mzy8wiGfKJlQR7Ac0bMRaC4Az+1L+N7
         CI0kBcBCGVufEk74D6tfY/6Qfmbx+crDIXu5GH5vsMT5ggOOx3Mha/u1+APKa/Pfeo
         T7CxkCUgMbbBtHcmpDio0DBz9U6rTl3uq6g6VN8ENnUU1zD5hKCTtxwiStNyNGADYM
         +VwktLTnSfx0ubgEeQ5NbOAieR0QTZMhLRoBBM1GqCxRqO1I6xsU+YdtaKUfuGJJxm
         mgCIESr7XwVZg==
Date:   Fri, 24 Mar 2023 19:09:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fman: Add myself as a reviewer
Message-ID: <20230324190937.17f83c4d@kernel.org>
In-Reply-To: <20230323145957.2999211-1-sean.anderson@seco.com>
References: <20230323145957.2999211-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 10:59:57 -0400 Sean Anderson wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9faef5784c03..c304714aff32 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8216,6 +8216,7 @@ F:	drivers/net/ethernet/freescale/dpaa
>  
>  FREESCALE QORIQ DPAA FMAN DRIVER
>  M:	Madalin Bucur <madalin.bucur@nxp.com>
> +R:	Sean Anderson <sean.anderson@seco.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/fsl-fman.txt

Madalin? Ack? Should we read into your silence?
