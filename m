Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1260E10B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiJZMlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiJZMkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:40:36 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D5A6EF27;
        Wed, 26 Oct 2022 05:40:08 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1onfhV-0006np-6n; Wed, 26 Oct 2022 14:40:05 +0200
Message-ID: <156c9646-2cf6-ad32-56a7-d16342e87352@leemhuis.info>
Date:   Wed, 26 Oct 2022 14:40:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [REGRESSION] Unable to NAT own TCP packets from another VRF with
 tcp_l3mdev_accept = 1 #forregzbot
Content-Language: en-US, de-DE
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
 <20220930174237.2e89c9e1@kernel.org>
 <1eca7cd0-ad6e-014f-d4e2-490b307ab61d@gmail.com>
 <d6c3cd78-741c-d528-129a-cf7ed7ef236d@arcanite.ch>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <d6c3cd78-741c-d528-129a-cf7ed7ef236d@arcanite.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1666788008;dd472315;
X-HE-SMSGID: 1onfhV-0006np-6n
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Note: this mail is primarily send for documentation purposes and/or for
regzbot, my Linux kernel regression tracking bot. That's why I removed
most or all folks from the list of recipients, but left any that looked
like a mailing lists. These mails usually contain '#forregzbot' in the
subject, to make them easy to spot and filter out.]

On 12.10.22 14:24, Maximilien Cuony wrote:

> So we will try to not to have to use tcp_l3mdev_accept=1 to make it
> working as expected.
> 
> Thanks for you help and have a nice day :)

#regzbot invalid: tricky situation, reporter will work around it

