Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F068A281F0F
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJBXaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:30:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2BAC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 16:30:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F19AE11E59B88;
        Fri,  2 Oct 2020 16:13:28 -0700 (PDT)
Date:   Fri, 02 Oct 2020 16:30:15 -0700 (PDT)
Message-Id: <20201002.163015.1455703115237822567.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] ionic error recovery
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 16:13:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu,  1 Oct 2020 09:22:38 -0700

> This set of patches comes mostly from error recovery path testing,
> as well as a couple of upstream review comments.

Series applied, thank you.
