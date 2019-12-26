Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1414E12AFB5
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfLZXZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:25:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:25:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C734B1539F551;
        Thu, 26 Dec 2019 15:25:22 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:25:22 -0800 (PST)
Message-Id: <20191226.152522.547752807327139189.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-12-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223144823.3456-1-daniel@iogearbox.net>
References: <20191223144823.3456-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:25:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Mon, 23 Dec 2019 15:48:23 +0100

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 2 non-merge commits during the last 1 day(s) which contain
> a total of 4 files changed, 34 insertions(+), 31 deletions(-).
> 
> The main changes are:
> 
> 1) Fix libbpf build when building on a read-only filesystem with O=dir
>    option, from Namhyung Kim.
> 
> 2) Fix a precision tracking bug for unknown scalars, from Daniel Borkmann.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
