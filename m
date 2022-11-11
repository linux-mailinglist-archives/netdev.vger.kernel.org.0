Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFE162571E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiKKJn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiKKJnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:43:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C580654E3;
        Fri, 11 Nov 2022 01:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10ED761F35;
        Fri, 11 Nov 2022 09:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DBEC433D6;
        Fri, 11 Nov 2022 09:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668159798;
        bh=y0TtEyRIvZzgELtryDangjyqsQeNR556Gzo1nV9xAGY=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=ZoCR77q9O2JH/K7lcXteR52OJ+MwSk7EMje/siIvxIiqOE7WWswWeuXYVDz2PuuTu
         Mg1bju67vJmjqvCDPaK/yriAtaa+EKlMiRHYJVa3/HiT9MxiffIbUjvXOpDq+ZjvDJ
         c0ejONcHOmsYxKELCf3gn+wLrVVSgeB0sQ3zzb7jlmYRN9yJZYaMUqjJXQXVheXyWW
         qbMLmg4QMMdXzOq1Br4RUY7RPiTO45HQrok0Ol/dzOQVuNu97KjLhwH7u6yQKOH4at
         eOYbu5vmhmY2rGs1xuDqOQJ7w9N1G/1ZpbnUUUKtmWf0rz4RGhFvqdPO58Bhsw+aqj
         rHxEctqPakQPA==
From:   Leon Romanovsky <leon@kernel.org>
To:     edumazet@google.com, Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        longli@linuxonhyperv.com, Dexuan Cui <decui@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, shiraz.saleem@intel.com,
        Paolo Abeni <pabeni@redhat.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Long Li <longli@microsoft.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
In-Reply-To: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
Subject: Re: (subset) [Patch v10 00/12] Introduce Microsoft Azure Network Adapter (MANA) RDMA driver
Message-Id: <166815978892.774427.7191291131508289685.b4-ty@kernel.org>
Date:   Fri, 11 Nov 2022 11:43:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Nov 2022 12:16:18 -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> This patchset implements a RDMA driver for Microsoft Azure Network
> Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary device
> to the Ethernet device.
> 
> The first 11 patches modify the MANA Ethernet driver to support RDMA driver.
> The last patch implementes the RDMA driver.
> 
> [...]

Applied, thanks!

[12/12] RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter
        https://git.kernel.org/rdma/rdma/c/0266a177631d4c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
