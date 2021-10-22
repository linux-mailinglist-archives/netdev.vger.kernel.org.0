Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9B24379C8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhJVPZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhJVPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:25:01 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCDC061764;
        Fri, 22 Oct 2021 08:22:43 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z69so5822098iof.9;
        Fri, 22 Oct 2021 08:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=iIU/h0cXJN8LE+xjx+K/Yd8w63aHnPiz8HAa7PBVIkk=;
        b=G5h0IXqulCd/vd9cFG2InrJ0d0CJaAyiUj4hg19LEsfC3g1dzKnVDXhYrD55XizE1I
         1Inm09r6O11tuVpMasO2RqmzDEL1lFiZ/9Uc/TboRsy8Rle+VpQt+klNCUoAbia1M0pP
         MIbwLrz1MSq5/yvpeQqBRPRUUPE5IuePCGcIXY3KSnOJr73jyoTamtEf2mbdOh8QsdW1
         Xg2zktXOuFjuKeCkwVYCM0L/+I48HbXlHuybWQLl8o1Q+8MZOh5ytCfCSsZbBTW9Ejy1
         VzZaSAt0VVooSKzMDzeHq0t2X0YRLSeFZV5oAJQlBJU2blbdxnE5pb/1I0F2q3/4MZNt
         AiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=iIU/h0cXJN8LE+xjx+K/Yd8w63aHnPiz8HAa7PBVIkk=;
        b=oMZBsZ+r7Fc1XIqEQAJ49kEo8UsTWvWAuWhJm8GGYGbu76i+Uxgb2WC5kZnei4Hn9L
         Saijn0Ob9EgpyZogKpLJ9T7jPUDWAOBSoQMviIXRQIOmyJFIQ2SO9Am7Oh5dWiDItAST
         DE3c+ET6wIQIOhYgzzDzuo5BP4QNL4Ju+SdHGcLSuBvPzPBWlAOXKjQX8tcKNUplgKTV
         466Qk9YcM2YLFjMIAw0jjLVjcE6o7Vphx+3e6XdiOyMrUpnByk9HBltzYb37p8gWBrwf
         HVmECV2Imux9m2lgBIc1F0GyHccvTBRSryrTwmFLB5VRz6fojpXvZapRUJKCkX0CJq/c
         SoZg==
X-Gm-Message-State: AOAM531MgA2rNJMFe6ieg82mFopjSnhgLKrCzUlbtS+nNNF8APMbqbtS
        glVsj6dfZ0pBakoKb6yvENvJjo5ERuLWprG/
X-Google-Smtp-Source: ABdhPJzovdfZUih6yfINvxuHt8mNfq1gU0ya8xIXuKrruzi5aJ4nCvCFr+H+n/7k/kGwgn4yiLpUZg==
X-Received: by 2002:a05:6638:190f:: with SMTP id p15mr341001jal.108.1634916163169;
        Fri, 22 Oct 2021 08:22:43 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id k9sm5287591ilo.46.2021.10.22.08.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 08:22:42 -0700 (PDT)
Date:   Fri, 22 Oct 2021 08:22:33 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        xiyou.wangcong@gmail.com
Cc:     liujian56@huawei.com
Message-ID: <6172d739dfbbe_82a7f2083b@john-XPS-13-9370.notmuch>
In-Reply-To: <20211012065705.224643-2-liujian56@huawei.com>
References: <20211012065705.224643-1-liujian56@huawei.com>
 <20211012065705.224643-2-liujian56@huawei.com>
Subject: RE: [PATHC bpf v5 2/3] selftests, bpf: Fix test_txmsg_ingress_parser
 error
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> After "skmsg: lose offset info in sk_psock_skb_ingress", the test case
> with ktls failed. This because ktls parser(tls_read_size) return value
> is 285 not 256.
> 
> the case like this:
> 	tls_sk1 --> redir_sk --> tls_sk2
> tls_sk1 sent out 512 bytes data, after tls related processing redir_sk
> recved 570 btyes data, and redirect 512 (skb_use_parser) bytes data to
> tls_sk2; but tls_sk2 needs 285 * 2 bytes data, receive timeout occurred.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  tools/testing/selftests/bpf/test_sockmap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
> index eefd445b96fc..06924917ad77 100644
> --- a/tools/testing/selftests/bpf/test_sockmap.c
> +++ b/tools/testing/selftests/bpf/test_sockmap.c
> @@ -1680,6 +1680,8 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
>  {
>  	txmsg_pass = 1;
>  	skb_use_parser = 512;
> +	if (ktls == 1)
> +		skb_use_parser = 570;
>  	opt->iov_length = 256;
>  	opt->iov_count = 1;
>  	opt->rate = 2;
> -- 
> 2.17.1
> 

Hi Liu LGTM sorry about the delay there I thought I acked this already, but
guess now.

Acked-by: John Fastabend <john.fastabend@gmail.com>
