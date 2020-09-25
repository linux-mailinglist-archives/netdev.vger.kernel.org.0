Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7E279078
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgIYScX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbgIYScV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:32:21 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D31C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:32:21 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id d20so3781731qka.5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=sVILonlCKBwVPwcCu7yOzPdEUOVF9sVSsOi4WcddEec=;
        b=YGzw/EhTsefr6oQW5wkJKKkq1+rer7OuAZyXwrgxZXa0ZFCm9y3jL55DxAF01hlZ9N
         ZFIcKYNR/eYjw1VHsXM4LARnJUBOT30eZkVcDh9Ix3f0qZ+++pGfTuvfjX62I7fPv5Bi
         whqPoL0GDrYJc3VKO2XdGD3TLu13Gr/AEcShgzsBmsKeUVFVux+pTaRlyrbS8mj0iT3j
         5QPL1r5UjHxV0+OzTjcLtLAcjaqO9AzexXZFgBg1Ramxq4CYG3khZl0XRGvHP1ZK+iSC
         rTyI8MpW0On7No84I4MxudScmDG/xTHu2SJ9ZOhu0w/aFoILNyaZ5yEM5NEtF0CzQj0k
         qemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=sVILonlCKBwVPwcCu7yOzPdEUOVF9sVSsOi4WcddEec=;
        b=LIaVfHTFVifLw56tfCkR8hpvUtvB56S08dyIj3E8p5yapkUHMNIb18GxImnk3CWiv3
         Eh/7J3mvoxVtj2CKSRNkVWVOpk/6vc/94PlJxCuBlYowpYkgh61Nx//4RO8Y0LPhEF6q
         drDpJ14vMeIdGu/SmuWUK9ljnr44isMHUD9pBxXfMxJWew38ly1OJNkyjSqhqHXEzj5u
         mXk9f3akjPT7QFFaoimAVhGAmapQR1c92gUG/E4Wn4o2mQVWuF4/iB5T8+QIX7s21Xqy
         kRvL9DnqIzsFvS8F7UZSOQC6176pcrYtYPdtc43v7OnXTM/5LEFanLxDjJTGSFZ7VMlr
         4L2Q==
X-Gm-Message-State: AOAM531UVZnLeWW0b3gak2lcmHmKk/Ie5eX5/EOYPw9nxfKULYPAAgDu
        6i2KBpJfaLuUSZylz2Joxzc=
X-Google-Smtp-Source: ABdhPJwNRl6wqR4j/ztRVs5bP+jSqnF1fFir/PRWI1uTZXnxV4jiUSma6sU8rHJ4C+UK3qaGifWp/w==
X-Received: by 2002:a37:ef19:: with SMTP id j25mr1239108qkk.363.1601058740226;
        Fri, 25 Sep 2020 11:32:20 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r78sm2185789qka.95.2020.09.25.11.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:32:19 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:32:18 -0400
Message-ID: <20200925143218.GD12824@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: Add Vladimir as a maintainer for DSA
In-Reply-To: <20200925152616.20963-1-f.fainelli@gmail.com>
References: <20200925152616.20963-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 08:26:16 -0700 Florian Fainelli <f.fainelli@gmail.com> wrote:
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Vivien Didelot <vivien.didelot@gmail.com>
