Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D22B5AAA80
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiIBIrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbiIBIqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:46:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C63E2FFFB;
        Fri,  2 Sep 2022 01:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC49762156;
        Fri,  2 Sep 2022 08:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C730DC433D7;
        Fri,  2 Sep 2022 08:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662108401;
        bh=0A7WWESMqIZD9mylc1dnG6NGyuh1874ApHc3sUTvw20=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ILbO/IiLte49oEs+fL3Ng7qg48I0jm4Kk8bzfAsMPGNm9REGWFF9gtxO4G0ipVElC
         7nNlug6wHz9Ks8PRbzIrcx/aRT6ziNMa5/6miPmR83EpQLlw2ioU5mfMWOU9SW3/V/
         HPzY4pmdg8tplJQDYPOvBguAmfX1EKu43CyqG8JEeJ5AgMZPI53E1VOt0W2VmHQ1ap
         eu6zYlnNlGc2fbo2Sh5zISyJHFv/UWJH5biWJO/hOFskuX9sdEDZsuSTflShbqpHPP
         6+eG3DwaqWaBOEJq9c6J9cicjOXYmxX5Wg+mZ/mg8SOKVG4f7QT5uFFqftH81LwvkQ
         +VGCqf/D3MdPQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 linux-next] wifi: wilc1000: remove redundant ret
 variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220830105505.287564-1-cui.jinpeng2@zte.com.cn>
References: <20220830105505.287564-1-cui.jinpeng2@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166210839707.24345.16121764644715977509.kvalo@kernel.org>
Date:   Fri,  2 Sep 2022 08:46:38 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> Return value from cfg80211_rx_mgmt() directly instead of
> taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Patch applied to wireless-next.git, thanks.

1dc13236ef91 wifi: wilc1000: remove redundant ret variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220830105505.287564-1-cui.jinpeng2@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

