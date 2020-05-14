Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9C1D3185
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgENNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgENNmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:42:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B20C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 06:42:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k12so30384273wmj.3
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 06:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pJU/KdS/ZgrSS7KrSeoio+T2ADc6AuO0lG0MCBEkxaw=;
        b=v0IkVnVBhrzll0sB1RfzR2oHxNLgiiWaXynFBd+AS2zoT4fhKEmDO0T+pJZaEHw7B2
         468dX/hChGYJcdKUSyI7G44Gt37E6mLb3BCIiyIp0YtUAdiXtgsbCD/R5GVkJcm8poWe
         ykwMAziEVhrmsSsFbxUB6+UkcYE182nPpmcrVP8iUm1hTscUUcLZRwD3qVCr35so7+oR
         R+ZyNSVpcXQ53a6emloKCDSsCekmyq5BaqWA5I9zci6B4ed0TmGCiPhoskcORocaNMWG
         XntDEU7oLMCU+ZT0lgMm9ZBLyRy2jJPPFUYZU2UdzoZXUJ2jWY5u4Tu2/VPU+KqJ3bk5
         nG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pJU/KdS/ZgrSS7KrSeoio+T2ADc6AuO0lG0MCBEkxaw=;
        b=GcxUG/ydb31EdxLOYA/9jTyIWhRXhOxHz2ftBQsg+kgFOL+BL/uSWx73KZHfAzge/h
         bxUxkF2I1e+FPGFFLk6f1UrdS8HoJ320yu37Etxp4pA9LT/5t/D2oBY2fgrKAcn+Uxdq
         MRlUVQbNs0Lg3ZFrujpYIsgSPb+K25IMvsnhu/yCylvjYe2DTksTRkcm3aGxCPey9mJI
         vNqMbQUcltlp5AM2H0CP7rVyAIWn4uiBKXBNbZ1YJ0u3lv05sc70U25tzhh3mkiZlasE
         kzllCreoI+UqoySNvu1PpHoM7Tu1G64KPVMFQM7jIf2ioveVXRtIOi7fiKpUbUQnD5Ws
         XXXA==
X-Gm-Message-State: AGi0PubnlUZFexaEoBLfiyXrUT/OH06IuEztHjdjfptoV2Ns0kPu0Whz
        3AYWBGqfxvxA4Oo6CGr+djgiRA==
X-Google-Smtp-Source: APiQypLx11ztlzuVlGWW78QO9o8dYGFUTROemat4Q6RNqWZVb/bw4ZvlxG4C6snk76PigX9w86H33Q==
X-Received: by 2002:a05:600c:21c1:: with SMTP id x1mr18982064wmj.173.1589463742866;
        Thu, 14 May 2020 06:42:22 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id n25sm41090917wmk.9.2020.05.14.06.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 06:42:22 -0700 (PDT)
Date:   Thu, 14 May 2020 15:42:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, marcelo.leitner@gmail.com,
        dcaratti@redhat.com
Subject: Re: [PATCH iproute2-next 2/2] tc: implement support for terse dump
Message-ID: <20200514134221.GC2676@nanopsycho>
References: <20200514114026.27047-1-vladbu@mellanox.com>
 <20200514132306.29961-1-vladbu@mellanox.com>
 <20200514132306.29961-3-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514132306.29961-3-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 14, 2020 at 03:23:06PM CEST, vladbu@mellanox.com wrote:
>Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
>tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
>user requested it with following example CLI:
>
>> tc -s filter show terse dev ens1f0 ingress
>
>In terse mode dump only outputs essential data needed to identify the
>filter and action (handle, cookie, etc.) and stats, if requested by the
>user. The intention is to significantly improve rule dump rate by omitting
>all static data that do not change after rule is created.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Adding forgotten tag:
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
