Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA824C7DB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgHTWma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbgHTWm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:42:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73725C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 15:42:29 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3326F12868EA9;
        Thu, 20 Aug 2020 15:25:39 -0700 (PDT)
Date:   Thu, 20 Aug 2020 15:42:22 -0700 (PDT)
Message-Id: <20200820.154222.114300229292925699.davem@davemloft.net>
To:     antony.antony@secunet.com
Cc:     steffen.klassert@secunet.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, smueller@chronox.de,
        antony@phenome.org
Subject: Re: [PATCH ipsec-next v3] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820183549.GA823@moon.secunet.de>
References: <20200728154342.GA31835@moon.secunet.de>
        <20200820183549.GA823@moon.secunet.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 15:25:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>
Date: Thu, 20 Aug 2020 20:35:49 +0200

> Redacting secret is a FIPS 140-2 requirement.

Why not control this via the kernel lockdown mode rather than making
an ad-hoc API for this?

