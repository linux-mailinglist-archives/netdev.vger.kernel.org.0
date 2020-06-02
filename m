Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B01EC543
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgFBWsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbgFBWsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:48:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22888C08C5C0;
        Tue,  2 Jun 2020 15:48:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E289127813A2;
        Tue,  2 Jun 2020 15:48:07 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:48:06 -0700 (PDT)
Message-Id: <20200602.154806.1896300280757442947.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-06-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602204051.29623-1-daniel@iogearbox.net>
References: <20200602204051.29623-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:48:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue,  2 Jun 2020 22:40:51 +0200

> The following pull-request contains BPF _fixes-only_ for your
> *net-next* tree.

Pulled, thanks Daniel.
