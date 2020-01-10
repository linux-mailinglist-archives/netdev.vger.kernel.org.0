Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C8C1376DF
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgAJTWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:22:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgAJTWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:22:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA6711577D935;
        Fri, 10 Jan 2020 11:22:06 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:22:06 -0800 (PST)
Message-Id: <20200110.112206.136037463219370475.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        mallesham.jatharakonda@oneconvergence.com,
        simon.horman@netronome.com
Subject: Re: [PATCH net] net/tls: fix async operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110123832.1086-1-jakub.kicinski@netronome.com>
References: <20200110123832.1086-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 11:22:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 10 Jan 2020 04:38:32 -0800

> Mallesham reports the TLS with async accelerator was broken by
> commit d10523d0b3d7 ("net/tls: free the record on encryption error")
> because encryption can return -EINPROGRESS in such setups, which
> should not be treated as an error.
> 
> The error is also present in the BPF path (likely copied from there).
> 
> Reported-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence.com>
> Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied and queued up for -stable, thanks.
