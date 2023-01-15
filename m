Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C356D66B006
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 09:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjAOIyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 03:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjAOIyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 03:54:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D476C7698
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 00:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262FBB80B05
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06164C433EF;
        Sun, 15 Jan 2023 08:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673772859;
        bh=KNRGgJIeeugKaXpzMRjOoWDm39SrtbdFacD7slXo+cU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WmIijxvAQjgNU426kArIO4SpOQ82Ir61LcJuyerwHvL/7zwR7Is2bDXmSdaGT18sp
         fbYq2Baob0wxq+Ri+7pPLdzpHRMbgZ4l2hSoN4LTI+HVMt6ZdQX10G2A3k1vAx/LId
         oYGZZ7sYVl4I9XJPKqSj9hXIOm/t4l6ezybQWg6J3RML+80x9dJJK/jZCzSiLjSRnI
         cYokKAAfvw4+QduFvhonmuy0G61XTHeYGdyT/hUEYdSF+t8RAIOHBXZKTgHs6DV/UF
         aXPdCigVlEue56bObjdx1lFBfwzwNsss0w6j4Z146WRSr1n035xjWjgbTOfNJWbvva
         7p+tJbsO4BCzQ==
Date:   Sun, 15 Jan 2023 10:54:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jerinj@marvell.com,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [PATCH v2 net-next,0/8] octeontx2-af: Miscellaneous changes for
 CPT
Message-ID: <Y8O/N0oHX4VtHMDO@unreal>
References: <20230111122343.928694-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111122343.928694-1-schalla@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 05:53:35PM +0530, Srujana Challa wrote:
> This patchset consists of miscellaneous changes for CPT.
> - Adds a new mailbox to reset the requested CPT LF.
> - Modify FLR sequence as per HW team suggested.
> - Adds support to recover CPT engines when they gets fault.
> - Updates CPT inbound inline IPsec configuration mailbox,
>   as per new generation of the OcteonTX2 chips.
> - Adds a new mailbox to return CPT FLT Interrupt info.
> 
> ---
> v2:
> - Addressed a review comment.
> v1:
> - Dropped patch "octeontx2-af: Fix interrupt name strings completely"
>   to submit to net.
> ---
> 
> Nithin Dabilpuram (1):
>   octeontx2-af: restore rxc conf after teardown sequence
> 
> Srujana Challa (7):
>   octeontx2-af: recover CPT engine when it gets fault
>   octeontx2-af: add mbox for CPT LF reset
>   octeontx2-af: modify FLR sequence for CPT
>   octeontx2-af: optimize cpt pf identification
>   octeontx2-af: update CPT inbound inline IPsec config mailbox
>   octeontx2-af: add ctx ilen to cpt lf alloc mailbox
>   octeontx2-af: add mbox to return CPT_AF_FLT_INT info
> 

Except not-so-great commit messages and huge amount of timeout
loops in patch #3, the series is ok.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
