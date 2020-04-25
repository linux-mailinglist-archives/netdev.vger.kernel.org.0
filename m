Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE9D1B8307
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 03:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDYB0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 21:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgDYB0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 21:26:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB11C09B049;
        Fri, 24 Apr 2020 18:26:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D798150733F3;
        Fri, 24 Apr 2020 18:26:31 -0700 (PDT)
Date:   Fri, 24 Apr 2020 18:26:30 -0700 (PDT)
Message-Id: <20200424.182630.995363180766596804.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-04-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200425005333.3305925-1-ast@kernel.org>
References: <20200425005333.3305925-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 18:26:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Fri, 24 Apr 2020 17:53:33 -0700

> The following pull-request contains BPF updates for your *net* tree.

Pulled, thanks Alexei.
