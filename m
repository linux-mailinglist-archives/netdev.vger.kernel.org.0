Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED99813AF81
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgANQfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:35:36 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36199 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgANQff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:35:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so14507132wma.1
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LkS0OIviUNHCQEjd+5V8pyD76+IapGl4QNjOPYL2TYc=;
        b=B+AAT5zH3IPzx49G0bTCgxatxP3IDVjcJyw0y9z95MHj42bk0wDCwijFKedKR2trcR
         PmY05wS4K7KFpw93p3MHH4OoQyg3W9mN8yRRpcWKyMWTV018RvxuCAGpwl3VRXyogYaH
         4PPANfM/jvSQS4PtlTTht/Sw474Ztjfd9GzATJX1FaGsT4xc2kP9yyoyMiS2OTaNgRp6
         disVMQUQ8e7+BPsi6K4NUcY2pO1++W2KPrgDToez+E6a3fzX0TCHk7A+ybLpmJnNIqjM
         oC53PlosHDKtOje5Mft5wyC/qAM1BR1MeFgNO7z4vBS0Gx/FBkBGb1kD+LrealKGuZH3
         yzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LkS0OIviUNHCQEjd+5V8pyD76+IapGl4QNjOPYL2TYc=;
        b=tUEik7hoyHjdW32cNDR/eDPlmM3gUbNInFDUuedcJEtE5aHP8i/jmGavLekXFMVVMl
         ygN9jQoHXLvjoF0D1Q+p823nq0x9sULQD4Xqd5tmWsEs8B+OeCC9y8K2crCyRnJTJy+y
         vqM2lTW2kEp19OuBL7Bts5Wb7R03vsJuTg955AHUkevBfoH2OcLnveJ+28xKvu91f16P
         oYp4jwdifnzg8hCHSCYTH9zJbm3hG/uR2xcNXJF+iQ9Vy/q5gdhi+7A2V7THFfZyMnhb
         Ze5Vo/BtBRDbEo6xa5VH2vQwG+B+zgd8eiaqhuEaahS0xDSkuD7I4s11SqMyHPEDQWDE
         BzOg==
X-Gm-Message-State: APjAAAVlZC3Ypw0zNdNnc3ry/vuVkUhQZX964DsMxnTtqhllqvkp8Nli
        QbijDHqaR5YmHxRn5oxSdifSVA==
X-Google-Smtp-Source: APXvYqxrBAtJi1n5wQVVQGXXV0Ns271PwmB6WxN132dWTLLXZEt88nsrCSWEv/tP/RNSAh1OECLNPw==
X-Received: by 2002:a1c:b603:: with SMTP id g3mr27309966wmf.133.1579019733906;
        Tue, 14 Jan 2020 08:35:33 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id z124sm20993248wmc.20.2020.01.14.08.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 08:35:33 -0800 (PST)
Date:   Tue, 14 Jan 2020 17:35:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 02/10] ipv4: Encapsulate function arguments
 in a struct
Message-ID: <20200114163532.GM2131@nanopsycho>
References: <20200114112318.876378-1-idosch@idosch.org>
 <20200114112318.876378-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114112318.876378-3-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 14, 2020 at 12:23:10PM CET, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>fib_dump_info() is used to prepare RTM_{NEW,DEL}ROUTE netlink messages
>using the passed arguments. Currently, the function takes 11 arguments,
>6 of which are attributes of the route being dumped (e.g., prefix, TOS).
>
>The next patch will need the function to also dump to user space an
>indication if the route is present in hardware or not. Instead of
>passing yet another argument, change the function to take a struct
>containing the different route attributes.
>
>v2:
>* Name last argument of fib_dump_info()
>* Move 'struct fib_rt_info' to include/net/ip_fib.h so that it could
>  later be passed to fib_alias_hw_flags_set()
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
