Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6516C89FE
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 02:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjCYB05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 21:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCYB04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 21:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B33A1ADC2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 18:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCA3262D32
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 01:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A460C433D2;
        Sat, 25 Mar 2023 01:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679707614;
        bh=YbenZtz8FjnYxoSaZ9XMpwrDYFUwjcTQYJKf2N1hZIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b81Ck6r2z58EqnxIRQyxhwLuF8BDJmk2FUot1DZHZmvxAKtB75i0MkyHeRev6xHWa
         916Kj5EUVBTBdZ6H5SSjDByi40CptsTXCDl3ezUtEtBQo9HweOSmuwT35yMJp7fOLR
         P+yh44E0vq7aYd7/1YhdS7g6odyYAP5+/zfCvwMexSnn2EIDOCqmTdiWukD29wLPcz
         0rve2/ZJLk5ydvXuSQwJ/iBQXDWTQLZd4qY2Mjb005iZstvaI227kjvhRiCcbVl3ae
         0i6zDjMvyxY8RlXu0O+ml58wfChFMjJAjB1XTWLYV5KkdzVucDWxeV0t1FXiUa9+M6
         O5u10yFjHBSwg==
Date:   Fri, 24 Mar 2023 18:26:53 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pull request][net-next V2 00/15] mlx5 updates 2023-03-20
Message-ID: <ZB5N3U5piGy/2z/+@x130>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Mar 16:13, Saeed Mahameed wrote:
>From: Saeed Mahameed <saeedm@nvidia.com>
>
>v1->v2:
>  1) Improved commit messages
>  2) Added reviewed by Jacob Keller
>  3) handled Checkpatch errors
>  4) CC Thomas
>  5) Proper errno return values
>  6) Avoid "glue" leakage.
>  7) Removed unnecessary Fixes tag.
>
>This series from Eli, adds the support for dynamic msix and irq vector
>allocation in mlx5, required for mlx5 vdpa posted interrupt feature [1].
>
>For more information please see tag log below.
>Please pull and let me know if there is any problem.
>
>The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:
>
>  Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)
>
>are available in the Git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-03-20
>
>for you to fetch changes up to 2e21ab28e230fd8333ac0586901431132cc308d7:
>
>  vdpa/mlx5: Support interrupt bypassing (2023-03-24 16:08:40 -0700)
>

This last patch is supposed to go to vdpa branch, so i updated the tag, 
let me know if V3 is required for this change:

The new tag is now moved to point at one commit back:

The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:

   Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)

are available in the Git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-03-20

for you to fetch changes up to fb0a6a268dcd6fe144c99d60a1166e34c6991d5f:

   net/mlx5: Provide external API for allocating vectors (2023-03-24 16:04:30 -0700)


