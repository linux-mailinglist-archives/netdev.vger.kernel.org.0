Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F659652724
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiLTTi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiLTTiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:38:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9F810D1;
        Tue, 20 Dec 2022 11:38:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1515C61585;
        Tue, 20 Dec 2022 19:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13068C433EF;
        Tue, 20 Dec 2022 19:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671565103;
        bh=oOT3ARrLvll03d+kSmHrwqXzIDmQS/iM+t/VcCGIQpM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nHYuuUgT9cgr8RMs6+8zv1Elzmla2x8xW/5e34YG3sGX1oXJhhX+BKVHfoVW95P9V
         uZPvFYSznhaujhQNOnwJMi5G62Z8JQb1Hfmmb+pkFcOVlgVqSb+UBHZqyhb0KRqaoD
         oAydkA7Am3pqi9KRZFT4KbT+T73mgNfWuxY+y2KK0/oX20/ec+TargtCPi35JwAkFJ
         snG1jQmnFgji3bKo3dpaBSYB9vWTTC0yqVhXuGzRqoeuODsy+Lg7x489L8utqg1+bB
         5GcnAIGOZZY2Y9+Hn1exTF/uo4tFAbAq0AUJaxRAuih7H+ZS0iBeRx4TgASCYh6JYP
         p94ISDlpnuvDA==
Date:   Tue, 20 Dec 2022 11:38:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Gazzillo <paul@pgazz.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Suman Ghosh <sumang@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] octeontx2_pf: Select NET_DEVLINK when enabling
 OCTEONTX2_PF
Message-ID: <20221220113822.4efe142e@kernel.org>
In-Reply-To: <20221219171918.834772-1-paul@pgazz.com>
References: <20221219171918.834772-1-paul@pgazz.com>
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

On Mon, 19 Dec 2022 12:19:11 -0500 Paul Gazzillo wrote:
> When using COMPILE_TEST, the driver controlled by OCTEONTX2_PF does
> not select NET_DEVLINK while the related OCTEONTX2_AF driver does.
> This means that when OCTEONTX2_PF is enabled from a default
> configuration, linker errors will occur due to undefined references to
> code controlled by NET_DEVLINK.

This has been fixed a long time ago by 9cbc3367968d ("octeontx2-pf:
select CONFIG_NET_DEVLINK") no?
