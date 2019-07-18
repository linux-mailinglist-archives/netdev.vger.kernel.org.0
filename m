Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40696D43F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfGRSzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:55:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfGRSzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 14:55:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E14F1527D810;
        Thu, 18 Jul 2019 11:55:35 -0700 (PDT)
Date:   Thu, 18 Jul 2019 11:55:34 -0700 (PDT)
Message-Id: <20190718.115534.1778444973119064345.davem@davemloft.net>
To:     jbenc@redhat.com
Cc:     sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, yhs@fb.com, daniel@iogearbox.net,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH AUTOSEL 5.2 226/249] selftests: bpf: fix inlines in
 test_lwt_seg6local
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718093654.0a3426f5@redhat.com>
References: <20190717114334.5556a14e@redhat.com>
        <20190717234757.GD3079@sasha-vm>
        <20190718093654.0a3426f5@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 11:55:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>
Date: Thu, 18 Jul 2019 09:36:54 +0200

> On Wed, 17 Jul 2019 19:47:57 -0400, Sasha Levin wrote:
>> It fixes a bug, right?
> 
> A bug in selftests. And quite likely, it probably happens only with
> some compiler versions.
> 
> I don't think patches only touching tools/testing/selftests/ qualify
> for stable in general. They don't affect the end users.

It has a significant impact on automated testing which lots of
individuals and entities perform, therefore I think it very much is
-stable material.
