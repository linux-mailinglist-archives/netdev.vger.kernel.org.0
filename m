Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DFE1AF0E
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 05:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfEMDFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 23:05:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfEMDFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 23:05:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1154E14D7AA6C;
        Sun, 12 May 2019 20:05:11 -0700 (PDT)
Date:   Sun, 12 May 2019 20:05:06 -0700 (PDT)
Message-Id: <20190512.200506.1646556536928126872.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-05-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513001537.16720-1-daniel@iogearbox.net>
References: <20190513001537.16720-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 May 2019 20:05:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Mon, 13 May 2019 02:15:37 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) Fix out of bounds backwards jumps due to a bug in dead code
>    removal, from Daniel.
> 
> 2) Fix libbpf users by detecting unsupported BTF kernel features
>    and sanitize them before load, from Andrii.
> 
> 3) Fix undefined behavior in narrow load handling of context
>    fields, from Krzesimir.
> 
> 4) Various BPF uapi header doc/man page fixes, from Quentin.
> 
> 5) Misc .gitignore fixups to exclude built files, from Kelsey.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
