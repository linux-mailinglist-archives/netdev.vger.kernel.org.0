Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEC86B793F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjCMNnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCMNnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:43:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE7339BA1;
        Mon, 13 Mar 2023 06:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B7BF612C5;
        Mon, 13 Mar 2023 13:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D5AC433D2;
        Mon, 13 Mar 2023 13:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678715010;
        bh=PLQfFPy+Iw5Op8bdtfn7ENrUngfLUPWLiqLzLgGXt0c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WTTL/itEVCMfHOhhMc94fNLXYDl+nvYq/7yS/FqahZJHx+tAjHUKpjnTHx9NYx2+x
         aTn9Yck+LFVZabEikZMYQZ4ZtRyUlEwR/E7FRPkW9o9VA98TxfBi+FhedYbMdcwNKQ
         1RCKYfyCx6fAeNtnhjqHEQzH82Hs6KcM41Nd6fX+Q/qVWVo7Yu3PX5CnsIlNiWHRJ+
         S6Lekj5OZvZ2Nj5PIXqXc619X1vjAzR451T1epUe2JXu2cfdnUP26mHkvLaDzc0a5x
         bPiURyaQh/2ue8p5ZYy6A3xSN0Ump+YES4TX+qgBcPBcyZfmlqnS4lEqKhvOGMnfkT
         QxUNl/xvhU9Sw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8xxxu: mark Edimax EW-7811Un V2 as tested
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230305175932.719103-1-martin@kaiser.cx>
References: <20230305175932.719103-1-martin@kaiser.cx>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Martin Kaiser <martin@kaiser.cx>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167871500696.31347.4588985384577653508.kvalo@kernel.org>
Date:   Mon, 13 Mar 2023 13:43:28 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Kaiser <martin@kaiser.cx> wrote:

> The Edimax V2 (vid 0x7392, pid 0xb811) works well with the rtl8xxxu driver
> since rtl8188eu support has been added. Remove the untested flag for this
> device.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>

Patch applied to wireless-next.git, thanks.

df259fc12b36 wifi: rtl8xxxu: mark Edimax EW-7811Un V2 as tested

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230305175932.719103-1-martin@kaiser.cx/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

