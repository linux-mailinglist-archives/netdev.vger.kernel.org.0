Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD8E10940C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKYTOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:14:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfKYTOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:14:34 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1D3E1501071F;
        Mon, 25 Nov 2019 11:14:33 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:14:33 -0800 (PST)
Message-Id: <20191125.111433.742571582032938766.davem@davemloft.net>
To:     tglx@linutronix.de
CC:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: bpf and local lock
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 11:14:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thomas,

I am working on eliminating the explicit softirq disables around BPF
program invocation and replacing it with local lock usage instead.

We would really need to at least have the non-RT stubs upstream to
propagate this cleanly, do you think this is possible?

Thanks!
