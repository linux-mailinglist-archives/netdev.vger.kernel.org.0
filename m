Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5868BDD5CF
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 02:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfJSAow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 20:44:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfJSAow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 20:44:52 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F50A1400E1F7;
        Fri, 18 Oct 2019 17:44:49 -0700 (PDT)
Date:   Fri, 18 Oct 2019 17:44:46 -0700 (PDT)
Message-Id: <20191018.174446.40623500298147190.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     toke@redhat.com, daniel@iogearbox.net, ast@fb.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, kubakici@wp.pl, yhs@fb.com
Subject: Re: [PATCH bpf] xdp: Prevent overflow in devmap_hash cost
 calculation for 32-bit builds
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAADnVQKDaMAVT6UxGy8w+CPUmzvgVWAjXmHexiz09yZJ8CbAeQ@mail.gmail.com>
References: <20191017105702.2807093-1-toke@redhat.com>
        <CAADnVQKDaMAVT6UxGy8w+CPUmzvgVWAjXmHexiz09yZJ8CbAeQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 17:44:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 18 Oct 2019 16:25:24 -0700

> gmail delivery lags by a day :(

Sorry, I'm working on that.
