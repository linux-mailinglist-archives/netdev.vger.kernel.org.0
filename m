Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36BC6628B6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 15:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjAIOm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 09:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjAIOm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 09:42:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6061AA07;
        Mon,  9 Jan 2023 06:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A67A61168;
        Mon,  9 Jan 2023 14:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D93C433D2;
        Mon,  9 Jan 2023 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673275376;
        bh=vyhQ5Kv0jvomCtF2wA1v2cv86vfLJ4UcKD5du8lOS44=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cUs47DELJbya0V+D1JRWcGin6AUwqy93PoasktkKfpnLZbriVm4P/ZxqgcZw9a4Mi
         HT1mdDbx+UhZP9RsyrmaCCjAYFXtYyGLUl/KTRmzZuUVw3Q3JqHUHicn/tqmQdZlw+
         5RJTMcyxKssxJCBgbGPmaC2yWTTVhmvy0NfrsosTmMrkKke7vbDIYz7AbNYwOKrkh+
         wbHGKvoKG8iEEgHTDehxMpumffCkgcpTelnBQkE0LEKYxCg3L0nJU7IsD422rWhXN1
         hFJxVwScDbRyEN4NBipWYnSMDEWjEqrO0l8ktNb0za5Cl7PDj1DTmJwQRXfmJHTkJ0
         faHJ7vg7FxbJg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     gregory.greenman@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        luciano.coelho@intel.com, johannes.berg@intel.com,
        shaul.triebitz@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: Add missing check for alloc_ordered_workqueue
References: <20230104100059.24987-1-jiasheng@iscas.ac.cn>
Date:   Mon, 09 Jan 2023 16:42:48 +0200
In-Reply-To: <20230104100059.24987-1-jiasheng@iscas.ac.cn> (Jiasheng Jiang's
        message of "Wed, 4 Jan 2023 18:00:59 +0800")
Message-ID: <87358jixav.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
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

Jiasheng Jiang <jiasheng@iscas.ac.cn> writes:

> Add check for the return value of alloc_ordered_workqueue since it may
> return NULL pointer.
>
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Your address for linux-wireless was wrong, I manually fixed it (".or" ->
".org"). But patchwork didn't see this patch now so please resubmit as
v2 with the correct list address.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
