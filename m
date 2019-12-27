Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B5712BB96
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 23:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfL0WUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 17:20:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfL0WUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 17:20:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD35B154CAEA0;
        Fri, 27 Dec 2019 14:20:42 -0800 (PST)
Date:   Fri, 27 Dec 2019 14:20:42 -0800 (PST)
Message-Id: <20191227.142042.195965541160730299.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, bjorn.topel@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2019-12-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227180817.30438-1-daniel@iogearbox.net>
References: <20191227180817.30438-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 14:20:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 27 Dec 2019 19:08:17 +0100

> The following pull-request contains BPF updates for your *net-next* tree.

Pulled and conflicts resolved as per your description, thanks!

I'll push out after some quick build testing.
