Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6C23A12E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgHCIlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:41:31 -0400
Received: from sym2.noone.org ([178.63.92.236]:48458 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgHCIlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 04:41:31 -0400
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4BKrvr6mp8zvjcX; Mon,  3 Aug 2020 10:41:28 +0200 (CEST)
Date:   Mon, 3 Aug 2020 10:41:28 +0200
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        quentin@isovalent.com, kuba@kernel.org, toke@redhat.com,
        jolsa@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianjia.zhang@alibaba.com
Subject: Re: [PATCH] tools/bpf/bpftool: Fix wrong return value in do_dump()
Message-ID: <20200803084128.4ogaewayotcubff5@distanz.ch>
References: <20200802111540.5384-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802111540.5384-1-tianjia.zhang@linux.alibaba.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-02 at 13:15:40 +0200, Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> In case of btf_id does not exist, a negative error code -ENOENT
> should be returned.
> 
> Fixes: c93cc69004df3 ("bpftool: add ability to dump BTF types")
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

> ---
>  tools/bpf/bpftool/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index faac8189b285..c2f1fd414820 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -596,7 +596,7 @@ static int do_dump(int argc, char **argv)
>  			goto done;
>  		}
>  		if (!btf) {
> -			err = ENOENT;
> +			err = -ENOENT;
>  			p_err("can't find btf with ID (%u)", btf_id);
>  			goto done;
>  		}
> -- 
> 2.26.2
> 
