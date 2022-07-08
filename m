Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDC656C467
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239985AbiGHWO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239139AbiGHWO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:14:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD15286D5;
        Fri,  8 Jul 2022 15:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A098B829A0;
        Fri,  8 Jul 2022 22:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0BCC341C0;
        Fri,  8 Jul 2022 22:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657318463;
        bh=hnkI3EzBsIYdVofpLd1p8NWR26J1mZBS0im12Dq1kVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PzoMvn2pH5N1J1BbZKd10pCEe59haLGaXhOWwWyqxjrghzlMx6CYoi8j4ULfiRebv
         aG0Nx9uDylhvn4s13wdqCejNIOANRlUKEcCPfIjhjvBf/kX0lthz/1ZMFcD9SpiPk7
         pwQDsey96LV+5b7h/waF5ERUxNvB0yymG0kfl1W9AI5kP+vejdza/DBdgpUFeZY0FG
         SVq22Go+7DMkuBFfmAVs2KUR+Tai4PkfzioOLs4krOSeiMw46+jZz8P2O8qn6U7+qf
         fSyG+doHXwTCU0Io80WWs2WWaJcaGnl+draRZIE5gWhJS4DluMBMjRUXJ4ZswMwiUi
         QozrCbh1DfUdA==
Date:   Fri, 8 Jul 2022 15:14:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhongjun Tan <hbut_tan@163.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhongjun Tan <tanzhongjun@coolpad.com>
Subject: Re: [PATCH] iavf: Remove condition with no effect
Message-ID: <20220708151422.57456006@kernel.org>
In-Reply-To: <20220708035154.44079-1-hbut_tan@163.com>
References: <20220708035154.44079-1-hbut_tan@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jul 2022 11:51:54 +0800 Zhongjun Tan wrote:
> From: Zhongjun Tan <tanzhongjun@coolpad.com>
> 
> Remove condition with no effect

The code is fine, please fix the tool you're using to not generate such
patches.
