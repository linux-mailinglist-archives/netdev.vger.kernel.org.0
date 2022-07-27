Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB4D58274C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiG0NBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiG0NBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:01:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4A9286F9;
        Wed, 27 Jul 2022 06:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4E9BB8214D;
        Wed, 27 Jul 2022 13:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32741C433D6;
        Wed, 27 Jul 2022 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926893;
        bh=SkDHQ9SQETDOeh+pczaKelNR1ThNFsZ7UZG/AOnw1sk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L9Os3GH+U2j0lNiiHnTDKVLG/OwWuO7Z5QrLNIZQfvw/lzBI/kbkS8RszlbkaECyH
         fKdhGDfka2WcXNvH/sfcVcviR1e/dHBrJPguOh0kHmjugoT9gIt9f2zhPAtIOaWml5
         Am3xx0vnRX4xGNI+vDCAa0zplbF6xjbjE7BmJyayq9Fqia+mGz97iZ6bx/n5atxk8B
         rkcR3X3dRWZb7t07o04OvOPi7pbLbpicZKLQmirZrJ3SmP/wdQhKSLViJ6AQV9xC12
         lAg23oVgHqzJRGenxlcqUxe1UTWNC44QdiugWz7pILuIiAb3NqGXpfFI1A3jLviJeP
         GB+Q50UtKTCZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 -next] wifi: plfxlc: Use eth_zero_addr() to assign zero
 address
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220701082935.110924-1-xuqiang36@huawei.com>
References: <20220701082935.110924-1-xuqiang36@huawei.com>
To:     Xu Qiang <xuqiang36@huawei.com>
Cc:     <srini.raju@purelifi.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xuqiang36@huawei.com>,
        <rui.xiang@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892688903.11639.11094170820169474561.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 13:01:31 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xu Qiang <xuqiang36@huawei.com> wrote:

> Using eth_zero_addr() to assign zero address instead of memset().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Xu Qiang <xuqiang36@huawei.com>

Patch applied to wireless-next.git, thanks.

70c898d4bad1 wifi: plfxlc: Use eth_zero_addr() to assign zero address

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220701082935.110924-1-xuqiang36@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

