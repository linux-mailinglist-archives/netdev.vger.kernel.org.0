Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32775647D16
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLIEyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 23:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLIEyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 23:54:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61EC7D05E;
        Thu,  8 Dec 2022 20:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D70AB827A1;
        Fri,  9 Dec 2022 04:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4DDC433D2;
        Fri,  9 Dec 2022 04:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670561673;
        bh=rSB5y5gfDM3Ow36b0u0/C60y2e6oDZ7NLUrrP88Fvw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpi3f9V9c4bdztR9nKSHWOL7zKOIZAXYwTHtMpKKT9o3KR5YV5pYfEzxZ1bRPWZiW
         xG78z0gPVMFgG++Kxgi1Ic7IbwUHNPufvT88q+LIS/fiF4tQi+Mn3HEGsLR7XQxJj6
         edvJXJNDzp6fmSWq3dRUk/yHn9RBvPdqO1b3V4B5E7AqN/TGfGodFWR5wnZDTkdsen
         SXJefYARubHiyglRodLXiqJNo0MACwaBFAxYzh1oE0kCNifGP0qtNwQM9fVFFD1puR
         3mttmyLek4N8hrvlRrgkAGDWO0EPcWZx+09tXEBNDCHEv1TO+gYCm6a5V3M6Drngir
         EseWRJJroxj7A==
Date:   Thu, 8 Dec 2022 20:54:32 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] xen-netback: Remove set but unused variable 'pending_idx'
Message-ID: <Y5K/iE9oa3PIrsQx@x130>
References: <20221209034036.37280-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221209034036.37280-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 11:40, Jiapeng Chong wrote:
>Variable pending_idx is not effectively used in the function, so delete
>it.
>
>drivers/net/xen-netback/netback.c:886:7: warning: variable ‘pending_idx’ set but not used.
>
>Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3399
>Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

Please mark your patch clearly with [PATCH net-next] or 
[PATCH net] if it's a bug fix. 

Thanks for the patch.

