Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D084C41C9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiBYJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiBYJx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:53:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42967223105;
        Fri, 25 Feb 2022 01:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F03E2B82DB9;
        Fri, 25 Feb 2022 09:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72EFC340E7;
        Fri, 25 Feb 2022 09:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645782772;
        bh=hYA7KWGKoBNn5QaBIFE/J7kPeB1K1COT+gghkxGEXuQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DttH25CsmYomkOWEuGxg6k4v43VyQPyzDPpzOGG/1AfkPhJHlZFcDjUrUfuOf8nro
         QnjsvmExvygAUJs8ymowkofewaYd7nk0rymSE9PKp7GbyhxOcv9O3kRROsv4JAHf4j
         nfdV4sDLq8RusuPj1cqOHpFh+pYmlz4QPXM2rLZK3x3FJ/Eh5lFd2bZb1CD8/DfREh
         KkWngRD6VZHpkWRdQVavgpW9hwnidCSmfEvTj+TDYHCoqzgSEuPUq8+UflPdrYSxAB
         s2g99ArCznuwQPKW8O7ba2nq2sM6CZd4jRME0fHjhjnHuY/KlF27EopVHCwt2cUkLf
         gXxWDqngWjoHA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH v22 1/2] nl80211: Add LC placeholder band definition to nl80211_band
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20220224182042.132466-1-srini.raju@purelifi.com>
        <20220224182042.132466-2-srini.raju@purelifi.com>
Date:   Fri, 25 Feb 2022 11:52:46 +0200
In-Reply-To: <20220224182042.132466-2-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Thu, 24 Feb 2022 18:20:06 +0000")
Message-ID: <87a6eftgr5.fsf@kernel.org>
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

Srinivasan Raju <srini.raju@purelifi.com> writes:

> Define LC band which is a draft under IEEE 802.11 bb
> Current NL80211_BAND_LC is a placeholder band
> The band will be redefined as IEEE 802.11 bb progresses
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

No need to submit this patch anymore, Johannes has already applied it:

https://git.kernel.org/linus/63fa04266629

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
