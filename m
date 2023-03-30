Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9ACB6D0690
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjC3N0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjC3N0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:26:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D37B1721;
        Thu, 30 Mar 2023 06:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC896206D;
        Thu, 30 Mar 2023 13:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5FBC433EF;
        Thu, 30 Mar 2023 13:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680182764;
        bh=dSIOoybE1W349DqL4UmHGGA/bEYIiW88os5hr4nt+qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R+OLtVKyiCUyYQ3N5jvrPvyoLeNKKOVrhnnbvL4NknIQya4La+DQOtAZyLt7nYQmX
         jEeWR/ruYZV5SIxrL3qdYOLQk874y01CzLG1zTSIyjUorGVbXK5oMPS1bEAyk1ewCn
         8h+NEkK0YGC/KK16STOZKguycIhMYGV13T4k7ce3n4wZ3Xrd1QvYEqMVHh5xHg51Qq
         /c5VaNaSeseXlrNKGkTwghrUDhX8nOCLyLLBLHNM/R+b+9HPYsuLleF1TVyCl3WO75
         h0j9Fw3zf1s8wVOvo3aiIE8y+rwWM+ScXFt8qgTJUjG20CBQDOdPewRsOENGgd9MG/
         RLABjmBEsYxPw==
Date:   Thu, 30 Mar 2023 14:26:00 +0100
From:   Lee Jones <lee@kernel.org>
To:     Min Li <lnimi@hotmail.com>
Cc:     richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH mfd v2 1/3] mfd: rsmu: support 32-bit address space
Message-ID: <20230330132600.GR434339@google.com>
References: <MW5PR03MB693295AF31ABCAF6AE52EE74A08B9@MW5PR03MB6932.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW5PR03MB693295AF31ABCAF6AE52EE74A08B9@MW5PR03MB6932.namprd03.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023, Min Li wrote:

> From: Min Li <min.li.xe@renesas.com>
>
> We used to assume 0x2010xxxx address. Now that we
> need to access 0x2011xxxx address, we need to
> support read/write the whole 32-bit address space.
>
> Also defined RSMU_MAX_WRITE_COUNT and
> RSMU_MAX_READ_COUNT for readability
>
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
> changelog
> -change commit message to include defining RSMU_MAX_WRITE/WRITE_COUNT
>
>  drivers/mfd/rsmu.h       |   2 +
>  drivers/mfd/rsmu_i2c.c   | 172 +++++++++++++++++++++++++++++++--------
>  drivers/mfd/rsmu_spi.c   |  52 +++++++-----
>  include/linux/mfd/rsmu.h |   5 +-
>  4 files changed, 175 insertions(+), 56 deletions(-)

I changed the commit message a little and reworded/moved a comment and:

Applied, thanks

--
Lee Jones [李琼斯]
