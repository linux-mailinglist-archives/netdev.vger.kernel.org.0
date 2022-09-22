Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071955E6D2F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIVUkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiIVUkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7195150198;
        Thu, 22 Sep 2022 13:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 094D4611D8;
        Thu, 22 Sep 2022 20:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5296C433D6;
        Thu, 22 Sep 2022 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663879198;
        bh=oN2eOuInoPtJZStYhJPXBZBnyssA6I/sBbAmg6BkU40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Owq9rab24xUdU7FJMzC2qw0vMEghlQBsdrMbCagAOmbG/YVghYl3u5nXkIaqEOrGk
         kyBPp//K7lkD/SywsT7lTw1d9wILiTh4zsDWCzHlkUJgq++RLy+TBwTgAGL5vj/idr
         kI/asEAFu+li4FZHCFC8tGr4Y8Z/QR15mwdNq2jIvWyMN7zrS3t02MS+jMrYs86KHl
         +7yRbhs9em+uuvohecGo7BMVPI8cgAjFOayfo4F03hJn3JkxKWey+LMUIJNlMY5LW4
         SeLiXtE+uVg0YRsOXsp0cyvBdTnJRPV9+KMUckeHQwKfdREdrczK43W+Ubyx0sHIBY
         BunE6A61YKlHA==
Date:   Thu, 22 Sep 2022 13:39:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next,v2 00/15] add tc-testing qdisc test cases
Message-ID: <20220922133956.46005009@kernel.org>
In-Reply-To: <20220921025052.23465-1-shaozhengchao@huawei.com>
References: <20220921025052.23465-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 10:50:37 +0800 Zhengchao Shao wrote:
> For this patchset, test cases of the qdisc modules are added to the
> tc-testing test suite.

Victor, Jamal, pls LMK if you'd like more time to review otherwise 
I'd love to apply these this evening. Our patch queue length is 
hovering between unreasonable and crazy :(
