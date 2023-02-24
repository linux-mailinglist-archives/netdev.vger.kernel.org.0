Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31B6A2264
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBXTlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXTlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:41:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640DC61EF7
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6DF0B81D05
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 19:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D513C433EF;
        Fri, 24 Feb 2023 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677267660;
        bh=KmXIc42AYpw+udQMKFDgDAjRIXQTyiBVIgNBXGrst8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PCISu0R+Fl/u4UWNacOULrdUAkKRXzw8Tn8Npaj/TXPCPVYP84E296SDv/X8CGBYJ
         Bc1+1hViPB1IGq10aITV9EFNZL6B2tnATgqI0KfeJlnTPFsuPWbhrgM/jbZ5zFWXos
         pFeLHOLzgGySAyZuQ0CHxZCwMxHsZClffOcksga6yAp9ChBUk/VhfsLBaooSNFjuHN
         5BcjuO2aDKe5GI/YTdcW6znqR7um3JmxR/tnHvFzxD0c2K812b7Fdp1i65PDAsdH3u
         Wfw1XgtwdduQWsNl/2TsSw7Tpc+2oJ2PQR5Gzs5+JfagqHaX6+nalLXqGAdXiNkU3x
         VnYGdEtdgOrvw==
Date:   Fri, 24 Feb 2023 11:40:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net] netdev-genl: fix repeated typo oflloading ->
 offloading
Message-ID: <20230224114059.41a9db82@kernel.org>
In-Reply-To: <20230223072656.1525196-1-tariqt@nvidia.com>
References: <20230223072656.1525196-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 09:26:56 +0200 Tariq Toukan wrote:
> Fix a repeated copy/paste typo.
> 
> Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Applied, thanks!
