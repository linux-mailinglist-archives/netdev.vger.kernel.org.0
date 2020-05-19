Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30591DA139
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgESTqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgESTqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:46:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E92C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:46:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69552128B7E97;
        Tue, 19 May 2020 12:46:14 -0700 (PDT)
Date:   Tue, 19 May 2020 12:46:13 -0700 (PDT)
Message-Id: <20200519.124613.1041722222029970914.davem@davemloft.net>
To:     marc.payne@mdpsys.co.uk
Cc:     oliver@neukum.org, hayeswang@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH] r8152: support additional Microsoft Surface Ethernet
 Adapter variant
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519180146.2362-1-marc.payne@mdpsys.co.uk>
References: <20200519180146.2362-1-marc.payne@mdpsys.co.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:46:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Payne <marc.payne@mdpsys.co.uk>
Date: Tue, 19 May 2020 19:01:46 +0100

> Device id 0927 is the RTL8153B-based component of the 'Surface USB-C to
> Ethernet and USB Adapter' and may be used as a component of other devices
> in future. Tested and working with the r8152 driver.
> 
> Update the cdc_ether blacklist due to the RTL8153 'network jam on suspend'
> issue which this device will cause (personally confirmed).
> 
> Signed-off-by: Marc Payne <marc.payne@mdpsys.co.uk>

Looks good, applied, thanks.
