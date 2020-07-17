Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E242922337B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgGQGQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgGQGQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:16:19 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E154C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 23:16:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so9767924wrw.5
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 23:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ghtQmU8uYxYtd0dTiBgkfKnLn5PNCWJ7Apv6jqi2YLA=;
        b=SMLdNlQ2c+KmJTRrGqKg9hTtEr3MfeicitMX+BJXLxfYBaGlhRGWC1osiSBeH4C52Y
         MVIPqeL2SEjQZP4SsLhHOGNP66eUToLCnGfCBWf/4bMexO0UZuYA8sNGL1RBaoqULiMm
         rzCUFwtIZ6s21RNCUiN8FjdrPKdiI+jCmERuSDTCkdq/gZ0pj6WvaVZdsekPGEnwAOjC
         4pu34u3sTBT8gy4CjredNBmtitmf3bzGvAJP5/Q44wROh18ZYUPG12BDAIR+lhI8Ei0n
         1oaDaUyMyMyw0fZR8QDHLW/N1Q9qXPhl57n6znmIILviZjojCVb8bmtz4L+WLVaV8AAy
         osZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ghtQmU8uYxYtd0dTiBgkfKnLn5PNCWJ7Apv6jqi2YLA=;
        b=LcsyVV8cKRmnV21s/rOK7VqhBriMIr/qpVt6WYg2F8y3Lvm4KSptPHwX1Ss1IPdTSf
         juroycKHsmgwupm67R4luDG/D8tyBY7W8AFjzHNKfAhlLvquTAEt0j/BsK+DzFV3s8g1
         80BIxJuV/z82/QRu8dAkslisQLz/BtZSZi65QPW0jVKXEP//qfK1ceY3NXmh0r1PODmN
         dAU+Ma4Hnf8pSa82u6M+6t+T6uUBehHTqGAjW4fqqjmxfamBtP3rk6dG05JfNclDoOUy
         OmXNHrRHW3Uyt7CJfeWr8on2kVhPBQ6WZsiElVqu/jFxjgWwZ9tuiK36aOJbW17gnbhp
         TxFA==
X-Gm-Message-State: AOAM530b3XPBDGC11k7lzqjujp3GC0v90Lt3Hth2xeJWwvLXYbC3EaHs
        P5FykL+uyLe04/RPYDjKgGFoyg==
X-Google-Smtp-Source: ABdhPJybLlso45fupVW53UDB+diDApaWruG6GbclMoF+K/uYygxO26T8MgSrUqATKD1ww8q9YF8Bfw==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr8092898wrv.380.1594966577914;
        Thu, 16 Jul 2020 23:16:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w7sm11715463wmc.32.2020.07.16.23.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:16:17 -0700 (PDT)
Date:   Fri, 17 Jul 2020 08:16:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 1/2] tc: Look for blocks in qevents
Message-ID: <20200717061616.GE23663@nanopsycho.orion>
References: <cover.1594917961.git.petrm@mellanox.com>
 <212fc3e148879b60c08f6afceae77d78489914aa.1594917961.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <212fc3e148879b60c08f6afceae77d78489914aa.1594917961.git.petrm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 16, 2020 at 06:47:07PM CEST, petrm@mellanox.com wrote:
>When a list of filters at a given block is requested, tc first validates
>that the block exists before doing the filter query. Currently the
>validation routine checks ingress and egress blocks. But now that blocks
>can be bound to qevents as well, qevent blocks should be looked for as
>well.
>
>In order to support that, extend struct qdisc_util with a new callback,
>has_block. That should report whether, give the attributes in TCA_OPTIONS,
>a blocks with a given number is bound to a qevent. In
>tc_qdisc_block_exists_cb(), invoke that callback when set.
>
>Add a helper to the tc_qevent module that walks the list of qevents and
>looks for a given block. This is meant to be used by the individual qdiscs.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
