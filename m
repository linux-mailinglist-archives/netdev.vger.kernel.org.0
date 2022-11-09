Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7486862327B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiKISdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKISdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:33:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F377125EC;
        Wed,  9 Nov 2022 10:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CED61C61;
        Wed,  9 Nov 2022 18:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83C9C433D7;
        Wed,  9 Nov 2022 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668018808;
        bh=adakfXPD3xra37+C3JuUmmuu/s4R54ybHPOnov/3ReI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGw0+QzVA22MDEGqM+WzfWqt8Xeq1unnYm+DZaKQ30hgg7+mMhgQDnpCeA8PalKxQ
         Po77IAGR6cteXaJvd/BP0fLRVrU3lEcOu2C+6+/Gwj1Pyrn8czUZXtEIz15Hfm0jc+
         isBGdhyYcje1EJcBEkgyBIx0mHs2ny7OpFXyxknen+iYKASpapV0YhuNzreZ4lTAvz
         H3WTIwASsS3O5rrUQPhZELyT6oWOXf592jthlGV3yIv4Uf6VwLWwi0aidhnPXoTXCX
         SzUcRx5jXL0ZyvB2R01T0+l9ji8Bxi+sBGoO/HdJ/Dz/utUUg/ItV6Sw+5nBFFewRF
         ZPJlGBtsOxoDQ==
Date:   Wed, 9 Nov 2022 20:33:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     rama nichanamatlu <rama.nichanamatlu@oracle.com>
Cc:     Rohit Nair <rohit.sajan.kumar@oracle.com>, jgg@ziepe.ca,
        saeedm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        manjunath.b.patil@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: Re: [External] : Re: [PATCH 1/1] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Message-ID: <Y2vydHwL3waJeaHw@unreal>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
 <Y0UYml07lb1I38MQ@unreal>
 <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
 <Y1p4OEIWNObQCDoG@unreal>
 <fdb9f874-1998-5270-4360-61c74c34294d@oracle.com>
 <Y2f21JKWkQg8KtyK@unreal>
 <f3a56720-4df4-6b17-bfdf-4385dc27a2c0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3a56720-4df4-6b17-bfdf-4385dc27a2c0@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 04:24:48PM -0600, rama nichanamatlu wrote:
> in-line.

<...>

> > The thing is that "vendor" failed to explain internally if this debug
> > code is useful. Like I said, extremely rare debug code shouldn't be part
> > of main data path.
> > 
> > Thanks
> 
> thank you very much for you insights into the relevance of the patch. before
> we close this topic, do want to ask on this.  what is the expectation of the
> nic hardware when it signatures / checksum's an eqe or cqe ?
> 
> if it not to be verified by the receiver host for what ever reasons, then
> why even do the checksum computation on the hardware ? 

mlx5 data sheet has more than 3000 pages in it. Not everything there is needed now.

Thanks
