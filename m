Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB095B3689
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiIILjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiIILjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:39:37 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FC113CB3B;
        Fri,  9 Sep 2022 04:39:12 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id BB21DC009; Fri,  9 Sep 2022 13:39:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662723547; bh=Qqwt0vBVIvZRqd4nvturax93UCC/svGIe5vYpDqGjUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8x667VIoVd4x9lJxLJ2ctVSxhNWHgM1Y07msr8orfCj7UM+xUOAWaecJenfGQ6zW
         OdIiZ7k5sCBfVYmQC9v1QsisZP3Jdbbknofuh3aHumy55CntwZy0l9OnI462OSkM8j
         p1iM57/Hnjlyh03YwNnoHA+hz20DWLzx8chUD95G6mSHYpPbxgUBbXqi790q82T43F
         7CqhLMnj/pDtukAkj3QrmKh4WA0qnpWiMcdaPK+naT5tKdojklaSe9K9NnSD3kqrPU
         Qp2PcFRXU/efZasoyZG37Wk4Vdjd/cY+Gu2/Pv/U0dnyCAJLXuGJoI+tOH7pUZ5hVC
         RwvzBHzwo0cKA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E802AC009;
        Fri,  9 Sep 2022 13:38:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662723546; bh=Qqwt0vBVIvZRqd4nvturax93UCC/svGIe5vYpDqGjUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e7VKEWyZuY4lrG8Efk0aJlSk+Z5funJd1NRS4hGL4LhSKjDztUHbT/lR+Zzq8FWud
         bzWLesLkW5QICabeoXEyLb02g2fKqDEI3TyR8KQQ3rHgToT3f6dZ/GDwGq/FnQTT7+
         bFl8E8Dre18izlGLezlP3nIFVJ4fyPEsAz7AGeKCSkZBcDMR1ORZiQ4glgsyRJl5W9
         iN5BB+Dbo8RUBgiP0KW9/2FnS6e3Vzf4Xm2VZz2OTeNgCFz1CLckHKIDnrpkNzJGai
         +dunyA3IkEAX5G6tDn/mSVSTsIyRa0T6VIxpiQ6ynb1YUhHDvHZIIAJ62U1hyYC2XG
         LovW+ZdKu5R2w==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a37b6550;
        Fri, 9 Sep 2022 11:38:57 +0000 (UTC)
Date:   Fri, 9 Sep 2022 20:38:42 +0900
From:   asmadeus@codewreck.org
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/9p: add __init/__exit annotations to module
 init/exit funcs
Message-ID: <YxslwvLFLTdT2R9z@codewreck.org>
References: <20220909103546.73015-1-xiujianfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220909103546.73015-1-xiujianfeng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiu Jianfeng wrote on Fri, Sep 09, 2022 at 06:35:46PM +0800:
> Add missing __init/__exit annotations to module init/exit funcs.

sure, queueing.

FWIW I've checked the others all seem to have it.

> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  net/9p/trans_xen.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> index 41c57d40efb6..b15c64128c3e 100644
> --- a/net/9p/trans_xen.c
> +++ b/net/9p/trans_xen.c
> @@ -511,7 +511,7 @@ static struct xenbus_driver xen_9pfs_front_driver = {
>  	.otherend_changed = xen_9pfs_front_changed,
>  };
>  
> -static int p9_trans_xen_init(void)
> +static int __init p9_trans_xen_init(void)
>  {
>  	int rc;
>  
> @@ -530,7 +530,7 @@ static int p9_trans_xen_init(void)
>  module_init(p9_trans_xen_init);
>  MODULE_ALIAS_9P("xen");
>  
> -static void p9_trans_xen_exit(void)
> +static void __exit p9_trans_xen_exit(void)
>  {
>  	v9fs_unregister_trans(&p9_xen_trans);
>  	return xenbus_unregister_driver(&xen_9pfs_front_driver);
