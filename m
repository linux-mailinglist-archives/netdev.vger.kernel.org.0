Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D433D612B80
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 16:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJ3P7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 11:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ3P7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 11:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E75BF2;
        Sun, 30 Oct 2022 08:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E4A60EFE;
        Sun, 30 Oct 2022 15:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1131C433D6;
        Sun, 30 Oct 2022 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667145571;
        bh=F92cmYOI8TErny/EzC5flHNgjJxPcT9cLH7LNmctHRA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=C8zWmie1V9Lq/2UJD9xDOpTIhLvAYaTP+cPnHg0aJBCVgnmbAenfbOrGXGfA+aAWB
         lFIF8siPeZytDu+E4EcayNLD8kOx9hVg5jMIYrdJcFwPzL+bLl0t8jQeZfWP/F9ZEM
         J6zIwEkprDdFce3drdcmGopvqo92LxDeiNVzfcuNrZwHaxz33w3IybqHenLQjGbUex
         +c7gKSaTSvhBxA4XFNCnGMykDvXwDxxoHgkv/EoWBQvDK91s2pjD3T4n4stLStufc5
         XhfrQR/lb2GoJghPiLIV/xvz8NnPWVoDvFFfVQjXgYdGVyhkFuW1dO8dCSEYJhO+Cu
         HCB8P1fTX2M7Q==
Message-ID: <2adc406f-1abf-1312-941a-47a1e1f4c995@kernel.org>
Date:   Sun, 30 Oct 2022 09:59:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [net] 0e4d354762: kernel-selftests.net.fcnal-test.sh.fail
Content-Language: en-US
To:     kernel test robot <oliver.sang@intel.com>,
        Richard Gobert <richardbgobert@gmail.com>
Cc:     lkp@lists.01.org, lkp@intel.com, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <202210062117.c7eef1a3-oliver.sang@intel.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <202210062117.c7eef1a3-oliver.sang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 7:23 AM, kernel test robot wrote:
> # TEST: Global server, device client via IP_UNICAST_IF, local connection, with connect() - ns-A loopback IPv6  [FAIL]

...

> # TEST: Global server, device client via IP_UNICAST_IF, local connection, with connect() - ns-A loopback IPv6  [FAIL]

Richard:

Don't recall a followup on this report. Can you take a look? These tests
were added by you after your change for IP_UNICAST_IF.
