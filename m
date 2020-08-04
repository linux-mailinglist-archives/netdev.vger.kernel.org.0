Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5323B272
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgHDBpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgHDBpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:45:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4A4C06174A;
        Mon,  3 Aug 2020 18:45:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41C4A12790FA9;
        Mon,  3 Aug 2020 18:28:31 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:45:15 -0700 (PDT)
Message-Id: <20200803.184515.1642003997353340419.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-08-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803235640.31210-1-daniel@iogearbox.net>
References: <20200803235640.31210-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:28:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue,  4 Aug 2020 01:56:40 +0200

> The following pull-request contains BPF updates for your *net-next* tree.

Pulled, there was a minor conflict in net/core/dev.c please double check
my work.

Thank you!
