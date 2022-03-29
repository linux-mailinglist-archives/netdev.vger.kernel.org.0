Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683794EA8F8
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 10:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiC2IId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 04:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbiC2IIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 04:08:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C552332993;
        Tue, 29 Mar 2022 01:06:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso958687wmn.1;
        Tue, 29 Mar 2022 01:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=25jdPIUFHHKil9p2jrTlL8YhE3fNBfgJbp+Rf3KdpNE=;
        b=ZI17cIoc/2JKqkowlmyH1j9jeuJrXPsEZ3O01/CI/Xk/mxC8DhW/muUZtt7EJPzNBp
         EoGu1naPr2ZG/3S4OqkXzpyL6QeEYy2EgrSL4P1paVjbI9wc5HAyy1cXdwx2exXeHS2T
         2x+4HDg7BWxSjCIX4+Y41K7q286HiDb0+tSSGfgX+vC9iyuyUqXjAQ2Cq1HedOF+QKDm
         tnLdkPT79EB/l/4+a0t7wmuud2vXNawqdX8e7B7I0L0tHhgVqkBY5Owwq8D7Fh+swF7w
         UYilQgY2753FXWDJs9eeibNCmX0AGzBUYUjNdJoDKTe+43zGlB5eV8AJURt4DWW1qQGg
         QmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=25jdPIUFHHKil9p2jrTlL8YhE3fNBfgJbp+Rf3KdpNE=;
        b=bDHQbeRqWzBL8Yp9EHrggo7tRZYX4X3oaAgSVKLlsOVabFQLgbTWXMveXjbdZjzZ+X
         6eoKwIlQTL8AMU3zw8e7T7IkaBUdNs7RKZ9A8N43v16S25HsG8PVBxJ1ebiThk1ut34P
         EqZ1MYE8iT/dHdVm03BJ9PxadJax47y72VFV5nYnIj2cYgWOX2Eya+YioQzZY14A6MR6
         1lQKpPnxpMo9bN2/88R0ma48RqNDCNvO9AOonNNAJvjKjEunzoP4jr/nlKkYKE6vdWoz
         XgBE+HyfC0C07oGGNdkRLAoZgaNy6Yi0dVoomu1PRe+fKTQuY+k2zgXLB6yra1DtB3nb
         nDdQ==
X-Gm-Message-State: AOAM53207zmMkKjet7SjSSfsX/UDiCXiB0I3RpW7Kcz/w++iHLtL78AJ
        Sid6jWudEZkIGs5qWKrX1IM=
X-Google-Smtp-Source: ABdhPJwdbRTaoW/68CCiCYb+e4cJKfiB8lOPYuMDNNVzhxO3ilyfbQSCDp5AJwmZGdXsG1EEuRRqGA==
X-Received: by 2002:a05:600c:3b98:b0:38c:b19d:59f2 with SMTP id n24-20020a05600c3b9800b0038cb19d59f2mr5128495wms.205.1648541208241;
        Tue, 29 Mar 2022 01:06:48 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id j5-20020a05600c1c0500b0038ca4fdf7a5sm2336558wms.9.2022.03.29.01.06.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Mar 2022 01:06:47 -0700 (PDT)
Date:   Tue, 29 Mar 2022 09:06:45 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net 04/13] docs: netdev: turn the net-next closed into a
 Warning
Message-ID: <20220329080645.v5xg4s3zo5zcog4q@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
References: <20220327025400.2481365-1-kuba@kernel.org>
 <20220327025400.2481365-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327025400.2481365-5-kuba@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 07:53:51PM -0700, Jakub Kicinski wrote:
> Use the sphinx Warning box to make the net-next being closed
> stand out more.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdev-FAQ.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
> index 0bff899f286f..c1683ed1faca 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -73,8 +73,9 @@ relating to vX.Y
>  An announcement indicating when ``net-next`` has been closed is usually
>  sent to netdev, but knowing the above, you can predict that in advance.
>  
> -IMPORTANT: Do not send new ``net-next`` content to netdev during the
> -period during which ``net-next`` tree is closed.
> +.. warning::
> +  Do not send new ``net-next`` content to netdev during the
> +  period during which ``net-next`` tree is closed.

Similar to the comment from Kuniyuki I was missing a reference to
 http://vger.kernel.org/~davem/net-next.html
here.

Martin

>  
>  Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
>  tree for ``net-next`` reopens to collect content for the next (vX.Y+1)
> -- 
> 2.34.1
