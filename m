Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54E35A5132
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiH2QN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiH2QN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:13:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E5C97B3E;
        Mon, 29 Aug 2022 09:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F6BB81113;
        Mon, 29 Aug 2022 16:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C469C433C1;
        Mon, 29 Aug 2022 16:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661789633;
        bh=jB+qQohjknJOWJBicwCen+HSfZrsrewVjd2SxvN6B/w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hTiOoawq1gtNMmzvuJ2nNFpIJ1HBSYFFtdlmKC+11/J+VmKk644Vxussnmsi27ZMj
         09dgPBchuvwREZ9GTpbzvDQXksYdFNW9cM7Wq+2cCaKfKvqkkyECL1WnEznHUmuyPR
         LbMd1WijqF4/LtJTI2OdfO1KSjmjmHlHL9VGH0t4B2ciRsevbZMkM/YyJodCvW1PI6
         SFyM7gzBUurFZcmNIHnoiOBBX52e8lQrY0fAqmLVUWKv0K2b/QVhFCAS4wTvdsUNrG
         a47XzY3FFpxQTVjBhwT0L3MfQD938N7FqDjFkAtsQCmk8yAakKiD5lGw2FNC/ak2YS
         tshXbwnUewsEw==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, a.fatoum@pengutronix.de,
        quic_vjakkam@quicinc.com, loic.poulain@linaro.org,
        hzamani.cs91@gmail.com, hdegoede@redhat.com, smoch@web.de,
        prestwoj@gmail.com, cui.jinpeng2@zte.com.cn,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] wifi: cfg80211: remove redundant err variable
References: <20220829115516.267647-1-cui.jinpeng2@zte.com.cn>
Date:   Mon, 29 Aug 2022 19:13:45 +0300
In-Reply-To: <20220829115516.267647-1-cui.jinpeng2@zte.com.cn> (cgel zte's
        message of "Mon, 29 Aug 2022 11:55:16 +0000")
Message-ID: <87ler7c9ja.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>
> Return value from brcmf_fil_iovar_data_set() and
> brcmf_config_ap_mgmt_ie() directly instead of
> taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

The title should be:

wifi: brcmfmac: remove redundant err variable

Please read our documentation:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
