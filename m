Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541956400F0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiLBHNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiLBHNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:13:33 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CFB70617;
        Thu,  1 Dec 2022 23:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1y/HNhY87C/cynIcRRBRIvjFTnd1b8AbWpP8wEmSPhw=; b=V2euY/KCjM6yGHXGW1uv8xA/Ow
        N/y9vuV/m4GnPxmVrHHQmtZuVyEMf7oVrga2i2eYUfUQC+wM4kNaXqr/+AwoBgDQvZfpGBev0fLqC
        jyt9A65qC5Fiyayp0TjPoJuvJVBTBydSteozTm1r0gHfMPO4XDjCasj1rHOkcbPLqnvnqWRePxFHg
        SuIOhBI3lS6gNAB84JtBxmL6hnF3VMuDt1R2LyB/gZqHFFaF2TH4WU7p88BVh8NVkoInOn0iI6T8A
        9nYtQ5HhU9W3m596c6A4twInZd9el5pcw3eMVsuIeBh5lwHJwM2KYc25D+SlxB6J1lYmeyXtkvUuF
        DG1bqzZg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1p10EW-008Ngh-1C;
        Fri, 02 Dec 2022 07:13:16 +0000
Date:   Fri, 2 Dec 2022 07:13:16 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] netfilter: initialize 'ret' variable
Message-ID: <Y4mljMYvNh7zHlOh@ZenIV>
References: <20221202070331.10865-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202070331.10865-1-liqiong@nfschina.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 03:03:31PM +0800, Li Qiong wrote:
> The 'ret' should need to be initialized to 0, in case
> return a uninitialized value.

Why is 0 the right value?  And which case would it be?
We clearly need to know that to figure out which return
value would be correct for it...
