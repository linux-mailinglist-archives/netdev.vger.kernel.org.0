Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A3B64EB4
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfGJWbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:31:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfGJWbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 18:31:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8520814B5AA0F;
        Wed, 10 Jul 2019 15:31:18 -0700 (PDT)
Date:   Wed, 10 Jul 2019 15:31:16 -0700 (PDT)
Message-Id: <20190710.153116.614111233846989165.davem@davemloft.net>
To:     brendan.d.gregg@gmail.com
Cc:     kris.van.hees@oracle.com, daniel@iogearbox.net, corbet@lwn.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, peterz@infradead.org, clm@fb.com
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAE40pdeSVN+QhhUeQ4sEbsyzJ+NWkQA5XU5X0FrKAbRMHPzBsw@mail.gmail.com>
References: <1de27d29-65bb-89d3-9fca-7c452cd66934@iogearbox.net>
        <20190710213637.GB13962@oracle.com>
        <CAE40pdeSVN+QhhUeQ4sEbsyzJ+NWkQA5XU5X0FrKAbRMHPzBsw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jul 2019 15:31:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brendan Gregg <brendan.d.gregg@gmail.com>
Date: Wed, 10 Jul 2019 14:49:52 -0700

> Hey Kris -- so you're referring to me, and I've used DTrace more than
> anyone over the past 15 years, and I don't think anyone has used all
> the different Linux tracers more than I have. I think my opinion has a
> lot of value.

+1

I seriously am against starting to merge all of these userland tracing
tools into the tree.

They belong as separate independant projects, outside of the kernel
tree.
