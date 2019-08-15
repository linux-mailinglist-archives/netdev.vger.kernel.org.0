Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09198F4B0
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbfHOTdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:33:54 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:61284 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfHOTdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:33:54 -0400
Received: (qmail 35549 invoked by uid 89); 15 Aug 2019 19:33:52 -0000
Received: from unknown (HELO ?172.20.53.208?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzk=) (POLARISLOCAL)  
  by smtp2.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 15 Aug 2019 19:33:52 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        yhs@fb.com, andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Date:   Thu, 15 Aug 2019 12:33:44 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <2D5AB510-F3F1-4215-B9D6-CE576CC474B0@flugsvamp.com>
In-Reply-To: <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:

> For 64-bit there is no reason to use vmap/vunmap, so use page_address
> as it was initially. For 32 bits, in some apps, like in samples
> xdpsock_user.c when number of pgs in use is quite big, the kmap
> memory can be not enough, despite on this, kmap looks like is
> deprecated in such cases as it can block and should be used rather
> for dynamic mm.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
