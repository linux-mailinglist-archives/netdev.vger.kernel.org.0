Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F586531287
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbiEWOr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237289AbiEWOr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D38A554AA;
        Mon, 23 May 2022 07:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD52C61209;
        Mon, 23 May 2022 14:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27412C34118;
        Mon, 23 May 2022 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653317245;
        bh=kFfYyaivZqNk5FB1RoBokpKV613iugm2ZacsHlK4ltQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LaeNdRvZCyRAkd5NOTIS4Xc/rBdSTRhrPpZJe3lVChIFX7UGqqSmg8H2gB6O5x0zO
         xZiT390r1n09f0UhjdewiKqjhCdrugedW0xO5ecxrO/896nkFwUSJ2Q4C79wZ/XZHM
         GUlK0ip1ZTHgh5s1mUnPFg4jcqg5eebNLFFDiOqazMQ3aAQEIE2It0sQikTOU93EGu
         GcZHDRJaq+a08ga3K10gjTORSb00TvWlvuiN2V1N5eI+9cJqeytGGJfQmsWzD0nulA
         a3HZotVtuFZV1F8G7WRJHwZ6kbayvmLhu4ph8RyRU2wXERnUVj3wQJ1/AApS1Y8cRn
         4FdLweaILYkdQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nt9L8-0006gy-Up; Mon, 23 May 2022 16:47:23 +0200
Date:   Mon, 23 May 2022 16:47:22 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: fix IRQ affinity warning on shutdown
Message-ID: <YoueemdqqRCwtk0z@hovoldconsulting.com>
References: <20220523143258.24818-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523143258.24818-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 04:32:58PM +0200, Johan Hovold wrote:
> Make sure to clear the IRQ affinity hint also on shutdown to avoid
> triggering a WARN_ON_ONCE() in __free_irq() when stopping MHI while
> using a single MSI vector.

Forgot the tested-on tag, sorry.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

> Fixes: e94b07493da3 ("ath11k: Set IRQ affinity to CPU0 in case of one MSI vector")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Let me know if I should resend.

Johan
