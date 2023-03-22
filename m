Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501EF6C4145
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCVDtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCVDtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:49:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C5F3524A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F421B81AF7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B524C433EF;
        Wed, 22 Mar 2023 03:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679456946;
        bh=HlxozqMIm5gdmZSbdIeUXASjxjTeDjiB9/zp9QQpVCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KfoCT9HeTOfNtRJ7UcYznJ51KIoXKhDYZNCrILN+rEzEw4U0bdnQAxF2xbzR5BPP9
         k8aoQAMtUnmO2sRy4hHpN1/Z7cIxQ6Y5AqNDp8eIu6I9dkRUf/KCVmvJkFf+2kbMrb
         lFIZuCdIljieVs0ZBcy8CyZ9LcEmCz9a/S1Uzg0K35zvq90bb5ZXPamESVI3HmEu0I
         xYDmHrOylQe5KxmufaqSu8Sko2fv6t1Otsruc2p4NmLFhDd8qsrGCfTi2vDzLpi9Ee
         5BCrqCqDRohCSBJxZy80wqfW2KLe1pQfZXn6qSPXM8wybYuEFqZkuEWRJQMXNp4V+I
         hkl6imT1cKDyw==
Date:   Tue, 21 Mar 2023 20:49:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net-next 00/14] mlx5 updates 2023-03-20
Message-ID: <20230321204905.47dd3425@kernel.org>
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 10:51:30 -0700 Saeed Mahameed wrote:
> This series from Eli, adds the support for dynamic msix and irq vector
> allocation in mlx5, required for mlx5 vdpa posted interrupt feature [1].
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Please CC Thomas on v2
