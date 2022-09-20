Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B285BE86C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiITORb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiITORI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825D618E34
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 07:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13088B829CE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF63C433C1;
        Tue, 20 Sep 2022 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663683266;
        bh=NTSuszF7k/Ui1HBfZKBt403M6fsZU0efGX8HvtksBdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OPLOzK/IAbWny+e+wJqxadZ9GdcbHW+pSlrxzvE4K9ngll5Yd4UmJz3PH0CtcDzhh
         WItLh7sNmvIixhH1b+zuLPha3QUDXLD2MjOhQCUlAxJOzGrqpNIcbLH/pUxEa24Umy
         aaXZ6xvpLtQr3j72u2DRb+VIsul8KgLWzf7uQn3UcHAeplpvw/rj28qaEElvCwtcDN
         Tyw7IDAzNhEiaLuQ3NRYv7OqA5+SQ4NbfFvuax4gdfXDqCBeYk10IYFkTya9yyBaMp
         /rV+mUu7MMUtpSgPphGGShNiCBDt40gzUeAKzfBlUOeCzYpPGUWZzirGv25/sn5iXD
         a0TuT8mHNb8/A==
Date:   Tue, 20 Sep 2022 07:14:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [RFC PATCH net-next] net: txgbe: Store PCI info
Message-ID: <20220920071425.6d63b1ca@kernel.org>
In-Reply-To: <20220910084540.83610-1-jiawenwu@trustnetic.com>
References: <20220910084540.83610-1-jiawenwu@trustnetic.com>
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

On Sat, 10 Sep 2022 16:45:40 +0800 Jiawen Wu wrote:
> +config LIBWX
> +	tristate
> +	default y

The 'default y' should not be necessary, you correctly use 'select' 
in the sub-drivers already.

> +	help
> +	Common library for Wangxun(R) Ethernet drivers.
