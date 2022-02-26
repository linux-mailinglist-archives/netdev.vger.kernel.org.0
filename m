Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE7D4C5537
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 11:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiBZKmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 05:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiBZKmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 05:42:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2391D290E5B;
        Sat, 26 Feb 2022 02:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5B8DB819F3;
        Sat, 26 Feb 2022 10:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC31C340E8;
        Sat, 26 Feb 2022 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645872107;
        bh=RFf42czOySTnAdGGfHvyOuXGvWEvEYYr8UHE78R9vog=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=P0W4jnf8r/RLrt1ldnx1/CA03k8Lx1amb+1I73vssyUOGe9D3AgBLhKC2FZ9oMlBX
         aEGNUopqHABz12o6bI8jGd1bCBl1bulYF2P7aetiKRwKten9aQKO4b7ImAiOhQUiBa
         xp8+BFvmx93f6lzNj2ovWEZ6MB+ttxeGBSvntZtolfEXKZ/04rf70YoSgGOMq/qR2k
         UYGJGmxeDWRS7bdlXWm85nSJgZm7HOv4Y/KGoh6EBw1eOAgF2FrcCkxJsaxt20c7c1
         4bEN1vk2M7MZsHDx0LTiLiPu4E4mzXNVg9czHv5v1yQgKmRe777Jpyn4J4V6s9zhCe
         11Gn2vhvaM7UQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
Date:   Sat, 26 Feb 2022 12:41:41 +0200
In-Reply-To: <20220226092142.10164-1-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Sat, 26 Feb 2022 10:21:41 +0100")
Message-ID: <871qzpucyi.fsf@kernel.org>
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

+ jakub

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> The firmware and the PDS files (= antenna configurations) are now a part of
> the linux-firmware repository.
>
> All the issues have been fixed in staging tree. I think we are ready to get
> out from the staging tree for the kernel 5.18.

[...]

>  rename Documentation/devicetree/bindings/{staging => }/net/wireless/silabs,wfx.yaml (98%)

I lost track, is this file acked by the DT maintainers now?

What I suggest is that we queue this for v5.19. After v5.18-rc1 is
released I could create an immutable branch containing this one commit.
Then I would merge the branch to wireless-next and Greg could merge it
to the staging tree, that way we would minimise the chance of conflicts
between trees.

Greg, what do you think? Would this work for you? IIRC we did the same
with wilc1000 back in 2020 and I recall it went without hiccups.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
