Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6263F67DABD
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjA0A1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjA0A1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:27:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E90422D;
        Thu, 26 Jan 2023 16:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4tsT3/dH8/GvxCkoJ1Hrq2573zBWw14jX8XahqqhkXs=; b=jb9voXpfNEv7q8s+ZARwZ//4C+
        pWX9ZeeD363nsjjTWWcxk50UOO0LPdtz2EUiVwsIOwRw5gr3RsJv3k2R/YVgciXdghCvIaR7L6oid
        S+Fv4zP/64rAPI2h3IvHYudgJl/PjZwAKcqwBXqFQHPsL8h+maQ4xedxwWTXxuORsLjrBE+1HFta9
        7GISKkRpshMOx3DhE2R05N2eUnC6IUHaNfyV7G3qvY5M6atGkYp7ZYTtKUiqY1Wb6zR3L/2nKwFf4
        qohEapgYWvUwN0px0O7ZMw+/dCQdFLvPEv98pdZnogzSa3iH6xWKPgQLDvMitW4NHf9azXJLewNh5
        BPzycLRg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pLCap-00Czd1-Ok; Fri, 27 Jan 2023 00:27:47 +0000
Date:   Thu, 26 Jan 2023 16:27:47 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Nick Kossifidis <mickflemm@gmail.com>,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        junyuu@chromium.org, Kalle Valo <kvalo@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] wifi: ath11k: Use platform_get_irq() to get the
 interrupt
Message-ID: <Y9Mag0CmfhRKdmZD@bombadil.infradead.org>
References: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
 <Y9LODwJPQpPs32Ds@bombadil.infradead.org>
 <CAD=FV=WEQL+Kik9ZkvtzNKN+-ofZ=-g3OzyUnnJc7PWnRzLdEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WEQL+Kik9ZkvtzNKN+-ofZ=-g3OzyUnnJc7PWnRzLdEw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 04:14:42PM -0800, Doug Anderson wrote:
> > To that end. Why not write an SmPL Coccinelle grammer patch for this
> > and put it on scripts/coccinelle/api ? Then hunt / convert things which
> > will use DT as well and where this is actually useful / likely buggy.
> 
> That sounds like a great idea. ...but not something I'm going to do.

:*(

  Luis
