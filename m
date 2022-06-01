Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7692753AA5C
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354750AbiFAPmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 11:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245526AbiFAPmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 11:42:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD78112635
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 08:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F03614EE
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 15:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F27C385B8;
        Wed,  1 Jun 2022 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654098137;
        bh=drBwPN1oGmAsQ6G3pwMNGwwVt8wVBWjblWRffXiZ/B8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N1kQoPScyzrkbL2e7BJxu1KR5z2ebV3bgo/+XUkYt/u32zyHcr6GYDzwt2IjD8gQz
         ozDbEsOg1RZYUzZW9PFRjNnkqlOGg1xx0Kgab0Rt/sVZaPlhQ2F1y3B0vvxtNmQlLl
         5JkcxJ5RWXmwOZ2PSmtjrx5XZF7TQ0Yqmpsz7ViNOkeppjyopO6J/QgfG3nDIIu4os
         8iXlO5d8i5tciJ6bgVgulrfHuQQME2CO9AX8LYaIvmIhj91Ut+D1CQ4Zhbd601uxo2
         r440VdfsV01KgLv+P/AxrkJtXjfmjgFsR5OvRTRHp6lmDGTA8UJnCKpmhmfnW7IZ26
         N52KFetCkLRBw==
Date:   Wed, 1 Jun 2022 08:42:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Message-ID: <20220601084216.0eb98e32@kernel.org>
In-Reply-To: <b050eb9a-b627-4efb-8095-d3be52ca3264@nvidia.com>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
        <20220530111745.7679b8c4@kernel.org>
        <20220531121829.01d02463@kernel.org>
        <b050eb9a-b627-4efb-8095-d3be52ca3264@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jun 2022 11:58:22 +0300 Maxim Mikityanskiy wrote:
> > For device offload only. Allow sendfile() data to be transmitted directly
> > to the NIC without making an in-kernel copy. This allows true zero-copy
> > behavior when device offload is enabled.  
> 
> I suggest mentioning the purpose of this optimization: a huge 
> performance boost of up to 2.4 times compared to non-zerocopy device 
> offload. See the performance numbers from my commit message:

That reads like and ad to me.
