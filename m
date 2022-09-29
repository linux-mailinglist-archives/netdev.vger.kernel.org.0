Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8565EFA12
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbiI2QSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiI2QSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:18:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E1A1E05C8;
        Thu, 29 Sep 2022 09:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45B6F618F2;
        Thu, 29 Sep 2022 16:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D132C433C1;
        Thu, 29 Sep 2022 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664468321;
        bh=J88gvTONrgsvrQzQWXVVY5JzTHd2WXT/mWs0AYnntww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fy/5mJKDsXp7Lg5YsP7PwQXhwGe/SBAHWjWlPGB/gVN6ppi8VxNzWWatDyKvH4yff
         rjw6DY0YRohla5KF92i7r5F0OhVvq2aIIrxCsz0Hn7bSBTDpZHE4djizhtS1+epoxg
         qg+A/XazNHjGbWzowBcUfzqAnrtcXP8+J2ydd/d7Dan2uEPmSStv7FCygefinDrlqL
         tJIc5yXTorlhzP8AILMxvAl0zUpTsN/AvlYGDz3pAA+Qsx5+rtaDMvoRh3Y+l3VEJm
         4Y3m3b97OhWi0IrjCsN7KO3LS1nxmM8m2P6jKhQ8MRXBIaw9c8uEGWQKMA+Wsu+zMa
         EYqgNyCnlcU9A==
Date:   Thu, 29 Sep 2022 09:18:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20220929091840.33126dc6@kernel.org>
In-Reply-To: <20220928221514.27350-1-yepeilin.cs@gmail.com>
References: <20220928221514.27350-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 15:15:14 -0700 Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> and ->saved_data_ready() call sites.  For example:

 warning: 'const' type qualifier on return type has no effect [-Wignored-qualifiers]
                 const void (*data_ready)(struct sock *)),

Please double check W=1 build before reposting
