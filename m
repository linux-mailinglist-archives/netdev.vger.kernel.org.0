Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD95E5520
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiIUVYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIUVYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:24:02 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074EB9A9E6
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:23:59 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0082FC01F; Wed, 21 Sep 2022 23:23:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1663795437; bh=Hk7ZZrOLXWtgfdRaSKqvrZagleJmeKAvZfrxZ3V1+4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYQ2cDBAwopsGdCH7OTuS9wsK3xQ8vbB1T5KIDEa+lSwH52s9qyZVsfiVM1EtvKZ/
         39Xsrv6QrPfxbx4xxlieFXVPvyLuX6I4YVMv9ZmHiBAj+Zb08ytemFw9W/NEdHLBkA
         1C6FIE42N8llZ0UP6aJ8g3mCcgbbbqv/rs6fjtBNyQdr1uC1LV7WkBj3WYqfHayJcZ
         +MoxWQdSGPDAwL9w7IPfLaerONlZ04J4MtnnfSSaUo+AZ0lX/Yl9GqIfAY/MkYB8tv
         mWgqoMpumm7nXGROoJBI4SVsJwpgwYPGQxMM+HTqwLjlsO4V0z5TzyKd4e+FnpUEHE
         MUqPTtIkqmzzw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0C307C009;
        Wed, 21 Sep 2022 23:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1663795435; bh=Hk7ZZrOLXWtgfdRaSKqvrZagleJmeKAvZfrxZ3V1+4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FGhJLRqd/qL7kQAGs0r9yDBb1BBTsU4zmbDGuzRBflqJjcoOoskTvIS8EM+qTjqMS
         0IrncS25vBY6uO854sulwPF3NRoS68n7a2XrvtMRBmyNsrgbA8uc4xYbraNV4yztTG
         nfcOWy73CyOWftTzG0KIdf0DMPAIE/GFQkJ+5V8aP4+Nqclv3SR2/WlwXo0t8k/BPr
         G4gCsGCkaSHqccsPFJ87WNXJBrvLBDw5alDb+60hFYnIW0krPK5VluEGV3To2xgN8X
         sruGUbpUIa+pR9qnlAOrZsw6eh1eUL20t8id4VCbN6RQ/6HOFRTJ5H9fx/toeXPP/0
         sPIWWyoImckpw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 69357d36;
        Wed, 21 Sep 2022 21:23:50 +0000 (UTC)
Date:   Thu, 22 Sep 2022 06:23:35 +0900
From:   asmadeus@codewreck.org
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux_oss@crudebyte.com, lucho@ionkov.net,
        ericvh@gmail.com
Subject: Re: [PATCH net-next v1] net/9p/trans_fd: check the return value of
 parse_opts
Message-ID: <YyuA13q/B236lZ6U@codewreck.org>
References: <20220921210921.1654735-1-floridsleeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921210921.1654735-1-floridsleeves@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Zhong wrote on Wed, Sep 21, 2022 at 02:09:21PM -0700:
> parse_opts() could fail when there is error parsing mount options into
> p9_fd_opts structure due to allocation failure. In that case opts will
> contain invalid data.

In practice opts->rfd/wfd is set to ~0 before the failure modes so they
will contain exactly what we want them to contain: something that'll
fail the check below.

It is however cleared like this so I'll queue this patch in 9p tree when
I have a moment, but I'll clarify the commit message to say this is
NO-OP : please feel free to send a v2 if you want to put your own words
in there; otherwise it'll be something like below:
----
net/9p: clarify trans_fd parse_opt failure handling

This parse_opts will set invalid opts.rfd/wfd in case of failure which
we already check, but it is not clear for readers that parse_opts error
are handled in p9_fd_create: clarify this by explicitely checking the
return value.
----


Also, in practice args != null doesn't seem to be checked before (the
parse_opt() in client.c allows it) so keeping the error message common
might be better?
(allocation failure will print its own messages anyway and doesn't need
checking)

> 
> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> ---
>  net/9p/trans_fd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index e758978b44be..11ae64c1a24b 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -1061,7 +1061,9 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
>  	int err;
>  	struct p9_fd_opts opts;
>  
> -	parse_opts(args, &opts);
> +	err = parse_opts(args, &opts);
> +	if (err < 0)
> +		return err;
>  	client->trans_opts.fd.rfd = opts.rfd;
>  	client->trans_opts.fd.wfd = opts.wfd;
>  
