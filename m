Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1E66084C0
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJVFsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJVFsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:48:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1C32B2E17
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 22:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A756B82DE9
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 05:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95896C433D7;
        Sat, 22 Oct 2022 05:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666417683;
        bh=/C3cchOyTq1IwiuQJJKe5zmFGMMALp/V/ZnSK5GuaNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oQciKBgXs6XGrLd9+arOuu4Do9yLH0IeLEOxJf2MDK9quESTAjORsBatzm5Lz8XHL
         tmfNIGANlRRjBNCaBb+62ZeJLdZbatdzh7yngilu/2fnB7oQTlHgKRDoj86Ax+0l2O
         XQraUl3XoaCyPxK8IaWde59gqYl+N2T/U+FeWV1EmNL+D14n49XW1O27QGQ/7t++2d
         8+7kb+COL18ACVvlrFX8nrYrKqAFlnNJlLviUGxVOrRBqS/5RD7J6fL9vwRix6nSRn
         6XZpRMoxFrVyfK/OioUHmXaomM8/82Ow2OrlStnHuR0PHQC6oZ8yoyiu+l4NJ302Mm
         RcwGnOhMcvMAA==
Date:   Fri, 21 Oct 2022 22:48:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [RESEND PATCH net-next v4 2/3] net: txgbe: Reset hardware
Message-ID: <20221021224802.6eebde64@kernel.org>
In-Reply-To: <20221021020720.519223-3-jiawenwu@trustnetic.com>
References: <20221021020720.519223-1-jiawenwu@trustnetic.com>
        <20221021020720.519223-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 10:07:19 +0800 Jiawen Wu wrote:
> Reset and initialize the hardware by configuring the MAC layer.

Please ensure clean build with W=1 C=1 of all the patches:

drivers/net/ethernet/wangxun/libwx/wx_hw.c:139: warning: Function parameter or member 'wxhw' not described in 'wx_stop_adapter'
drivers/net/ethernet/wangxun/libwx/wx_hw.c:139: warning: Excess function parameter 'hw' description in 'wx_stop_adapter'
