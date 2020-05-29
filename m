Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73FF1E8BA0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgE2W7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2W7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 18:59:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6E6C03E969;
        Fri, 29 May 2020 15:59:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 661831285B4F5;
        Fri, 29 May 2020 15:59:32 -0700 (PDT)
Date:   Fri, 29 May 2020 15:59:29 -0700 (PDT)
Message-Id: <20200529.155929.2303696841557171397.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-05-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529204716.32393-1-alexei.starovoitov@gmail.com>
References: <20200529204716.32393-1-alexei.starovoitov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 15:59:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 29 May 2020 13:47:16 -0700

> The following pull-request contains BPF updates for your *net* tree.

Pulled, thanks Alexei.
