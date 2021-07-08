Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9DE3C15B3
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhGHPLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhGHPLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:11:31 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD04C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 08:08:49 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id w13so5094695qtc.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 08:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A2lQ1y/orDMQNUEXLTETNoGW6ipZLA49f+lo4DxkQTA=;
        b=IG0/w+IMGrUw6Vr3pXUAy4w51HrdpzH+dp5MCiPrbr0zOwkBHS+AsMmD8SQuMFUjYU
         Hs1tTHwUVegLVDNMlVXG3PpxTjcV+yVbUxf4ktyIbU0gGzLcu1JtnBZt2qYB7C5Vk5u/
         YFoIbAM2ypS++mIC+o6Bp2h6nLQn6JB4T66U9kx0UnPXf7GDxEYyFVs7veg4NhozdKKQ
         Fk8o39aXquvFqA38yBPaiG2tLtRDh5znGierjZj+1Mc4nK+ayQ0yH/kSN4pMJrrZTSG+
         GjCbIvX04r3lQUknRz+S0JdN3v36N0oKWEbssE9UCyWXFxQ4X30dzif77erBefXraMBn
         JaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=A2lQ1y/orDMQNUEXLTETNoGW6ipZLA49f+lo4DxkQTA=;
        b=gE5vI7nTGxVhtI5Mhh1ZbN/gQW2DvwjC/JmJf495Ys59iqb1VrLL0fISOwY06P1qBW
         qvNohQNV0ntagmUkn2G7qmR+Q7LBVU88vL3c1ilPAkwRmz6Cbcgj8YwFu/nrweh35zBp
         mP7d/zdXTtQyj3nJbPs2uwrJuYZX2DdozSms/LqaZVKrC2h6uSIzbsBVWLIFZXnixZmw
         rz+sRsyxAiPv02bGyq9ABycN2lL5h+uBanw4P4GLWdBjVP+UKY8XA2b9tESTkmLmzb/q
         bC69ehSDAr1KVuC3S2Pl2LxohX8xw3Ok43G17SaFkqlPgl+UsM2lP2Jl/eJwZVOtZSY9
         GpUQ==
X-Gm-Message-State: AOAM533Lap0d10tLzodjma70EwRgMl/0vtwXPQd4WbkSi/pe0cZCCSRT
        dE66dGzGupKqvURDyxt5If8Gyw==
X-Google-Smtp-Source: ABdhPJykAIb6xl/0NUHtNKq/lDZDnYHUiHAevTI568j20etsPdR21J/3F20fBzYO5JQ8Nidjfn05/g==
X-Received: by 2002:ac8:5c83:: with SMTP id r3mr28469432qta.78.1625756928553;
        Thu, 08 Jul 2021 08:08:48 -0700 (PDT)
Received: from iron-maiden.localnet ([50.225.136.98])
        by smtp.gmail.com with ESMTPSA id t30sm1106247qkm.11.2021.07.08.08.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 08:08:48 -0700 (PDT)
From:   Carlos Bilbao <bilbao@vt.edu>
To:     gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, alexander.deucher@amd.com, davem@davemloft.net,
        mchehab+huawei@kernel.org, kuba@kernel.org,
        James.Bottomley@hansenpartnership.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: Follow the indentation coding standard on printks
Date:   Thu, 08 Jul 2021 11:08:47 -0400
Message-ID: <7263255.EvYhyI6sBW@iron-maiden>
Organization: Virginia Tech
In-Reply-To: <YOcRfBtS/UJ81CFq@lunn.ch>
References: <2784471.e9J7NaK4W3@iron-maiden> <YOcRfBtS/UJ81CFq@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

> - Your patch did many different things all at once, making it difficult
>  to review.  All Linux kernel patches need to only do one thing at a
>  time.  If you need to do multiple things (such as clean up all coding

Greg, I am going to divide the patch in three parts, for atm/, net/ and parisc/.

> 
> Why not use DPRINTK(), defined at the start of suni.c?
> 
>     Andrew

Thanks for the idea Andrew, I will make a new version of the net/ patch.

thanks,
Carlos. 


