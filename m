Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BE9248F90
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHRUTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHRUTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:19:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535A6C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 13:19:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FECE127B5AC9;
        Tue, 18 Aug 2020 13:02:55 -0700 (PDT)
Date:   Tue, 18 Aug 2020 13:19:40 -0700 (PDT)
Message-Id: <20200818.131940.1414544499108292772.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/18] GVE Driver v1.1.0 Features.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 13:02:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Tue, 18 Aug 2020 12:43:59 -0700

> This patch series updates the GVE driver to v1.1.0 which broadly includes:
> - introducing "raw adressing" mode, which allows the driver avoid copies in
>   the guest.
> - increased stats coverage.
> - batching AdminQueue commands to the device.

This series is a bit too large.

Please sync with upstream more often so that you can submit smaller
patch sets, perhaps 10 or so patches at a time at most.
