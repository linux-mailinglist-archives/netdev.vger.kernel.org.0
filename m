Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D111C0CD0
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgEADxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:53:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547ACC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:53:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC75112777A71;
        Thu, 30 Apr 2020 20:53:21 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:53:21 -0700 (PDT)
Message-Id: <20200430.205321.1705954481436788731.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve max jumbo packet size
 definition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5571405c-3b2a-8669-320d-daa21f4c279c@gmail.com>
References: <5571405c-3b2a-8669-320d-daa21f4c279c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:53:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 28 Apr 2020 22:54:12 +0200

> Sync definition of max jumbo packet size with vendor driver and reserve
> 22 bytes for VLAN ethernet header plus checksum.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
