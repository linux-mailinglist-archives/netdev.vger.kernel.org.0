Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01749619504
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiKDLAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiKDLAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:00:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB70F2C126;
        Fri,  4 Nov 2022 04:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE4562159;
        Fri,  4 Nov 2022 11:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2CFC433D7;
        Fri,  4 Nov 2022 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559626;
        bh=/MGecyQmJdqPsReJBSYYANujGfYMhCik3e8q0K1i5p4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=rZDLQ8p/FknkmIXRK1vRJjz6MsTjqH71aZVu+TDZUbvp3uLCM/Ym82+78mxKOMcSB
         9iRVJAZ/hnDYwVeczGhu9Vi13ZEp7i8Wyjofo7bbW5eDPuR3RQVWVz1OK20Hfy/mhA
         9mEmiXRLmaXGucT5u3/VvVBUudO1d71Lk23tYVhHbUi3ADbGz5oaCWi1NqxGjAkBPt
         2AjVy6aSzWK5FayQ++S9/Jc1s4L8QnDCG/sPmGJrv9e5VJeSTaqlAy9ruAjlEs+s7N
         8dM46hkeN8kA4UWlaIEVgw01fEAbfqO775+4IKTf+P19XRLQe4daFaAonGtEl/dxId
         B2/b9X9GauWBQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtlwifi: rtl8192ee: remove static variable stop_report_cnt
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221031155637.871164-1-colin.i.king@gmail.com>
References: <20221031155637.871164-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166755962299.3283.14022973939524774032.kvalo@kernel.org>
Date:   Fri,  4 Nov 2022 11:00:24 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Variable stop_report_cnt is being set or incremented but is never
> being used for anything meaningful. The variable and code relating
> to it's use is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

cdeee8540952 wifi: rtlwifi: rtl8192ee: remove static variable stop_report_cnt

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221031155637.871164-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

