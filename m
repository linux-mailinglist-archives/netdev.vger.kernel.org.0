Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79A9E5618
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfJYVmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:42:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:39178 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYVmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:42:50 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO7M7-0002tc-82; Fri, 25 Oct 2019 23:42:47 +0200
Date:   Fri, 25 Oct 2019 23:42:46 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        yhs@fb.com, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: fix .gitignore to ignore
 no_alu32/
Message-ID: <20191025214246.GC14547@pc-63.home>
References: <20191025045503.3043427-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025045503.3043427-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 09:55:03PM -0700, Andrii Nakryiko wrote:
> When switching to alu32 by default, no_alu32/ subdirectory wasn't added
> to .gitignore. Fix it.
> 
> Fixes: e13a2fe642bd ("tools/bpf: Turn on llvm alu32 attribute by default")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
