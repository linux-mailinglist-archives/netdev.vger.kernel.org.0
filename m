Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86E1694AE6
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBMPSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBMPSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:18:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ADFBDF8;
        Mon, 13 Feb 2023 07:17:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 406E761019;
        Mon, 13 Feb 2023 15:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B68C433D2;
        Mon, 13 Feb 2023 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676301473;
        bh=oml7470oOX/sY/toOd/Id6/w/WWGphDk2Vi8SoyWhNo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ImvnsMDc7QRFyp/5n/Ec1VyeW/D1vDcyf5JlRpFX4tYx1Dr+cuXGdWavi1DU74aIl
         5NWM82IQXWS80kcfir4dNLT8sbpzh8BNKkaqEsRggpFaHTLSvkIaIWAhHTjxQwuAYV
         e0ejBuqcHu2hofUL3Aj/9NYxVR4E6CCUJ9UKRAvC+XE0fQErF/RAtFKsVfHccWX1w2
         z7kWJD5bgfe5Gu3LmoYwyG0hfM1dzEeI41hJ+9wTpMUtl76/Cf7CK082bH6X7D2tgW
         Ilck2aFJrZEK0GDpBo8IE9qrY7Y/EDxUoe3AUV1YGwUSTmW19JoxL5dQtfOpFh5ill
         CXD+LLLmSuaUg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [1/2,v2] wifi: iwl4965: Add missing check for
 create_singlethread_workqueue()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230209010748.45454-1-jiasheng@iscas.ac.cn>
References: <20230209010748.45454-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stf_xl@wp.pl, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630146962.12830.1942758843937046067.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:17:51 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> Add the check for the return value of the create_singlethread_workqueue()
> in order to avoid NULL pointer dereference.
> 
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

26e6775f7551 wifi: iwl4965: Add missing check for create_singlethread_workqueue()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230209010748.45454-1-jiasheng@iscas.ac.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

