Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C107C69D618
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 23:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjBTWC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 17:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbjBTWCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 17:02:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5AE222F5;
        Mon, 20 Feb 2023 14:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB83DB80DCB;
        Mon, 20 Feb 2023 22:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C2AC433D2;
        Mon, 20 Feb 2023 22:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676930523;
        bh=fQRoiH/vfT+YhxHdQBo3IjRJtBv45VLnzgTpqQ2GMnY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ktZMNexkwbQT7SSP4qmLKo8Uvlirzq4lFcth9KK5SGKvDKCcvZDxPyAWicz0jb+qp
         2Xs1MYD2YHUHUvHDDxuYSrbKfvvz0baUTb/A51kevnKuvdUw/HMTT8UspZVONCOAEK
         M1vEVzt/sJ7RZ5/w/SEKo02Z9sdhqRT3C7TmNhWX6ScUwa/8+bPuva1AXSLLtb9YDl
         Zezp7qA6+jG2r2Ml1zOA6ENCb1Qe+T1yM80YYHmjnEVhdhypUJd+SzJkJThC8+qaBr
         KMxMrLjO51IH3JsJUtWJ2FKSTY0nglSR9vbNaVvvgjvk+lXVSBHFooFxgFrjEpQp4P
         qrI242eJkucqA==
Date:   Mon, 20 Feb 2023 14:02:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Janne Grunau <j@jannau.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/4] dt-bindings: net: Add network-class.yaml schema
Message-ID: <20230220140201.20450889@kernel.org>
In-Reply-To: <CAL_Jsq+2_gQzAjAZQVux1GOff5ocdSz5qQMhjRzvtyD+9C-TQQ@mail.gmail.com>
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
        <20230220114016.71628270@kernel.org>
        <CAL_Jsq+2_gQzAjAZQVux1GOff5ocdSz5qQMhjRzvtyD+9C-TQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Feb 2023 15:49:44 -0600 Rob Herring wrote:
> > Rob, Krzysztof - is this one on your todo list? It's been hanging
> > around in my queue, I'm worried I missed some related conversation.  
> 
> Andrew suggested changes on 1 and 2 which seem reasonable to me.

Ah, thank you! I see them in lore but not in my MUA.
