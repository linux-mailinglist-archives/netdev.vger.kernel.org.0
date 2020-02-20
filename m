Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68741653B6
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTAmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:42:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgBTAmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:42:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 679D115BD9527;
        Wed, 19 Feb 2020 16:42:53 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:42:52 -0800 (PST)
Message-Id: <20200219.164252.2235102056249065952.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-02-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220003611.34197-1-ast@kernel.org>
References: <20200220003611.34197-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:42:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Wed, 19 Feb 2020 16:36:11 -0800

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 10 non-merge commits during the last 10 day(s) which contain
> a total of 10 files changed, 93 insertions(+), 31 deletions(-).
> 
> The main changes are:
> 
> 1) batched bpf hashtab fixes from Brian and Yonghong.
> 
> 2) various selftests and libbpf fixes.

Pulled, thanks Alexei.
