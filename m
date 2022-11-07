Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0120361F4A7
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 14:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiKGNzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 08:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiKGNzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 08:55:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D281CFCC;
        Mon,  7 Nov 2022 05:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CF42B811B8;
        Mon,  7 Nov 2022 13:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B33C433C1;
        Mon,  7 Nov 2022 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667829300;
        bh=YmHzZ1me/URX0OErpUUTrYtcYN0+M7i/wabiD4jO+zY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=paW98QAcHGYOPQmIhc64P4PCa5Sd8UrU7apa81sMI2p3j4IB1/m5Kn07yeFTYaR2Y
         07LZzTNfjivsKCo40T4Dpj9xORW+XR1jcm5Fghz9xBVLWWJ264M7Yu3pUD63MP8cdV
         8Ij40TVjHSDoKG8vTf8jiWTFRgD7jqtcqPI04lxGzC8aEnevsSZbTD8iD0DnrLzbwH
         Amcs1WyhO+vEkkRhkbuRnQPyOUGE1PxL1YmCIuSVCWZfcIJ9QYXXSHz3JADDaEwanV
         iVkjjIzHf1SG2F8lPYioBOs9mowphmSzVFcv/hXpsGYnXQ6h4A9/EFsTh+Pi5wbB/L
         Dco7mCfq9GxEw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
In-Reply-To: <7a3b6d5c-1d73-1d31-434f-00703c250dd6@denx.de> (Marek Vasut's
        message of "Mon, 7 Nov 2022 14:23:37 +0100")
References: <20221104163339.227432-1-marex@denx.de>
        <87o7tjszyg.fsf@kernel.org>
        <7a3b6d5c-1d73-1d31-434f-00703c250dd6@denx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 07 Nov 2022 15:54:52 +0200
Message-ID: <877d06g98z.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> writes:

>> BTW did you test this on a real device?
>
> Yes, SDIO RS9116 on next-20221104 and 5.10.153 .

Very good, thanks.

> What prompts this question ?

I get too much "fixes" which have been nowhere near real hardware and
can break the driver instead of fixing anything, especially syzbot
patches have been notorious. So I have become cautious.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
