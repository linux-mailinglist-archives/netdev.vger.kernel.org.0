Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241696E94C5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbjDTMlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjDTMla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F67A9B;
        Thu, 20 Apr 2023 05:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AF156491B;
        Thu, 20 Apr 2023 12:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD85EC433D2;
        Thu, 20 Apr 2023 12:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681994471;
        bh=FnbU5aU2kPmfONLezidW5lL+BJIIhTMSu1fghJIMcXw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ndrYHVrEvU6V3DSezycbgxPO6axOY2QzjAyT9SnszgxJBMrkfwufuSmaHkJruDs/x
         5Hs7NQQRopVm2CiSGKRQHgD6sTt2jAIOXWf9kvMg7eLz6wecVNN3GRn3TrS199PYY0
         6Zj416Txzmh+Z73Ba7W3ay4O0ozDg92smM/Lm10kWOMZkCODWKqZzljLHqshqyLKlc
         837H2YaEv4rJXKxUnMt1X41oYoCPhjouX3u0DwkfO7k5hacL7QpDhYI0X68/Tvttsm
         6PKW1r9v+EO/A8XWTWbtDkwy+pob89m6HGQZwhVRMPi/d/L5zIb9+GryuC83CQaEAb
         X3BIsZzk4m/sw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw88: Update spelling in main.h
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230418-rtw88-starspell-v1-1-70e52a23979b@kernel.org>
References: <20230418-rtw88-starspell-v1-1-70e52a23979b@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168199446766.31131.11190261560392456303.kvalo@kernel.org>
Date:   Thu, 20 Apr 2023 12:41:09 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <horms@kernel.org> wrote:

> Update spelling in comments in main.h
> 
> Found by inspection.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

6c6d62ae8271 wifi: rtw88: Update spelling in main.h

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230418-rtw88-starspell-v1-1-70e52a23979b@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

