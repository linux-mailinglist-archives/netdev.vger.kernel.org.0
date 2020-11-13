Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371AA2B241E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgKMS43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMS42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:56:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0C7C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 10:56:28 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f38so7833159pgm.2
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 10:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FTe4IFxyZRfe6e1KTm/4BOEWWvsZWzGpkqFKgybFiWE=;
        b=OhMOwOmIpkXinfZKtq0pWORdDEbp5pMj3T5NNMq/Jy/qGauRFJyXmOGt/GdZq/I3h8
         OPWk1MochZfO1wR2yh0x+/Ruwtt30WkDl1hHGtNuxnu7G/hK5xltFP403S8AerHA9L82
         dra4vpbBV/1EtPfG65/oiUIotzGKzV4l4sfPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FTe4IFxyZRfe6e1KTm/4BOEWWvsZWzGpkqFKgybFiWE=;
        b=TKBXvMOxQecLlypvtMGFIzyYDWPu3c/QWpH4L2IyIptZpjufL32HTuDiXoDOW0pprS
         p02/UvorNq7WR9GjeiVFaZR2CZMy8AXxaaK3PgL/iAmFgDhFAxfPx1ZvpNp4Xvw+pUSw
         R9rlfTog1jqvej05hghi+sWOqXJG7KpG6rpOMj5VJzcVQ1SZHyvmCY2erdRJBiYSU+6m
         f6idpSABIvl3FcwzETdGK4SKCYHAVb7UBYJiPI0stpil/asQ9YKwErQXDRG6UuLPDZca
         EC09qJz6+ckYVeQtHoDP26lkYR3yFkwrtvkfwYHhiInCly6qO6r+DZ2+wEx/v++5L8KJ
         MQIg==
X-Gm-Message-State: AOAM533oFAOzIbAjsQDbS01pWbBZ7y9pfSaS/5AAEpA7/hfOEIgWQ3PH
        gGFki1isN8GeMs+FOgu2h7DFhA==
X-Google-Smtp-Source: ABdhPJyWOcYg1DIz/MbaT5BJSJKHR2gB672kAJ8jzYYVMbLzJJhnghEXydc3VWIZCgVrOywSEJ66/Q==
X-Received: by 2002:a62:52d7:0:b029:18b:7093:fb88 with SMTP id g206-20020a6252d70000b029018b7093fb88mr3233812pfb.76.1605293788220;
        Fri, 13 Nov 2020 10:56:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l190sm10101876pfl.205.2020.11.13.10.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 10:56:27 -0800 (PST)
Date:   Fri, 13 Nov 2020 10:56:26 -0800
From:   Kees Cook <keescook@chromium.org>
To:     laniel_francis@privacyrequired.com,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Message-ID: <202011131054.28BD6A9@keescook>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:11:30PM +0100, laniel_francis@privacyrequired.com wrote:
> From: Francis Laniel <laniel_francis@privacyrequired.com>
> 
> Hi.
> 
> 
> I hope you are all fine and the same for your relatives.
> 
> This patch set answers to first three issues listed in:
> https://github.com/KSPP/linux/issues/110
> 
> To sum up, the patch contributions are the following:
> 1. the first patch fixes an inefficiency where some bytes in dst were written
> twice, one with 0 the other with src content.
> 2. The second one modifies nla_strlcpy to return the same value as strscpy,
> i.e. number of bytes written or -E2BIG if src was truncated.
> It also modifies code that calls nla_strlcpy and checks for its return value.
> 3. The third renames nla_strlcpy to nla_strscpy.
> 
> Unfortunately, I did not find how to create struct nlattr objects so I tested
> my modifications on simple char* and with GDB using tc to get to
> tcf_proto_check_kind.
> 
> If you see any way to improve the code or have any remark, feel free to comment.
> 
> 
> Best regards and take care of yourselves.
> 
> Francis Laniel (3):
>   Fix unefficient call to memset before memcpu in nla_strlcpy.
>   Modify return value of nla_strlcpy to match that of strscpy.
>   treewide: rename nla_strlcpy to nla_strscpy.

Thanks! This looks good to me.

Jakub, does this look ready to you?

> 
>  drivers/infiniband/core/nldev.c            | 10 +++---
>  drivers/net/can/vxcan.c                    |  4 +--
>  drivers/net/veth.c                         |  4 +--
>  include/linux/genl_magic_struct.h          |  2 +-
>  include/net/netlink.h                      |  4 +--
>  include/net/pkt_cls.h                      |  2 +-
>  kernel/taskstats.c                         |  2 +-
>  lib/nlattr.c                               | 42 ++++++++++++++--------
>  net/core/fib_rules.c                       |  4 +--
>  net/core/rtnetlink.c                       | 12 +++----
>  net/decnet/dn_dev.c                        |  2 +-
>  net/ieee802154/nl-mac.c                    |  2 +-
>  net/ipv4/devinet.c                         |  2 +-
>  net/ipv4/fib_semantics.c                   |  2 +-
>  net/ipv4/metrics.c                         |  2 +-
>  net/netfilter/ipset/ip_set_hash_netiface.c |  4 +--
>  net/netfilter/nf_tables_api.c              |  6 ++--
>  net/netfilter/nfnetlink_acct.c             |  2 +-
>  net/netfilter/nfnetlink_cthelper.c         |  4 +--
>  net/netfilter/nft_ct.c                     |  2 +-
>  net/netfilter/nft_log.c                    |  2 +-
>  net/netlabel/netlabel_mgmt.c               |  2 +-
>  net/nfc/netlink.c                          |  2 +-
>  net/sched/act_api.c                        |  2 +-
>  net/sched/act_ipt.c                        |  2 +-
>  net/sched/act_simple.c                     |  4 +--
>  net/sched/cls_api.c                        |  2 +-
>  net/sched/sch_api.c                        |  2 +-
>  net/tipc/netlink_compat.c                  |  2 +-
>  29 files changed, 73 insertions(+), 61 deletions(-)
> 
> -- 
> 2.20.1
> 

-- 
Kees Cook
