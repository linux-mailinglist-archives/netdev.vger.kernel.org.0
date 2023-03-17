Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F44E6BDDB3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCQAgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQAgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:36:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58332128B;
        Thu, 16 Mar 2023 17:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 024B3CE1DB0;
        Fri, 17 Mar 2023 00:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFE5C4339B;
        Fri, 17 Mar 2023 00:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013396;
        bh=farPD0m4KEMBd1LL+WH5wAB8N+V1n8TnGNRZWoKtdvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kazijIP4JHOR48ffWeIQ0Oqcb2tYSeu8WEZalURWPTpVs8ai64cX6J89NfcGgdNgC
         /rRAftiCCRqHe7J5HzsiUazFky65od0pMP+MlliQ+5zZukun/KG6TLZDlF/GvZvnEh
         kaGV5S76vq2G3k8PKg/V+OziTAY3RYvdZ1nGvAm+hsmK3TvcaPntEB/y1LE+y8G2E2
         WfEtW2uQP8kWF/D914aehdxZmXideE/MA/ZChjX2Xtme+L+L+Va6ofXvPYA49n6G5p
         RZIoREftWGY9PQD8VXsg3ZHm5xRDyqnSReeHgc4V+hm+vzu3Pp0jHYKCjtyckCnYPe
         4ElmLr9bknKiA==
Date:   Thu, 16 Mar 2023 17:36:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] i825xx: sni_82596: use eth_hw_addr_set()
Message-ID: <20230316173635.049ee5f4@kernel.org>
In-Reply-To: <ZBIKcx6/77aePZUE@localhost.localdomain>
References: <20230315134117.79511-1-tsbogend@alpha.franken.de>
        <ZBIKcx6/77aePZUE@localhost.localdomain>
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

On Wed, 15 Mar 2023 19:12:03 +0100 Michal Kubiak wrote:
> The fix looks fine. Good catch!
> I would only suggest to add more description why it needed to be
> changed.
> (The current version of the commit message only contains information what
> was done, but it is quite obvious by looking at the code).

Let me make an exception and add that info myself.. since I broke this
:)
