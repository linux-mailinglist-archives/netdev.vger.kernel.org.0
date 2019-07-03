Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC585E243
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGCKnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfGCKnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 06:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0292D218A0;
        Wed,  3 Jul 2019 10:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562150612;
        bh=rtDwzSnNcOQGNWFdCc1Bop63mTOkGYGEB+m7tqXFlm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zJuASnOIQ3MT+bbM+Sz0FCw91geKA+AuC/9yWArXtPEJXVCPJ+lqQh1JUR4d/wtPU
         lXB+SORru4EBjr/Q+Dy+4LF6VSUuUaaFw2XtYeJ/Bt3dH9Pc3pJnX7w+sRP1qJEGNY
         CotA44WUtO/aOvwVu0vfu6T3E1frrWEhgG+rSYJk=
Date:   Wed, 3 Jul 2019 12:43:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Markus Elfring <Markus.Elfring@web.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bpf: Replace a seq_printf() call by seq_puts() in
 btf_enum_seq_show()
Message-ID: <20190703104330.GA8931@kroah.com>
References: <93898abe-9a7d-0c64-0856-094b62e07ba2@web.de>
 <e0c9978f-7304-8a25-1bc9-b2be8a038382@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0c9978f-7304-8a25-1bc9-b2be8a038382@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:09:51PM +0200, Daniel Borkmann wrote:
> On 07/02/2019 07:13 PM, Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Tue, 2 Jul 2019 19:04:08 +0200
> > 
> > A string which did not contain a data format specification should be put
> > into a sequence. Thus use the corresponding function “seq_puts”.
> > 
> > This issue was detected by using the Coccinelle software.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> 
> The code is fine as is, I'm not applying this.

Just a heads up, this person/bot is in my kill-file, making it easier to
ignore crazy things like this.  I recommend it for other maintainers to
also do as well.

thanks,

greg k-h
