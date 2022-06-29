Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B77755F593
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 07:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiF2FLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 01:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiF2FLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 01:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EE53123F;
        Tue, 28 Jun 2022 22:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E991B821BC;
        Wed, 29 Jun 2022 05:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AE5C3411E;
        Wed, 29 Jun 2022 05:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656479457;
        bh=Kjq3WBApi0UuWJlK/hd/hVoJ/um+sKVmDB47rISD9Pc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l6nN/Svgjop1Vcz2hyCX7tqJ9waNhXWNRDhZcD0Box2GBojLlxDt/xecRLJSb1d9g
         zxQg8Y9WeySQGQ2FUN9TJOS5UGPj4roQner8TgdSezLTSwhp1TOiQaYU7NvfxcE5RI
         fQptMNCtgaAlLswvpEJwIeG4NZFWl003pe6TItCgUtjBcxx+DzjDR4+CzD7oAfyOxe
         f20lOJPii+R1XOhci3RtbCLF/V1WA1V7AeoUyfmWM3IqIAT413xaG58Z4wTv1kbWWk
         6M1UgdZxwTbHq72ZL1wElE2h/BtuUBjVt4D26vfCDmKXe3xa4xK62CcXssnT6TDJrR
         m9HAfrqDYuDNg==
Date:   Tue, 28 Jun 2022 22:10:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v3 0/4] seg6: add support for SRv6 Headend Reduced
 Encapsulation
Message-ID: <20220628221056.48b5028f@kernel.org>
In-Reply-To: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
References: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 13:36:38 +0200 Andrea Mayer wrote:
>  - patch 2/4: add selftest for SRv6 H.Encaps.Red behavior;
>  - patch 3/4: add selftest for SRv6 H.L2Encaps.Red behavior.

Always great to see selftests. Should they be added to the Makefile?
Otherwise they won't run unless someone manually executes them.
