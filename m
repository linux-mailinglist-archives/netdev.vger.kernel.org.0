Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC73B5A5129
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiH2QNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiH2QNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E469980B79;
        Mon, 29 Aug 2022 09:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B11611FB;
        Mon, 29 Aug 2022 16:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4ADC433D6;
        Mon, 29 Aug 2022 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661789578;
        bh=Nw63RUmmV9oOAyYtjgUdB1RioR2o2BogtW5u26EdnaM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MARGo79pqdI+NsJ3OCV7JMU1zbMMxXzhBuC3X/KEwPrR9aaVmHPNtXYGYjRPylXsx
         dNq3uYABC/LzudzMKGO3HRtOV0ttFmpsQMc2KXixziMxPZROvO5TIYYWal2evhendF
         DQYrZJwfp8Rx+CGMfFxFNHEQhtUDsEQwf/halyGdz5m7T1A5MreVxHI5ecj1RLFfaU
         DwNuhCh6LQ+fkW4UIcQ430vRcl4yhzaVG2lb28gVbGUdrjYVLV0ehUQ4H0fEMVwFBX
         ehDhhbdv/F/PrIer2o+aRIO0etdOqw1wT2JIm/OTXASv1hlVMZyA43oWi6VbZv/Bzn
         Z3yhYocXYfgBQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] wifi: cfg80211: remove redundant ret variable
References: <20220829111643.266866-1-cui.jinpeng2@zte.com.cn>
Date:   Mon, 29 Aug 2022 19:12:53 +0300
In-Reply-To: <20220829111643.266866-1-cui.jinpeng2@zte.com.cn> (cgel zte's
        message of "Mon, 29 Aug 2022 11:16:44 +0000")
Message-ID: <87sflfc9kq.fsf@kernel.org>
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
> Return value from cfg80211_rx_mgmt() directly instead of
> taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> ---
>  drivers/net/wireless/microchip/wilc1000/cfg80211.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

The title should be:

wifi: wilc1000: remove redundant ret variable

Please read our documentation:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
