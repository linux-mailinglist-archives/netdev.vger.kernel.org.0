Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72DB1CFE22
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgELTTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELTTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:19:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB423C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:19:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76E8012831EEB;
        Tue, 12 May 2020 12:19:47 -0700 (PDT)
Date:   Tue, 12 May 2020 12:19:46 -0700 (PDT)
Message-Id: <20200512.121946.1198782185977271337.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] ionic updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 12:19:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 11 May 2020 17:59:26 -0700

> This set of patches is a bunch of code cleanup, a little
> documentation, longer tx sg lists, more ethtool stats,
> and a couple more transceiver types.

Series applied to net-next, thanks.
