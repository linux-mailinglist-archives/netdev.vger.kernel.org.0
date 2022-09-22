Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5975A5E6DC1
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiIVVLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiIVVK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ED7DF3A5;
        Thu, 22 Sep 2022 14:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE1FB8363F;
        Thu, 22 Sep 2022 21:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB2C43147;
        Thu, 22 Sep 2022 21:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663881055;
        bh=vOnHpA7v0NQdgKtqzTW4AbDF2VWJrUVSTU54rbJj8fE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZGvz7TTug6LiiFSDLoNGbcq1n4vFvhSBtiCePTWV1zvFJMo8Q3xn8M7T6heVbMBa
         mUoLfv+vppX2DfjZ0R21iI94QahBkNMBBlgrM9zNZuY5znbvXZ4+hxD1CAK5sDz9VR
         fXtL54En7nYJmh/ONluz56hlwqKL/I6QlX3OaxPpb3gsA/++3eYLUN+OfI0vGr9EWO
         elFu2i2RKbgagzVoQfNh4O3j6LT1/vH5NkrnSrQ41+clGDYKA7ysjvirYCdUPJFIA0
         0BLQYXhqHIKu6x+xE5IKqOAe2GNJypCWKsG/Iq5DM6L8LuC6fCl4wplOj+VxyYoRaO
         QMxAPlDkMBvew==
Date:   Thu, 22 Sep 2022 14:10:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org, victor@mojatatu.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net-next,v2 00/15] add tc-testing qdisc test cases
Message-ID: <20220922141053.245273df@kernel.org>
In-Reply-To: <CAM0EoMmxHniuywoLOAJmVX7F6mJ30+A1=S0uqDQhJw9qiU2S0Q@mail.gmail.com>
References: <20220921025052.23465-1-shaozhengchao@huawei.com>
        <20220922133956.46005009@kernel.org>
        <CAM0EoMmxHniuywoLOAJmVX7F6mJ30+A1=S0uqDQhJw9qiU2S0Q@mail.gmail.com>
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

On Thu, 22 Sep 2022 17:06:02 -0400 Jamal Hadi Salim wrote:
> There's some issue with this patchset - something was oopsing; could be
> an issue on our setup. Victor is looking into it.
> 
> Tests are good though - and we do review them and run them before
> acking...

Roger that, I'll take the 18 part set since it looks acked 
and hold off on these.
