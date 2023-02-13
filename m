Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D155F694A74
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjBMPKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBMPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:10:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8788C558D;
        Mon, 13 Feb 2023 07:10:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25C426111D;
        Mon, 13 Feb 2023 15:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74299C433D2;
        Mon, 13 Feb 2023 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676301042;
        bh=DbelEs3Yzk8KGr6CqAiw2wK2ac7px2sdZn6CkCl4wWw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WR7Gid7OqxMxE9IYk2V1QpOsAXnPM6mXfIuF6UWwuOZ3RZkjM6gkkXBlOEX8pzk84
         8HzMSUbvtCVpjTJOm1kKPLXiwTMQkp7aRdCGDEz+CjA5fhGG1JEIRnk6RBYII0sIuU
         /WF/V3gTi1X8xS7R1769BjAHyAY16OzzgBkutOBz6hitZmBhKPWZq7Ap0x4BlPfaY9
         /qYr28EYYCPvDpuTZWRIcD/gFxsZsS65zUz0tD1Izs7ot/9jEFGYOxXOiSKv3LWdbC
         4mlRhHvi5S/pBeA2SP2IKgzYchU5Rd8hM/SvEUWMIURk2sGUZ8ujnI9uBpVZtWWKVa
         0Mh9Mh+dObUFQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2 v2] iwl4965: Add missing check for
 create_singlethread_workqueue
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230209010748.45454-1-jiasheng@iscas.ac.cn>
References: <20230209010748.45454-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stf_xl@wp.pl, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630103649.12830.14676459865773332025.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:10:40 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> Add the check for the return value of the create_singlethread_workqueue
> in order to avoid NULL pointer dereference.
> 
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

A tip for future submissions, when you submit a new version please submit all
patches from the patchset as v2. It's difficult to pick patches with different
versions.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230209010748.45454-1-jiasheng@iscas.ac.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

