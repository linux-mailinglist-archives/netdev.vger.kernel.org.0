Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E682553EE76
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiFFTVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 15:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiFFTV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 15:21:27 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB41483E4;
        Mon,  6 Jun 2022 12:20:56 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id r9-20020a4acb09000000b0041b6abb517fso1242226ooq.2;
        Mon, 06 Jun 2022 12:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oef6ymS4Jl6PqJR3yx4neoTSwD3FA1YE1bXcGPJv9eY=;
        b=b3dhqlhK5NC+x+uaNqJON3sFRUQkX1UJcPoRAWcyjsBkUDor5u57dkwbSlLyXfMolc
         riiCLR3Y1cU7mCoV5KhcvYN4IofHdGQA6WuCflgruCx2JjZ+Vytpi1yvnWh7F061glc6
         U2zc7f3nS8tQKACm2jjr73hbmHH1W36tif1ZKa+WngcIQFL+sGuXhnk844hm55isolB/
         ehp7bhNmwvAE9BYxLIy3EmsOFDykP4qaqn7Mhu70dTEvayT3q05GbCDT8FBksH1dXpgX
         Tv3yhC9PqwfjK6bar9y2u590CzMJEHs/pujZMfTOynNNcfuMqHTn16HgdoeH/MdZXJXI
         w3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oef6ymS4Jl6PqJR3yx4neoTSwD3FA1YE1bXcGPJv9eY=;
        b=N6OHfYDSHQfe/eB1JR/3V2+OcmPjv/MCiUhMDTJjeEgja786+J6s0NzpkcIx/os+IR
         54aF3Ic4kfaqxV33m0br7omGi+YoiX0rci1MxJHfv7cGK93rjnZyxnFYeVTuyo0J42WG
         v0WRlbhE7tFElLBxBCrELR6Z5SqIssX+dJlCcteL7PI5XrkjSGggXq3hWXcqw9PXoEdZ
         qCvZkkDI42gn4UAydwGhk1Y3OfSFu6JdYn2KxxbEml/yU+4H7ycadmEKnN+e1nYU7XB9
         atvSC43rKPeH/Svv970+FPJ7ZXakR67uNK56s5+/4jFkWSnnYuT4c4qSWOlXIcn4JhnQ
         F6Ww==
X-Gm-Message-State: AOAM531YMwlk6Ta0nmUVUIb3qDgx7yq3MHAoyMhhqokpQ8Apv9dz4tKq
        59gxfr009SZSqclpSmTseoY=
X-Google-Smtp-Source: ABdhPJx0JXp4JILM1SJdapDufnnGzWzVR+r6rc4+fl8ur9Jr373chDlnxF9vqt957NMU+xaovckrmQ==
X-Received: by 2002:a4a:ad0a:0:b0:35e:79da:30c7 with SMTP id r10-20020a4aad0a000000b0035e79da30c7mr10645563oon.53.1654543255366;
        Mon, 06 Jun 2022 12:20:55 -0700 (PDT)
Received: from t14s.localdomain ([168.194.162.103])
        by smtp.gmail.com with ESMTPSA id d1-20020a05683025c100b0060603221236sm8359429otu.6.2022.06.06.12.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 12:20:54 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 1B2A32C8BD9; Mon,  6 Jun 2022 16:20:53 -0300 (-03)
Date:   Mon, 6 Jun 2022 16:20:53 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net 2/3] Documentation: add description for
 net.sctp.intl_enable
Message-ID: <Yp5TlffV0mIdg7Qp@t14s.localdomain>
References: <cover.1654279751.git.lucien.xin@gmail.com>
 <1fc59e854d7b9c66f4ab681dbe2a9eb91219f3a4.1654279751.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fc59e854d7b9c66f4ab681dbe2a9eb91219f3a4.1654279751.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 03, 2022 at 02:09:24PM -0400, Xin Long wrote:
> Describe it in networking/ip-sysctl.rst like other SCTP options.
> We need to document this especailly as when using the feature
                           especially

> of User Message Interleaving, some socket options also needs
> to be set.
> 
> Fixes: 463118c34a35 ("sctp: support sysctl to allow users to use stream interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 3abd494053a9..b67f2f83ff32 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2941,6 +2941,20 @@ reconf_enable - BOOLEAN
>  
>  	Default: 0
>  
> +intl_enable - BOOLEAN
> +        Enable or disable extension of User Message Interleaving functionality
> +        specified in RFC8260. This extension allow the interleaving of user
                                                allows

> +        messages sent on different streams. With this feature enabled, I-DATA
> +        chunk will replace DATA chunk to carry user messages. Note that to use

.. to carry user messages if also supported by the peer.

> +        this feature, with this option set to 1, we also need socket options
> +        SCTP_FRAGMENT_INTERLEAVE set to 2 and SCTP_INTERLEAVING_SUPPORTED set
> +        to 1.

Perhaps for this last sentence:
Note that to use this feature, one needs to set this option to 1 and
also need to set socket options SCTP_FRAGMENT_INTERLEAVE to 2 and
SCTP_INTERLEAVING_SUPPORTED to 1.


My only comments on the set. Otherwise LGTM.

> +
> +	- 1: Enable extension.
> +	- 0: Disable extension.
> +
> +	Default: 0
> +
>  
>  ``/proc/sys/net/core/*``
>  ========================
> -- 
> 2.31.1
> 
