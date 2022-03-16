Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2099B4DB4D2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiCPP3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347360AbiCPP3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69F51EAE8;
        Wed, 16 Mar 2022 08:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 620986154E;
        Wed, 16 Mar 2022 15:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C6BC340EC;
        Wed, 16 Mar 2022 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647444505;
        bh=5rbztnXVsrPksaO1G7Gp7Ki/1G4oYU03f3llLlYU4fQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Yr93PbHj8a/yKJrbZJKXDrn8ftjsRpej4pOn+ABJuBKwn2cnE8Hq/rOkSxi6D5CiR
         z7w8kweUvo1hZzp6YZzLn4QPT3DIFI+RFi7XzcnCxorb+JS6Eqf/nk8UXr8H93MzIE
         uDm/gWbzheOwBQmImPdVvXUW8M1ybdMj/C0mGgpCRFT3QDK9bnxkvziEJM5AdfzOWu
         ttluVhZnzyP34v1YFOnrf+kgXqZCyPs9/t/GGWMVNMzciNw4VhavsytmJD23QaujiH
         m7txBK8JfNgHpiKOWBKsW/v+2NNp9xw50zoCJIuhrdPMJl8NGkXWAIlV2RoDOXGRYV
         n3EgO3UIk1o7g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: make read-only array wmm_oui static const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220311225610.10895-1-colin.i.king@gmail.com>
References: <20220311225610.10895-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164744450133.16413.10583656975501578777.kvalo@kernel.org>
Date:   Wed, 16 Mar 2022 15:28:23 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Don't populate the read-only array wmm_oui on the stack but
> instead make it static const. Also makes the object code a little
> smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Patch applied to wireless-next.git, thanks.

e7d1fc0b5ff2 mwifiex: make read-only array wmm_oui static const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220311225610.10895-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

