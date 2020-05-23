Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED561DF3D8
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 03:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgEWBaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 21:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387418AbgEWBaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 21:30:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFF6C061A0E;
        Fri, 22 May 2020 18:30:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 368391277A238;
        Fri, 22 May 2020 18:30:53 -0700 (PDT)
Date:   Fri, 22 May 2020 18:30:49 -0700 (PDT)
Message-Id: <20200522.183049.2272813444321523275.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-05-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200523002608.31415-1-daniel@iogearbox.net>
References: <20200523002608.31415-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 18:30:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat, 23 May 2020 02:26:08 +0200

> The following pull-request contains BPF updates for your *net-next* tree.

Pulled, thanks Daniel.
