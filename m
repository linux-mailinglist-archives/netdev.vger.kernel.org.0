Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2780450B139
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444604AbiDVHQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444672AbiDVHQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CAF51328;
        Fri, 22 Apr 2022 00:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD5DB82A97;
        Fri, 22 Apr 2022 07:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0732C385A0;
        Fri, 22 Apr 2022 07:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650611610;
        bh=2eP5N2am4/TObX0OiEiogWXKWvfr8XKlaOBXPQ079Jg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZKi7veBzeQJLN31agqjva9zjBCjEydINToeZWCJvlJZ1ivwGPyMAhDztg8spzo+iO
         kI4s9RHZuEqg4FceSlNiEnfh0sT8jFX8FgLDYsQbLks5Pp+VTBAN/mY5sbxXQaibwy
         diTKXcZxTM5Tc+Y2ohQG3O7LDwEQhMVJ4A5VN03Gspm8zEGHWQe4Fzx1Cd3QZMEz3c
         VwvPq77RwGFkRDgvbrf1+/ZbUdYQG0MKyvNWEIUZBCkxwGGoZTQFHrrUwoaUvmQz+g
         cT2A4a/KAegxLhPkN6QdUiJfuFL0/I0RZgJrZ+JnYMRc/Sigc/637GAF4mkYj7ItNG
         yvtnf+XY4cAog==
From:   Kalle Valo <kvalo@kernel.org>
To:     yunbo yu <yuyunbo519@gmail.com>
Cc:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] =?utf-8?B?bXQ3Nu+8mm10NzYwM++8mg==?= move
 spin_lock_bh() to spin_lock()
References: <20220422060723.424862-1-yuyunbo519@gmail.com>
        <87y1zxmysz.fsf@kernel.org>
        <CAD55h6Z0GfEMu25_1PXavRA9SGJ2zZC4-y=6Bo5+Fz=99J6_mg@mail.gmail.com>
Date:   Fri, 22 Apr 2022 10:13:24 +0300
In-Reply-To: <CAD55h6Z0GfEMu25_1PXavRA9SGJ2zZC4-y=6Bo5+Fz=99J6_mg@mail.gmail.com>
        (yunbo yu's message of "Fri, 22 Apr 2022 14:27:22 +0800")
Message-ID: <87o80tmvzf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

yunbo yu <yuyunbo519@gmail.com> writes:

> Thanks for the tip! I will make the patch v2

Another tip for you, please don't use HTML :)

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_send_html_mail

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
