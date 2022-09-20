Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76325BEDE8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiITThk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiITTh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD67276456;
        Tue, 20 Sep 2022 12:37:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F37061726;
        Tue, 20 Sep 2022 19:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF80C433D6;
        Tue, 20 Sep 2022 19:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663702646;
        bh=2r3NaHKh1FzT6RHSAyhCbSMWPn2w2ERtZgFmz0RQcU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0FGgQBDFOKTTJOTg0uBqRSqR3/+Tav/OKmbMUiKepb0c+icMLnX8Dffs2d97ocz9
         sW4Qclm53ZqaoEhDxB7WfVwKOznJ2EbY7JVzHht6DxAL2OmFA16tRQST7QV3rj1wNz
         Lw9SPIOAr7navex6ifAMz0O41JYSKYImEuf/nOO/g8+RXiWMCu3cBaWQ1xx91gJFlb
         DDDn0QAeogMUCE7yzuHL5s6w4WYjVpWGvb6k+LEPfwpwFslyaScRlEuabMpCQ/KFTD
         L2JleDJPB2KXuzPJpdckob/yJM+v3f4aCMBbcXgqGqGGZXRRvutk1vDoHlPy5srOyQ
         FkTvSw5OgXSlw==
Date:   Tue, 20 Sep 2022 12:37:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH net-next 03/13] sunhme: forward the error code from
 pci_enable_device()
Message-ID: <20220920123725.79f2dc57@kernel.org>
In-Reply-To: <20220918232626.1601885-4-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
        <20220918232626.1601885-4-seanga2@gmail.com>
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

On Sun, 18 Sep 2022 19:26:16 -0400 Sean Anderson wrote:
> +	err = pci_enable_device(pdev);
>  
> -	if (pci_enable_device(pdev))
> +	if (err)

No empty lines between call and retval check
