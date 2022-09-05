Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1A25AD875
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiIERjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiIERjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F1E5E668;
        Mon,  5 Sep 2022 10:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 839B3B81249;
        Mon,  5 Sep 2022 17:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51080C433C1;
        Mon,  5 Sep 2022 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662399550;
        bh=bhhgPvsJtCUUhyHykUww1DaoTODPijRFChVMx+eyiGc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aO4eRPZ6vzn2XpTMbugWTW9izQTqHDkv0nAGHxYW13i16mAb68vgf5hDC5In1179v
         iyEp6tr9zwCszrxRfMncxh98f94csg683jh8m3Werj31RXpdpTvnlTM8eAhf2yaqBY
         YcFb25kOXcQSKHbsuYCHqy0StLNoi8EgNcXSLDrtBWBLTXkQi0LMBP79WJVuKIqS4p
         xdAKCxv6YRoilC45QjekUProin71ad96HRTtpCTr7aGyMngsFqiIY9HkFUM/UxeNfV
         e7YF68bEo+wV3YW+OimiRV/7Re0jr4fND2BkXQjE5oQH4qKVTdLbVcaejwH1qwwkZF
         wz0hQ7gF21olw==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] iwlwifi: don't spam logs with NSS>2 messages
References: <20220905172246.105383-1-Jason@zx2c4.com>
Date:   Mon, 05 Sep 2022 20:39:07 +0300
In-Reply-To: <20220905172246.105383-1-Jason@zx2c4.com> (Jason A. Donenfeld's
        message of "Mon, 5 Sep 2022 19:22:46 +0200")
Message-ID: <87h71ld8lg.fsf@kernel.org>
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

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> I get a log line like this every 4 seconds when connected to my AP:
>
> [15650.221468] iwlwifi 0000:09:00.0: Got NSS = 4 - trimming to 2
>
> Looking at the code, this seems to be related to a hardware limitation,
> and there's nothing to be done. In an effort to keep my dmesg
> manageable, downgrade this error to "debug" rather than "info".
>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Gregory, can I take this directly to wireless tree for v6.0?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
