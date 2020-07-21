Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7038228212
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgGUOYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgGUOYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:24:36 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66099C061794;
        Tue, 21 Jul 2020 07:24:36 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 56F4A453;
        Tue, 21 Jul 2020 14:24:35 +0000 (UTC)
Date:   Tue, 21 Jul 2020 08:24:34 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     pmladek@suse.com, rostedt@goodmis.org,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Subject: Re: [PATCH] docs: core-api/printk-formats.rst: use literal block
 syntax
Message-ID: <20200721082434.504d5788@lwn.net>
In-Reply-To: <20200721140246.GB44523@jagdpanzerIV.localdomain>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
        <20200718165107.625847-8-dwlsalmeida@gmail.com>
        <20200721140246.GB44523@jagdpanzerIV.localdomain>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 23:02:46 +0900
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Jonathan, will you route it via the Documentation tree or do
> you want it to land in the printk tree?

I'm happy either way.  I'll grab it unless you tell me you'd rather pick
it up.

Thanks,

jon
