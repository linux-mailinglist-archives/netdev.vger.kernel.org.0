Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2C66AB648
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 07:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCFGUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 01:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCFGUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 01:20:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EF6DBDD;
        Sun,  5 Mar 2023 22:20:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA57B80A2B;
        Mon,  6 Mar 2023 06:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EA1C433EF;
        Mon,  6 Mar 2023 06:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678083602;
        bh=KZtogKGKkj1H/GgguglrfFEy5HX9+7oy1EFbF+t9yFE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=t0NiP42VdQYMcMVy19UK0rw1/Z/wXBq06hBm1c99wFdiIPfRnGjrvNqRMBUwFNdNM
         KGJtEM0gIhd4k71PhQuEz2oL5JtuBzpbOOcit5ilUQ25N2oI+85S6o6zdngwTgQbMo
         7jlF7L6e9ySKNPVXk/yZGtlwlXnpYZaMmdwGJj5fD2wCAKIlQJq8Gef0gsmvyFCRqO
         4kSsuXHf1qi2vDj9oILbtQVKza1ssj1zZUTrJkrWWtWs7EOfK4Ng3zTBdBDgAJ3yeX
         jf4udkFqXkmRaeDfElKfpSK9Zg7RRhgGgQrkmlOW7R5jBzR5WxcrVI3xRtKyFFXNzD
         ecoasoZPaiv5w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bastian Germann <bage@debian.org>
Cc:     toke@toke.dk, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
In-Reply-To: <20230305210245.9831-1-bage@debian.org> (Bastian Germann's
        message of "Sun, 5 Mar 2023 22:02:43 +0100")
References: <20230305210245.9831-1-bage@debian.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 06 Mar 2023 08:19:55 +0200
Message-ID: <871qm2qu44.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bastian Germann <bage@debian.org> writes:

> Drop a wrongly claimed USB ID.
>
> Bastian Germann (1):
>   wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
>
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 2 --
>  1 file changed, 2 deletions(-)

I can't find the actual patch anywhere, I only see the cover letter:

https://lore.kernel.org/all/20230305210245.9831-1-bage@debian.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
