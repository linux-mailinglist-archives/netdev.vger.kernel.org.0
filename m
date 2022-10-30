Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06243612B83
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 17:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJ3QGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 12:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ3QGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 12:06:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D1FB7DA
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 09:06:07 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 79AD768AA6; Sun, 30 Oct 2022 17:06:03 +0100 (CET)
Date:   Sun, 30 Oct 2022 17:06:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
Subject: Re: [PATCH v7 03/23] net/tls: export get_netdev_for_sock
Message-ID: <20221030160603.GA10248@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com> <20221025135958.6242-4-aaptel@nvidia.com> <20221025161258.GC26372@lst.de> <253fsfazij7.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <253fsfazij7.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 06:55:24PM +0300, Aurelien Aptel wrote:
> Hi Christoph,
> 
> Christoph Hellwig <hch@lst.de> writes:
> > Any reason to not just fold netdev_sk_get_lowest_dev into
> > get_netdev_for_sock?
> 
> Thanks, we will use this.
> Could I add you as Suggested-by?

Sure.
