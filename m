Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4633ED49E4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfJKV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:29:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:50210 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfJKV3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:29:46 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iJ2To-0007KN-22; Fri, 11 Oct 2019 23:29:44 +0200
Date:   Fri, 11 Oct 2019 23:29:43 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: handle invalid typedef emitted by old
 GCC
Message-ID: <20191011212943.GA21367@pc-63.home>
References: <20191011032901.452042-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011032901.452042-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25599/Fri Oct 11 10:48:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:29:01PM -0700, Andrii Nakryiko wrote:
> Old GCC versions are producing invalid typedef for __gnuc_va_list
> pointing to void. Special-case this and emit valid:
> 
> typedef __builtin_va_list __gnuc_va_list;
> 
> Reported-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
