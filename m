Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E042584AF4
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiG2FH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiG2FHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E359720BD9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFB861E81
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72718C433C1;
        Fri, 29 Jul 2022 05:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659071272;
        bh=c3CPUeW6dvo98mVwWTePRzzjRltkHbkVdySitwCcKUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L4/JcMyezrY8CVj+ww1z1il4L0feGtB6CrT8s8CH7rSCT4GAhvu3EgERxKd5qTvKS
         qt2JWEjIXTLMBPGaykbC8VqS8B+cCcHOFoRZgDnc+TYSMOgeXGyuKE80nlpQOCdW4V
         J0YDPW+9FkhpJczIqGKbLvWWiuBIkkgednJYR4LLa8sXEWozig6BErLwRSXuWJp1Ls
         /B4qEQKW+cwLeV9m4qJwVhjFPNyJILKxhCdd9U032oK/kWuwpAu6hax4aeB8NFJ6x4
         y2CKANyUJ3NsyaGygKiG+JEQHEmZxR6DNeD5nxybSvDkaXs9URp+IzCHjeeb8Ajof8
         yU84BvxYlQqiA==
Date:   Thu, 28 Jul 2022 22:07:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com, dsahern@gmail.com
Subject: Re: [PATCH net 0/3] netdevsim: fib: Fix reference count leak on
 route deletion failure
Message-ID: <20220728220751.62a70ced@kernel.org>
In-Reply-To: <20220728114535.3318119-1-idosch@nvidia.com>
References: <20220728114535.3318119-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 14:45:32 +0300 Ido Schimmel wrote:
> Fix a recently reported netdevsim bug found using syzkaller.
> 
> Patch #1 fixes the bug.
> 
> Patch #2 adds a debugfs knob to allow us to test the fix.
> 
> Patch #3 adds test cases.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
