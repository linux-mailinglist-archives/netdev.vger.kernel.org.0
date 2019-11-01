Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6941ECB46
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKAWQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:16:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:16:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F848151B49EA;
        Fri,  1 Nov 2019 15:16:41 -0700 (PDT)
Date:   Fri, 01 Nov 2019 15:16:40 -0700 (PDT)
Message-Id: <20191101.151640.770389126832986989.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net 0/3] fix BPF offload related bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101030700.13080-1-jakub.kicinski@netronome.com>
References: <20191101030700.13080-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 15:16:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 31 Oct 2019 20:06:57 -0700

> test_offload.py catches some recently added bugs.
> 
> First of a bug in test_offload.py itself after recent changes
> to netdevsim is fixed.
> 
> Second patch fixes a bug in cls_bpf, and last one addresses
> a problem with the recently added XDP installation optimization.

Series applied and queued up for -stable.
