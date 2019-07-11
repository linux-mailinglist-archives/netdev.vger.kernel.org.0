Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E9865F7B
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfGKSdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:33:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbfGKSdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 14:33:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF20214B55F4F;
        Thu, 11 Jul 2019 11:33:45 -0700 (PDT)
Date:   Thu, 11 Jul 2019 11:33:43 -0700 (PDT)
Message-Id: <20190711.113343.906691840255971211.davem@davemloft.net>
To:     gor@linux.ibm.com
Cc:     ast@kernel.org, daniel@iogearbox.net, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, iii@linux.ibm.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update BPF JIT S390 maintainers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <your-ad-here.call-01562758494-ext-2794@work.hours>
References: <patch.git-d365382dfc69.your-ad-here.call-01562755343-ext-3127@work.hours>
        <your-ad-here.call-01562758494-ext-2794@work.hours>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 11:33:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>
Date: Wed, 10 Jul 2019 13:34:54 +0200

> Dave, Alexei, Daniel,
> would you take it via one of your trees? Or should I take it via s390?

I think it can go via the bpf tree.
