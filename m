Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26DF220C4
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 01:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfEQXkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 19:40:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49856 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbfEQXkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 19:40:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 659C8148B0902;
        Fri, 17 May 2019 16:40:05 -0700 (PDT)
Date:   Fri, 17 May 2019 16:40:03 -0700 (PDT)
Message-Id: <20190517.164003.1708534443599690709.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-05-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190517231400.9315-1-daniel@iogearbox.net>
References: <20190517231400.9315-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 16:40:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat, 18 May 2019 01:14:00 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) Fix bpftool's raw BTF dump in relation to forward declarations of union/
>    structs, and another fix to unexport logging helpers, from Andrii.
> 
> 2) Fix inode permission check for retrieving bpf programs, from Chenbo.
> 
> 3) Fix bpftool to raise rlimit earlier as otherwise libbpf's feature probing
>    can fail and subsequently it refuses to load an object, from Yonghong.
> 
> 4) Fix declaration of bpf_get_current_task() in kselftests, from Alexei.
> 
> 5) Fix up BPF kselftest .gitignore to add generated files, from Stanislav.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
