Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61434EDDC7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiCaPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbiCaPrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8061D3058;
        Thu, 31 Mar 2022 08:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0804B61AEC;
        Thu, 31 Mar 2022 15:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE29C340ED;
        Thu, 31 Mar 2022 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648741345;
        bh=d5JdhH3yN12WVXkZXYHPe8a2JDmcK/JrFzo/HkUz+Ck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u2lIXJWh61CBIAIrA7RRqx+9nVNO58CNJm/um/0aKKuvA64Kdsmxhq7MOIPkIQrcK
         5/fXuuaJYJRQJ1MY5SnczJGB36YuQYE6JwNekPzjLhOCj6uqojLfq1w31J7shxVl7Y
         PARQkiD9R3y8ouZvnHFPcsUqNh9eJmv9HC09JIARC5PBqxRXsDP08XPpitPIruKH5D
         jY1M7dnEcqM/RVRe0IuWJuqldfmtxpsjhA1GdmgGBc2bcGIWfGtZ9/oTGSDLt1vc4+
         fC74fqnLW+w2RPlYBgZ2bX0VlhJ3220IaC2PA5Bp8pp7SK7xqQnu+lWhAXpnYW5LBW
         60UCv0vH8jdGQ==
Date:   Thu, 31 Mar 2022 08:42:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net 0/n] pull-request: can 2022-03-31
Message-ID: <20220331084223.5d145b23@kernel.org>
In-Reply-To: <20220331084634.869744-1-mkl@pengutronix.de>
References: <20220331084634.869744-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 10:46:26 +0200 Marc Kleine-Budde wrote:
> The first patch is by Oliver Hartkopp and fixes MSG_PEEK feature in
> the CAN ISOTP protocol (broken in net-next for v5.18 only).
> 
> Tom Rix's patch for the mcp251xfd driver fixes the propagation of an
> error value in case of an error.
> 
> A patch by me for the m_can driver fixes a use-after-free in the xmit
> handler for m_can IP cores v3.0.x.
> 
> Hangyu Hua contributes 3 patches fixing the same double free in the
> error path of the xmit handler in the ems_usb, usb_8dev and mcba_usb
> USB CAN driver.
> 
> Pavel Skripkin contributes a patch for the mcba_usb driver to properly
> check the endpoint type.
> 
> The last patch is by me and fixes a mem leak in the gs_usb, which was
> introduced in net-next for v5.18.

I think patchwork did not like the "0/n" in the subject :(
