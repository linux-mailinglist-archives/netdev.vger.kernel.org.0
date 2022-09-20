Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6DF5BEDF0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiITTj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiITTjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:39:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21F41902E;
        Tue, 20 Sep 2022 12:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5392B82CA4;
        Tue, 20 Sep 2022 19:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12763C433D6;
        Tue, 20 Sep 2022 19:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663702791;
        bh=YQIXccfGpQXhEAgfFoxmWRLEJgkA00rmXQJ3IaBMmko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LVyJ3UzBFvrS/aKhX3U7UWnFiBmhEpU/eYmw3kwmHevnwoXx4vAu6XW1+WmaqKNkS
         zJoqZTkpgWVjUAIDQKWV7k163KEPC4WpWlPDLTHtDx5Bp/mgzYvM0EdVQ+aYLiezQ5
         WyWhj4oH8KpFa9oubYji60TNS3bOvvQkMpPYWMvFsISabhtTZwDhns0NaF6lfIZpg3
         mEHW0jGrE1gVCNvSk+YZ5WTuHjIbjTE7LgHldSGD4V7eYATsp2ec2gQ11xCNcZG571
         HuF60ynUJ4Wv5aFOBBLZR/HJtXZPcVyK3NdL4UCmEvqDKeQEVV/DvxQLF++K8aILgx
         61AKwgHYIHwiQ==
Date:   Tue, 20 Sep 2022 12:39:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Nick Bowler <nbowler@draconx.ca>
Subject: Re: [PATCH] net: sunhme: Fix packet reception for len <
 RX_COPY_THRESHOLD
Message-ID: <20220920123950.37a83870@kernel.org>
In-Reply-To: <eb3ea4f2-3f12-3040-7faa-3d4fe44f68e5@gmail.com>
References: <20220918215534.1529108-1-seanga2@gmail.com>
        <YyjTa1qtt7kPqEaZ@lunn.ch>
        <ab2ce38a-313b-7e87-aaf5-cfc2b6e0cb28@gmail.com>
        <Yymz9K6QXi860AWh@lunn.ch>
        <eb3ea4f2-3f12-3040-7faa-3d4fe44f68e5@gmail.com>
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

On Tue, 20 Sep 2022 09:23:09 -0400 Sean Anderson wrote:
> On 9/20/22 08:37, Andrew Lunn wrote:
> >> Well, the driver was added before git was started...
> >>
> >> I suppose I could blame 1da177e4c3f4 ("Linux-2.6.12-rc2"), but maybe I
> >> should just CC the stable list?  
> > 
> > That is a valid commit to use. It is unlikely anybody will backport it
> > that far, but it does give the machinery a trigger it does need
> > backporting.
>
> OK, well then this
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Please post a v2 with the changes suggested by Andrew folded in.
