Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4783D12C3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhGUPHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbhGUPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:07:30 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3876EC061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:48:07 -0700 (PDT)
Received: from localhost (unknown [51.219.3.84])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 779C34CE6854C;
        Wed, 21 Jul 2021 08:48:05 -0700 (PDT)
Date:   Wed, 21 Jul 2021 08:47:59 -0700 (PDT)
Message-Id: <20210721.084759.550228860951288308.davem@davemloft.net>
To:     paul@jakma.org
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH] NIU: fix missing revert of return and fix the driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <70d84870-2d7a-77b2-175b-ef1ff3cb6c38@jakma.org>
References: <70d84870-2d7a-77b2-175b-ef1ff3cb6c38@jakma.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 21 Jul 2021 08:48:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Jakma <paul@jakma.org>
Date: Tue, 20 Jul 2021 21:10:37 +0100 (BST)

> The revert of commit 26fd962 missed out on reverting an incorrect
> change to a return value. The niu_pci_vpd_scan_props(..) == 1 case
> appears to be a normal path - treating it as an error and return
> -EINVAL was breaking VPD_SCAN and causing the driver to fail to load.
> 
> Fix it, so my Neptune card works again.
> 
> Cc: Kangjie Lu <kjlu@umn.edu>
> Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Fixes: 7930742d ('Revert "niu: fix missing checks of
> niu_pci_eeprom_read"')
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Paul Jakma <paul@jakma.org>
> ---

This does not apply to the current networking GIT tree, what tree is it against?

Thank you.
