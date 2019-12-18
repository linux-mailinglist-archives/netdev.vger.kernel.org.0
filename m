Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0E01245E3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfLRLgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:36:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:36216 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfLRLgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 06:36:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6BDFEAA35;
        Wed, 18 Dec 2019 11:36:43 +0000 (UTC)
Date:   Wed, 18 Dec 2019 12:36:42 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sergey.senozhatsky@gmail.com, wangkefeng.wang@huawei.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] tools lib api fs: fix gcc9 compilation error
Message-ID: <20191218113642.2hw5rx2t6f277b3b@pathway.suse.cz>
References: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2019-12-11 08:01:09, Andrey Zhizhikin wrote:
> GCC9 introduced string hardening mechanisms, which exhibits the error
> during fs api compilation:
> 
> error: '__builtin_strncpy' specified bound 4096 equals destination size
> [-Werror=stringop-truncation]
> 
> This comes when the length of copy passed to strncpy is is equal to
> destination size, which could potentially lead to buffer overflow.
> 
> There is a need to mitigate this potential issue by limiting the size of
> destination by 1 and explicitly terminate the destination with NULL.
> 
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
