Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EAD4E4637
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 19:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiCVSon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 14:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239759AbiCVSol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 14:44:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4F824F0B
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 11:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1D05B81D4D
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48C7C340EC;
        Tue, 22 Mar 2022 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647974590;
        bh=CrT9a+nwCKMZ8NohGVL2fsktgFNdTdfrhd4qgAQRcvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xw9kAYUy7mXpQdyzoctzilS8Jxhl/mwAogOo/GXOshG4gaoFwiS/GB+YYouCWHgaA
         TLmx4LlUTkhoumZ6IUYYsB+QyUnVMwdLc4e/JwRi4rp3XIq25QTMxO/2Qt+1MlSu4b
         RP7m3oLQeHK5D6rss/zTPd92byWvb8rcqHNOhUGg2fIKyr8zYxiAaBtQgNMA2BJIt2
         PA40znvSnyEi85Pb8wuKHDp2+dAEcs9XrBzRLRrcN81Ha43wJBpbo4W2dqcw9C1zxx
         JVu4j+MVQaqXyfdsaZaZhzFjz8G4ffBA3rGS/tsAaoiFbImybgaetlVA3++WXBZrHp
         WzNfJ6ltGP8SQ==
Date:   Tue, 22 Mar 2022 11:43:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     hongbin wang <wh_bin@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] p6_tunnel: Remove duplicate assignments
Message-ID: <20220322114237.0ff57ae8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322074525.136560-1-wh_bin@126.com>
References: <20220322074525.136560-1-wh_bin@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Mar 2022 15:45:25 +0800 hongbin wang wrote:
> there is a same action when the variable is initialized

net-next is closed, please resend in 2 weeks.
