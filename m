Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F7E104881
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKUC3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:29:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUC3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 21:29:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DC5814D39482;
        Wed, 20 Nov 2019 18:29:32 -0800 (PST)
Date:   Wed, 20 Nov 2019 18:29:29 -0800 (PST)
Message-Id: <20191120.182929.2182043262909945603.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2019-11-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121000510.18946-1-daniel@iogearbox.net>
References: <20191121000510.18946-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 18:29:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 21 Nov 2019 01:05:10 +0100

> The following pull-request contains BPF updates for your *net-next* tree.

Pulled, thanks for the conflict guidance.
