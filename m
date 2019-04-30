Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACF5FD07
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfD3Piz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:38:55 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:41659 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3Piz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:38:55 -0400
Received: (qmail 35411 invoked by uid 89); 30 Apr 2019 15:38:54 -0000
Received: from unknown (HELO ?172.26.104.201?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC40) (POLARISLOCAL)  
  by smtp5.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 30 Apr 2019 15:38:54 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, u9012063@gmail.com
Subject: Re: [PATCH bpf 0/2] libbpf: fixes for AF_XDP teardown
Date:   Tue, 30 Apr 2019 08:38:49 -0700
X-Mailer: MailMate (1.12.4r5594)
Message-ID: <15B5FD82-D048-416F-9D1E-7F2B675100DA@flugsvamp.com>
In-Reply-To: <20190430124536.7734-1-bjorn.topel@gmail.com>
References: <20190430124536.7734-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; markup=markdown
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Apr 2019, at 5:45, Björn Töpel wrote:

> William found two bugs, when doing socket teardown within the same
> process.
>
> The first issue was an invalid munmap call, and the second one was an
> invalid XSKMAP cleanup. Both resulted in that the process kept
> references to the socket, which was not correctly cleaned up. When a
> new socket was created, the bind() call would fail, since the old
> socket was still lingering, refusing to give up the queue on the
> netdev.
>
> More details can be found in the individual commits.

Reviewed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
