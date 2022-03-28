Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA53D4E9DA3
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244607AbiC1Rh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244603AbiC1RhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:37:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF0D220FB
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 10:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58B7ACE1412
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 17:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D26C340F0;
        Mon, 28 Mar 2022 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648488939;
        bh=Sn8Bitx7H5TN9eizCUOoZIWCpwckY6qGGDu7hxX3utQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UoSI6/ErT3yLqhGHdh2usx7kHVVxWIP6hLlRuP8n0Bq5ZRgJ+WkmF23sMeWMcAZkn
         paRZY+7kd63ZIG8eLd1ZHgLWMSEhvRbD9Y8pjrULiOfEZkPNT6vCz3xZMH9gEe6jm4
         mxFKuNa2s8v4Jwt+BUupO0hq8V+P6bAJesk0gQYrkqo4RPjzORwv3mOed0upYdW38b
         Zl3XKBa8bOIzLJBbRxEkTimcYQo0ileDtVGpGdL6Zo0TcbSCBRFqf3KcvZ61SYpIpg
         Xt2M8f0HnnMwm79eL0t/riysnpMqAxJTqUKP1xvFLAIl/8w4hLBiv8l6ORZmkrJFDn
         U2jWBmONNhXPQ==
Date:   Mon, 28 Mar 2022 10:35:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "wangjie (L)" <wangjie125@huawei.com>
Cc:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RFCv2 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
Message-ID: <20220328103538.3bdf79d2@kernel.org>
In-Reply-To: <3bc30bb8-f318-3e15-e61f-b430375b3739@huawei.com>
References: <20220326085102.14111-1-wangjie125@huawei.com>
        <20220326085102.14111-2-wangjie125@huawei.com>
        <20220326125042.216c9054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3bc30bb8-f318-3e15-e61f-b430375b3739@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Mar 2022 11:05:26 +0800 wangjie (L) wrote:
> > This can only be 0 and 1, right? Set a policy to to that effect please.
> >  
> I will use NLA_POLICY_MAX(NLA_U8, 1), is this ok?

Yes, that looks right!
