Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799AF61EB11
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiKGGhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKGGhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:37:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B66C60EC;
        Sun,  6 Nov 2022 22:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25DEB60ED8;
        Mon,  7 Nov 2022 06:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C42C433D6;
        Mon,  7 Nov 2022 06:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667803038;
        bh=H6xaoP9tub/S4ypIzpnW4yxC0ABwXZ9M0Z0e6I3Swbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VHPf7a4aYlPjrOj3qcx3FL7mZ6DyKH3wOr4DOMEYspqBLWjQLkKFcTgnDF9fSRNyD
         koIuUOl79nqkdYYJp71hQ/yCCIZg0UbLBY5apu4CAhsDjMBTCz2wh9oY4irrg3S94E
         tmobtDUtqcHhon4WMUzQNMowY1rK29Eak5/s1iwAtU0S1fX6lYZn47/JIlUwhbwHRM
         vk7HU1TBQRCVBmhD2uNkC6jF54b736ReewuXzY6424fmamQO1uA8+UmdOwokPCTRck
         PSr985ZEfCOyM7o522ZaMPphaQ6MINaaPq/G/1pmzToHJ/pgq7M7rhmuqw32s3puJx
         Yml2PmQfj4a0g==
Date:   Mon, 7 Nov 2022 08:37:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>, kuba@kernel.org
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: Re: [PATCH v3 0/6] Add Auxiliary driver support
Message-ID: <Y2inmdbpoRm2VbuE@unreal>
References: <CACZ4nhtmE9Dh9z_O9-A934+q0_8yHEyj+V-DcEsuEWFbPH6BGg@mail.gmail.com>
 <20221104162733.73345-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104162733.73345-1-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 09:27:27AM -0700, Ajit Khaparde wrote:
> Add auxiliary device driver for Broadcom devices.
> The bnxt_en driver will register and initialize an aux device
> if RDMA is enabled in the underlying device.
> The bnxt_re driver will then probe and initialize the
> RoCE interfaces with the infiniband stack.
> 
> v1->v2:
> - Incorporated review comments including usage of ulp_id &
>   complex function indirections.
> - Used function calls provided by the auxiliary bus interface
>   instead of proprietary calls.
> - Refactor code to remove ROCE driver's access to bnxt structure.
> 
> v2->v3:
> - Addressed review comments including cleanup of some unnecessary wrappers
> - Fixed warnings seen during cross compilation
> 
> Please apply. Thanks.

Please send this series as standalone one and not as a reply
to previous discussion. Reply-to messes review flow, especially
for series.

Jakub, I'll review it once Ajit will send it properly.

Thanks
