Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9D67D4FC
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjAZTB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjAZTBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:01:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BACF69B22;
        Thu, 26 Jan 2023 11:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n6OTwXbqkvWKaUiJIlak8SUyFhFuvaI0XUfB/XFglaY=; b=0yivqRtx8oA+bkclJMFmY7I0Z2
        LcN/cI0mJpodqwqtpjSO5x61IvhuqVioDgtHeDtVl5IaC9s9YLk1yRk3JriGWnM/k5dIV8RK6sf27
        PfLYz/ZXqq8JHoSw5+3uRoIy6dMdM2rlzce699zEZ9CNrWyLffGYmge4vbLrfquJcjk4MNwoIA+F2
        6qHIQlfP8sXmUR8+/y5USlXmM5T1KIY1dvY0ZgjbfEkRfUmf/MlR4uWKtjzqSnufa/iUNATHVqnjw
        NCCG30zQnq4Vh0N41UQERypl1mhigEo4AsE8PljYAoTJ8hXgLRg6HXVF+vX1eHcq/b+KITanherFQ
        q+cC7f/A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pL7V9-00CEvd-Pq; Thu, 26 Jan 2023 19:01:35 +0000
Date:   Thu, 26 Jan 2023 11:01:35 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Douglas Anderson <dianders@chromium.org>
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
Message-ID: <Y9LODwJPQpPs32Ds@bombadil.infradead.org>
References: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
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

On Tue, Jan 24, 2023 at 11:01:00AM -0800, Douglas Anderson wrote:
> For the same reasons talked about in commit 9503a1fc123d ("ath9k: Use
> platform_get_irq() to get the interrupt"), we should be using
> platform_get_irq() in ath11k. Let's make the switch.

The commit log is rather weak, it is better to re-state what the commit
log in 9503a1fc123d states as it is stronger, and very clear.

To that end. Why not write an SmPL Coccinelle grammer patch for this
and put it on scripts/coccinelle/api ? Then hunt / convert things which
will use DT as well and where this is actually useful / likely buggy.

  Luis
