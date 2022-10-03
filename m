Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451CE5F3A0F
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJCXwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJCXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:52:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F18922B06;
        Mon,  3 Oct 2022 16:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8742CE0F80;
        Mon,  3 Oct 2022 23:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEFFC433D6;
        Mon,  3 Oct 2022 23:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841118;
        bh=zQgDrYEmO1A4O7v6c6eHX9+QZMgsYW5T833nre2SJ68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fLN7m403aSrqYAbPYrOGp4NUT21gM4feLXJ6nOsnL6y489Sq6w2HauvSGrXo3PViL
         MkVE4z6eAnfISP2Oqoz3ZyHQaekFj5gDPA3UVESVb3NVxXY7jcBgg4KctY5vpIjMA3
         l39l3MNwHOzjLbhK69PbGlpby/7OMaqK74G3vt+9nkgk2GWFUd7IXozeabgdkObFUo
         OhQTHgmzPIeqGQ1kvk+GNgWuqksCDK2dkyJXYjvxUMhW/5z0M1dbhXxw2b8Va1JCfM
         JgeIzKK8oQNc3jZ+CLOLK8WowW0ECF+7BEBhlAaU8e/r2r9DxRWcAEvKaUyvYZxHbf
         1F6tbHeOEnSTw==
Date:   Mon, 3 Oct 2022 16:51:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH v2 1/1] net: fec: using page pool to manage RX buffers
Message-ID: <20221003165157.2bbdae26@kernel.org>
In-Reply-To: <20220930204427.1299077-1-shenwei.wang@nxp.com>
References: <20220930204427.1299077-1-shenwei.wang@nxp.com>
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

On Fri, 30 Sep 2022 15:44:27 -0500 Shenwei Wang wrote:
> This patch optimizes the RX buffer management by using the page
> pool. The purpose for this change is to prepare for the following
> XDP support. The current driver uses one frame per page for easy
> management.

I believe this has been applied as:

commit 95698ff6177b ("net: fec: using page pool to manage RX buffers")

to net-next. Thanks!
