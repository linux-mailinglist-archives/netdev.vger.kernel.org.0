Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4F842679E
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbhJHKXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239781AbhJHKXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:23:18 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A63DC061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 03:21:23 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AC8BE4FED5496;
        Fri,  8 Oct 2021 03:21:21 -0700 (PDT)
Date:   Fri, 08 Oct 2021 11:21:20 +0100 (BST)
Message-Id: <20211008.112120.2199833042672429285.davem@davemloft.net>
To:     jeroendb@google.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, yangchun@google.com,
        csully@google.com, awogbemila@google.com
Subject: Re: [PATCH net-next 1/7] gve: Switch to use napi_complete_done
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Oct 2021 03:21:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please post a patch series with a proper [PATCH 00/NN] header posting
explaining what the series does, how it does it, and why it does it
thast way.

Thank you.
