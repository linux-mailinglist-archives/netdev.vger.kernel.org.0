Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2041A6D2E0A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjDAEIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjDAEIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:08:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86D51A96F;
        Fri, 31 Mar 2023 21:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 639ED60EC7;
        Sat,  1 Apr 2023 04:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA65C433EF;
        Sat,  1 Apr 2023 04:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680322116;
        bh=JhUfMI/d5rnRBHZ2MOdkLbza9ibqlixBVrLlp2RDPbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDIKUVd+DEfI+CojH/5roqbAXB+K/E29Nw0JDXefmfZyvLxnUYaiFGn90/cjVomcG
         IYC8jXMb6WaYpN16ppV/mbaQRwS8Q/k5Z+ruiiLhkeaArdbApgjaKLXdA+5Tamugxv
         axcNIHeGbAqgvbS+HQCblMRl+btCLWAv4fuOCza+u6VghkIyHsE8RAq0NvKLAaA8Bz
         CYCpjlviiZJPVSvpOw6J4H9CJdtJcmMLJ23XmZAIIBDZh0UATPQKXc4xLdBLZjjjr6
         EeiStLPiS+bZb3BiqfxJJr+TAIunjmPFS+RwsDfIjB+iOuctDYVI4tAWrmX95Ueajl
         ZJGD0Lt+AgxYA==
Date:   Fri, 31 Mar 2023 21:08:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/6] netlink: Add new netlink_release function
Message-ID: <20230331210835.2312b644@kernel.org>
In-Reply-To: <20230331235528.1106675-3-anjali.k.kulkarni@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-3-anjali.k.kulkarni@oracle.com>
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

On Fri, 31 Mar 2023 16:55:24 -0700 Anjali Kulkarni wrote:
> A new function netlink_release is added in netlink_sock to store the
> protocol's release function. This is called when the socket is deleted.
> This can be supplied by the protocol via the release function in
> netlink_kernel_cfg. This is being added for the NETLINK_CONNECTOR
> protocol, so it can free it's data when socket is deleted.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
