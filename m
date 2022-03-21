Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0204E2DC2
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350204AbiCUQWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiCUQWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:22:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD6CABF55
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B61F61228
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C78C340E8;
        Mon, 21 Mar 2022 16:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647879669;
        bh=LDsjK9dCSrkjKU+efZe52RbNkVkvBR3n+JeTIja52rQ=;
        h=Date:From:To:Cc:Subject:From;
        b=HHJn0qQTJVft1bl3GASfAEyNXh8AsHMXfzREdUspra8VKFrrzoHVsSPYbXTTl6srs
         52dCoKWabqjUaIvKBLfTDhogECnWFmp9NBQvJOIW7ksFJdKZNlEn62w29g1ugbVEaT
         WJkhw/sXmxFna0Lm4LvwhFEfUbo8r5yXzMyj51lYqidv1N17tQF4OY78St4aAYltFM
         Bac+gPM8hpLhc8CVl/Jus+wTzZ63YhSDKEGdTwhSAzJIJKQG4JZ0L/6P3oeyzhprRN
         Ve7z8kLUl98OIYLrUWAr6A82vtilb8XRdjCyr2NX9LTuS1HXSt+pwvA7+eUs6ualyM
         T+AEX5AdE9mZw==
Date:   Mon, 21 Mar 2022 09:21:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: net-next is closed
Message-ID: <20220321092106.2ede3988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone!

Linus has cut the 5.17 release. We'd like to allow a day or two 
to resolve known issues in net-next before sending a PR but please
consider net-next to be closed already. We'll be taking fixes only.

Thanks!
