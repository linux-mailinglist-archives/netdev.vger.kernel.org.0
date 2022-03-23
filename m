Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C474E4AE0
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 03:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbiCWC1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 22:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiCWC1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 22:27:04 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59857005E;
        Tue, 22 Mar 2022 19:25:33 -0700 (PDT)
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id D2FFC202C5;
        Wed, 23 Mar 2022 10:25:29 +0800 (AWST)
Message-ID: <dcc287325b0139ac5a26a20cf26138eff5709dd6.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next] selftests/net: mctp: Roundtrip tun tests
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Date:   Wed, 23 Mar 2022 10:25:29 +0800
In-Reply-To: <18240e3b-15f0-f961-cbbc-240b54dd71b1@linuxfoundation.org>
References: <20220322071934.2655827-1-matt@codeconstruct.com.au>
         <18240e3b-15f0-f961-cbbc-240b54dd71b1@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shuah,

Thanks for the review.

On Tue, 2022-03-22 at 17:28 -0600, Shuah Khan wrote:
> Are you adding this test to main Makefile? If so you will need to chane
> selftests/Makefile

Given most test-running systems won't have the "mctp" binary requirement I'm
not sure it should be added to the main Makefile? The tests are intended more
for future MCTP developers. I can add it if you think it's worthwhile though.

> Change the message to "AF_MCTP support is required to run this test. Skipping"
> 
> I assume this servers as a check for CONFIG_TUN and CONFIG_MCTP?
> ...
> Couple of thoughts. If you were to write wrapper shell script,
> you could check for requirements: configs, mctp presence from
> the shell script and then run mctp-tun from the shell scripts.
> This is a just a suggestion if adding shell script makes things
> easier especially checking the configs.

I think it's better kept in the compiled mctp-tun - it's often used cross-
compiled so a single binary is simpler to manage. I'll move the requirements
checks out to a separate function for clarity.

Cheers,
Matt

