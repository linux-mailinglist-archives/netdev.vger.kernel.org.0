Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5756C8A1B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjCYCGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCYCGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63975BBE
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 19:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FE2A62BE3
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 02:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476D2C433D2;
        Sat, 25 Mar 2023 02:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679709996;
        bh=2DrJH/jOYxPUBnugWPZ62Tin+PFdGJiV9lk9RGf9Gt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qM6mN+C/Mg0JE57u9F07WqJ0Nghs5qHiUQ12BvxWJp75iF0Vo4OxPZ6izDNwj9qWK
         iuDS68Nrf4beZt/Yp8vVA7FQr9te2fbH3wgajphACQUAj/3nf3ZTNp67PqxpTRwcUk
         GW98Wqd/ZJL8wK2COXyQKyXRSxl4ck5nAnRhPqtY7XL+CPBKCnJFewJdahzgmjfD/C
         MWOd0Lv1iYg8CBSRMTCASpCSew4sjMT/e5mDqhf7wpzKRKAuyipRe5erD4aIpxC4se
         +r83991HjCYQUecPzCq/wY/W1INeB9T4JfWmfqX2+ROp9Mkdik1GcvjPi8jZ5LX/Ju
         K1fypXl/Zyrrg==
Date:   Fri, 24 Mar 2023 19:06:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v2 1/4] net/sched: act_tunnel_key: add support
 for "don't fragment"
Message-ID: <20230324190635.2b2dbd5b@kernel.org>
In-Reply-To: <0d844484d8324805d438cee72c9ec4f4bd219a83.1679569719.git.dcaratti@redhat.com>
References: <cover.1679569719.git.dcaratti@redhat.com>
        <0d844484d8324805d438cee72c9ec4f4bd219a83.1679569719.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 14:34:40 +0100 Davide Caratti wrote:
> +		    ((key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
> +				nla_put_flag(skb, TCA_TUNNEL_KEY_NO_FRAG)) ||

indentation looks off :(
