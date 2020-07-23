Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A808522A472
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbgGWBT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbgGWBT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:19:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9856C0619DC;
        Wed, 22 Jul 2020 18:19:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BBE6126B5A23;
        Wed, 22 Jul 2020 18:02:40 -0700 (PDT)
Date:   Wed, 22 Jul 2020 18:19:24 -0700 (PDT)
Message-Id: <20200722.181924.45073818927713516.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, dledford@redhat.com, jgg@ziepe.ca,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, kpsingh@chromium.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/15] qed, qede: improve chain API and add
 XDP_REDIRECT support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722221045.5436-1-alobakin@marvell.com>
References: <20200722221045.5436-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 18:02:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Thu, 23 Jul 2020 01:10:30 +0300

> This series adds missing XDP_REDIRECT case handling in QLogic Everest
> Ethernet driver with all necessary prerequisites and ops.
> QEDE Tx relies heavily on chain API, so make sure it is in its best
> at first.
> 
> v2 (from [1]):
>  - add missing includes to #003 to pass the build on Alpha;
>  - no functional changes.
> 
> [1] https://lore.kernel.org/netdev/20200722155349.747-1-alobakin@marvell.com/

Series applied, thank you.
