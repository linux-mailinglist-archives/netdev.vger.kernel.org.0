Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A784E49CD
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 00:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiCVXzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 19:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiCVXzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 19:55:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C62B5D649;
        Tue, 22 Mar 2022 16:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1743661241;
        Tue, 22 Mar 2022 23:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DDFC340EC;
        Tue, 22 Mar 2022 23:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647993263;
        bh=IfeQKWQHKmMsVpDpghMQ2MPXJZHCcqpXEy3KM2Js+0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aFwkQsCmbYaS/pZhJX8lMaoDQWspKbXfEylq+p+drhKDIUUj8geC5Fp9U89I7pMJT
         7Sau9Qz9GOO/4EaqRPQQT1lOq/xZzTuofABv29I1VSd+8tx9bWIvsrpIkBVPQIyjYY
         WZ9zV4g5LYz5bgaCsjoAqxngiy227l83tY1lf7Y0NRYg/h84/6Eods9jTCoQI45eFx
         +VsEOfWGMTa8K0Eu9GBepY0KJ4ojbfE6ERnWBUpSY7jLcgsIrk7OSAUf7OsiW6Ldpg
         vP3LumImnHpScKbu4b5/88wVhRN/SJcDEYx37vvqveY6OScI1N68yG7Z6VXy92xG1F
         hgRt73cQkw2oA==
Date:   Tue, 22 Mar 2022 16:54:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, pabeni@redhat.com, rostedt@goodmis.org,
        mingo@redhat.com, xeb@mail.ru, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, alobakin@pm.me, flyingpeng@tencent.com,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        benbjiang@tencent.com
Subject: Re: [PATCH net-next v4 1/4] net: sock: introduce
 sock_queue_rcv_skb_reason()
Message-ID: <20220322165421.00dd3443@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322025220.190568-2-imagedong@tencent.com>
References: <20220322025220.190568-1-imagedong@tencent.com>
        <20220322025220.190568-2-imagedong@tencent.com>
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

On Tue, 22 Mar 2022 10:52:17 +0800 menglong8.dong@gmail.com wrote:
>  include/net/sock.h |  9 ++++++++-
>  net/core/sock.c    | 30 ++++++++++++++++++++++++------

The merge window has started, and we'll be sending our changes from
net-next to Linus soon. Let's defer these patches after 5.18-rc1 is 
cut and net-next opens up again.
