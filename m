Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45D46A6396
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjB1XDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjB1XDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B3937B61;
        Tue, 28 Feb 2023 15:03:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A6A6B80ED5;
        Tue, 28 Feb 2023 23:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D0BC433D2;
        Tue, 28 Feb 2023 23:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677625381;
        bh=5IpYH68eWUqIPlL1t+5gM5xfi4rM+WsJbCeKdMMHUNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rh9fCjF5QLRtQdBX5ppDDxcVLi7BqS3ty/9fLBfRDY/pMDTbNXVLdBKQna2gfitLz
         5+N57w5h+iY/5IygNFP/IeN/MlKTX+vop9wK9SQ0+5wgMuRoeoJvhCVWmFzb0XnFoz
         Sm/uv4PfYShDoKKMo4wD7SKhBiKRAxoMmSE5azBUBKzdbpbLXQBzatMg4wFGuGXXmn
         ivrFWXz68Nbe45kP5K6v/a3Jn8DQMi6UBrEXCs4GpLmz4Zb+cxXQmk4jpf+BQZq2t8
         mWeRzsMQD3JhOjv/7YixEUUrhJHj8ndkFOQkpOByGJnf3ebT56FPMeSOgbLvcsbt8Q
         YaxiaBijVnwVw==
Date:   Tue, 28 Feb 2023 15:02:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 0/4] net/smc: Introduce BPF injection
 capability
Message-ID: <20230228150259.6b526bef@kernel.org>
In-Reply-To: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
References: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
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

On Wed,  1 Mar 2023 00:38:07 +0800 D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patches attempt to introduce BPF injection capability for SMC,
> and add selftest to ensure code stability.

If you cross-posting to net please make sure you follow netdev rules.
Don't repost too often.
