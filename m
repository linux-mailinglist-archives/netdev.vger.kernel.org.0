Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC711AB0F2
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410319AbgDOTHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1416829AbgDOSgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 14:36:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BC1C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 11:35:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61E36128AE82A;
        Wed, 15 Apr 2020 11:35:58 -0700 (PDT)
Date:   Wed, 15 Apr 2020 11:35:57 -0700 (PDT)
Message-Id: <20200415.113557.54100582255049813.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-04-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415125904.22480-1-daniel@iogearbox.net>
References: <20200415125904.22480-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 11:35:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 15 Apr 2020 14:59:04 +0200

> The following pull-request contains BPF updates for your *net* tree.

Pulled, thanks Daniel.
