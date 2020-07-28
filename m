Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA7A23140E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgG1Ugm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgG1Ugl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:36:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B923EC061794;
        Tue, 28 Jul 2020 13:36:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E37B5128AEB6D;
        Tue, 28 Jul 2020 13:19:55 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:36:40 -0700 (PDT)
Message-Id: <20200728.133640.26825961573580404.davem@davemloft.net>
To:     johan@kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: lan78xx: fix NULL deref and memory leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728121031.12323-1-johan@kernel.org>
References: <20200728121031.12323-1-johan@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 13:19:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hovold <johan@kernel.org>
Date: Tue, 28 Jul 2020 14:10:28 +0200

> The first two patches fix a NULL-pointer dereference at probe that can
> be triggered by a malicious device and a small transfer-buffer memory
> leak, respectively.
> 
> For another subsystem I would have marked them:
> 
> 	Cc: stable@vger.kernel.org	# 4.3
> 
> The third one replaces the driver's current broken endpoint lookup
> helper, which could end up accepting incomplete interfaces and whose
> results weren't even useeren

Series applied and queued up for -stable.
