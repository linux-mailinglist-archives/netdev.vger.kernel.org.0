Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EC531B8E
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbiEWQdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238913AbiEWQdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:33:07 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7376263BD9
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:33:04 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 81EB024010C
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 18:33:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1653323582; bh=E6iZA4QlAEqZYtAGHcnkUWkJeE0/rqfh0rH2XYscpAQ=;
        h=Date:From:To:Cc:Subject:From;
        b=ozh1QoMER5nXrKBy1vPesgFS/Tr2uEFDx7yT+vJZ1RGSXs2r0fpU1+RYQRd/cw6K2
         ud1S2ZBZUKE0hCjD8Iy368KLE0OjAr8FrzbaIYYfz9Sf8WD3newzuNfS8s2w5OjOZF
         bcgeQ+AfRtQBkOaV+w15pcp1WiHLqOveFXZ/OOgCZSTYlkQ1Bm5YYfuufzWRqEUthQ
         yl4l+gI4uJ8PlUmEBOyXVoUZD+QJAAmgt+U6XY3MGIyGrF9N/wMSrS+ayCjSYKTi8H
         cK4v+KFHPvW1sXk/eeG6gD+PcTG1QQXqLr7oJBHhMdYzKx/2WVi6Xhp+s5RDU5juYK
         rdwxaFNp9XAYA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4L6ND84p99z6tmK;
        Mon, 23 May 2022 18:32:55 +0200 (CEST)
Date:   Mon, 23 May 2022 16:32:52 +0000
From:   Daniel =?utf-8?Q?M=C3=BCller?= <deso@posteo.net>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        kernel-janitors@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libbpf: fix typo in comment
Message-ID: <20220523163030.uvauyhslqenc7m44@muellerd-fedora-MJ0AC3F3>
References: <20220521111145.81697-71-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220521111145.81697-71-Julia.Lawall@inria.fr>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 01:11:21PM +0200, Julia Lawall wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  tools/lib/bpf/libbpf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ef7f302e542f..e89cc9c885b3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6873,7 +6873,7 @@ static int bpf_object_load_prog_instance(struct bpf_object *obj, struct bpf_prog
>  	}
>  
>  retry_load:
> -	/* if log_level is zero, we don't request logs initiallly even if
> +	/* if log_level is zero, we don't request logs initially even if
>  	 * custom log_buf is specified; if the program load fails, then we'll
>  	 * bump log_level to 1 and use either custom log_buf or we'll allocate
>  	 * our own and retry the load to get details on what failed
> 

Looks good to me, thanks!

Acked-by: Daniel Müller <deso@posteo.net>
