Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9745514227
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 08:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354384AbiD2GJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 02:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354396AbiD2GJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 02:09:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1226C286C7;
        Thu, 28 Apr 2022 23:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C03C3B832EF;
        Fri, 29 Apr 2022 06:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35074C385A4;
        Fri, 29 Apr 2022 06:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651212343;
        bh=6NFSMXO5E6qeOEGGAd6wS7D3yMyfVIo1QyU5W2JK9xU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Lg0llTUi/tf4vqzwPiZYXdsWE6KB+oibgGY4T58queRBYMAAldPrnYwlFgOk4J1ER
         br1omhpiYvuLRs9dL+zDjJ4XPcytForau1azB3OvjGu8w6A/WBTBBeWKZ8YQO62fQ/
         Xhyj6nw2gquhBOCXkUZOUW2NmVpVwv3bStAYXK03phMQnHbpTlHGKGR1Rw+Zgkeh9O
         WEs5cNGl00BgaaYVbVqTkax7mPOnOaG3r89qn/MlS9eySHqS+HnJiBGvVKvlZ+Tm9R
         5rFMcADsp53dMeB5LKCRQkhdOgQkKOaF8/lPU2oqYkHbbk/QgVTiT2yeKagrb+7xcM
         g9tAxedlBwf/A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: hif_usb: simplify if-if to if-else
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220424094441.104937-1-wanjiabing@vivo.com>
References: <20220424094441.104937-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net,
        Wan Jiabing <wanjiabing@vivo.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165121233679.2322.16112763867236758166.kvalo@kernel.org>
Date:   Fri, 29 Apr 2022 06:05:41 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wan Jiabing <wanjiabing@vivo.com> wrote:

> Use if and else instead of if(A) and if (!A).
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

2950833f10cf ath9k: hif_usb: simplify if-if to if-else

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220424094441.104937-1-wanjiabing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

