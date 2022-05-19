Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4752C96A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiESBrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiESBrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:47:19 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B297FC039C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:47:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c22so3742443pgu.2
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GPC5OPy5Dowf9yMYqglcevGDq02xGifndXCnLcOOAQs=;
        b=LL6ZQ1k9dbxeYAgSV2xnXitK10yBUJzUXmL8pck+UpxonU1fr1F/5rq0KzVWpHOWJe
         Lbln8eQwx4QKIZ+HmFsMueJK6bFbKjWuPzJhGVfluvFENv2SkwP2LXxMTJK5Zmv6usqn
         l/4X18mB0FRYciYlohMQkqAICvFfJhNSlSuUpWuM9RPLh1vgB8FLiR2K/tJqaPUs8y1D
         l6TAcXAjlZumMkERsI+k3VICwVEM/v1o7aHZn9U2hNfaervnMXjmmmqrTPEsMab9ckFm
         arieFuUWg3AOLvBhE4sP3rZGZIHPaHGCdfeMSX6iznSGTg2RHy7Hsrw8DnzP3vzDQJ4y
         zZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GPC5OPy5Dowf9yMYqglcevGDq02xGifndXCnLcOOAQs=;
        b=AypuhISpvtdx5fBammW0PM85YRUW7+/efUdZcHRUUe1pvnJ1awjQQ7kyNCAQF2gzN1
         +fWxuljL/yNfPIRJEqAj75x50pUdymM6eJMw75SXZerIVlG2gCcD9b6Ef0STu0XntYVM
         ZqN2xR3g4+mKXkWJnuG9F8Yuxs6c2k+Hkms8eHRH6rhdJBN19fHc5f7tuH6WLSjyA/Zv
         Tai77J/UNqFch+kxc5boOKJloVauK5B8EatCC8hbt/5yS2ZXJEh2DUP3NthRYgnuk9xv
         hqpdGT96Z0i3PwyxadI9ocwMB08VRt6S8Fa8DezY+0tKF9S0c/FSK+CkcDzyZuUVkQ9V
         cIgw==
X-Gm-Message-State: AOAM531mldGwzM42JgrOn8/Xo2I2WaFCl5h6t5eiqsLdOE3+3BDgyPio
        zARtJ1SXa01k2/ELwYfxn7w=
X-Google-Smtp-Source: ABdhPJy1o83eiCQvXEGIE8+PChiIgJLvrEESjFsZJGsycjgw1d9BHPmgG/HZHJyK2HQgLhSXQfCcmw==
X-Received: by 2002:a63:ec54:0:b0:3c6:aa29:15fe with SMTP id r20-20020a63ec54000000b003c6aa2915femr1913096pgj.552.1652924838200;
        Wed, 18 May 2022 18:47:18 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 190-20020a6206c7000000b0050dc7628188sm2599002pfg.98.2022.05.18.18.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 18:47:17 -0700 (PDT)
Date:   Thu, 19 May 2022 09:47:12 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Joachim Wiberg <troglobit@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/1] selftests: forwarding: fix missing backslash
Message-ID: <YoWhoNd+Mgi4BITq@Laptop-X1>
References: <20220518151630.2747773-1-troglobit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518151630.2747773-1-troglobit@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 05:16:30PM +0200, Joachim Wiberg wrote:
> Fix missing backslash, introduced in f62c5acc800ee.  Causes all tests to
> not be installed.
> 
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
> index b5181b5a8e29..8f481218a492 100644
> --- a/tools/testing/selftests/net/forwarding/Makefile
> +++ b/tools/testing/selftests/net/forwarding/Makefile
> @@ -88,7 +88,7 @@ TEST_PROGS = bridge_igmp.sh \
>  	vxlan_bridge_1d_port_8472.sh \
>  	vxlan_bridge_1d.sh \
>  	vxlan_bridge_1q_ipv6.sh \
> -	vxlan_bridge_1q_port_8472_ipv6.sh
> +	vxlan_bridge_1q_port_8472_ipv6.sh \
>  	vxlan_bridge_1q_port_8472.sh \
>  	vxlan_bridge_1q.sh \
>  	vxlan_symmetric_ipv6.sh \
> -- 
> 2.25.1
> 

Opps, sorry for the mistake and thanks for your fix.

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
