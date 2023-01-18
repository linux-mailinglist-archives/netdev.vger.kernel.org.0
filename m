Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A24671172
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjARDD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjARDD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:03:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E264FC3F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:03:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94666B819EE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F41C433D2;
        Wed, 18 Jan 2023 03:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674011033;
        bh=L5ghLD1aNdJA0HI98H2VloweX+zffczTL0bukBVkTXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IiESibFn4jWDETOAnhLlNpow3jvmtFUax/JAbKB5QT6b9t7Mb7/U34J9GMuVznu+o
         eViyKNX4CrPUJpJj+29PEBz3qRXn4GaKyw0AnxWZ1ZrLQhk6XZKcs4MxOUdzQjywG/
         NZLeraib7ARL4GN4WHoQNcS5UfSd0q9bx6EioXp17kPeLouTerX01WW/9zf9eRIukm
         bTlBKfGsUBuzDI4XA548uRKTFuJS6QW48T41CE/4YHLV91YhDC784d9K9t8QiLpWnE
         eFGI5ngaxWpVYcphwOSeO/oIs6CobvMXjtYbJmDSHQtjZn2LWIhyqSO0dKdhwJvqh3
         gL3y9ni35qMQA==
Date:   Tue, 17 Jan 2023 19:03:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2][pull request] Intel Wired LAN Driver
 Updates 2023-01-13 (ixgbe)
Message-ID: <20230117190352.3ba4ef6e@kernel.org>
In-Reply-To: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
References: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
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

On Fri, 13 Jan 2023 13:42:46 -0800 Tony Nguyen wrote:
> Jesse resolves warning for RCU pointer by no longer restoring old
> pointer.
> 
> Sebastian adds waiting for updating of link info on devices utilizing
> crosstalk fix to avoid false link state.

Pulled, thanks!
