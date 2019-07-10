Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F0964C51
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfGJSmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:42:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfGJSmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:42:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F7DA149BDD38;
        Wed, 10 Jul 2019 11:42:19 -0700 (PDT)
Date:   Wed, 10 Jul 2019 11:42:16 -0700 (PDT)
Message-Id: <20190710.114216.2130803483894770828.davem@davemloft.net>
To:     iii@linux.ibm.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH v2 bpf] selftests/bpf: fix bpf_target_sparc check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710115654.44841-1-iii@linux.ibm.com>
References: <20190710115654.44841-1-iii@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jul 2019 11:42:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>
Date: Wed, 10 Jul 2019 13:56:54 +0200

> bpf_helpers.h fails to compile on sparc: the code should be checking
> for defined(bpf_target_sparc), but checks simply for bpf_target_sparc.
> 
> Also change #ifdef bpf_target_powerpc to #if defined() for consistency.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
