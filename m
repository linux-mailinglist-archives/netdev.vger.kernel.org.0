Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E77C62378D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiKIXfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiKIXf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:35:28 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AC1167D8
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:35:27 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v1so28105717wrt.11
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 15:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3/mFdUhKp2/t7oIDQs5MmpJaVVdh7VVnNKsfS9kJaNI=;
        b=Pj+0EX2K8C3FP1odKLqKC23t9P4jUS4yuua8zp9Mu0YAc6wgOZKSO+RX7N+dH9WT3V
         XHD9WSkwakNfIEKEL+G4QpvEwy1+nLzDUQTEyKb3d0VAGy85iQcc+/PKpl6BIeozr39C
         uL7QbMZqkuNetRi+tKOlkiqfZr6FyZd3ebHnBOUgiRdZWP0rRBayjM5PoOepjEwfPyqz
         vx/3k+DDgMhIK6kgwmqryyW872uMOHK4SGnbs5inGLI197MOyDoJyiL4Hp+ZiVtA72gs
         iGpL8iL8xkEIwWnfJxq+ZSEt92DmZZwBxODSCBS+NGfwjZH22XgLztN2E2SeCdtSwhtt
         VCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/mFdUhKp2/t7oIDQs5MmpJaVVdh7VVnNKsfS9kJaNI=;
        b=smU6n/3F1toY3P/OHHi1lCbs0MFwaW8Lz9ccj7aqX2mA7v1J24tKMJIrKR88YG0/UD
         I/4qTo6korZ4bVIKqgBlWMppJ05REpSyeMF7JCOvid/JjK1yWbKYsRVLcABOI51vhjop
         7Bw72A+ZSvsvKakeVPEkZrkEgHeii0T9PAWFV8OvAyNLXLKBM29zt0JGsEuXFJFWYPaE
         ICxS9V/lcixWg6jOGwXf3VV2e0uMmGW4zbF7FIUZD3so02BhGRVCkEb1kGJ3vGzZELDc
         scnxDuNkodlRXGl2OW4rpI/rk3W3T3paZk1hEL9+FoREPNuUs+ruykW5aPcmMvpe4Ew+
         GaBA==
X-Gm-Message-State: ACrzQf1gQVBl+U+IzZ01JWey9lLaWxb36BITe5iCBbrtGAfLqbZiQwEN
        k4csLJlFXOYVMTd98LFg2hE=
X-Google-Smtp-Source: AMsMyM64Ae8sRQxGWh7GvdivWHxUTXGdPjAZURNx/C3QeLn5JeAYCUa3Ib+bKmcV4G56RbGwV3U6EQ==
X-Received: by 2002:adf:a416:0:b0:236:c60c:cf05 with SMTP id d22-20020adfa416000000b00236c60ccf05mr37008450wra.35.1668036925443;
        Wed, 09 Nov 2022 15:35:25 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ay19-20020a05600c1e1300b003c6bbe910fdsm3616593wmb.9.2022.11.09.15.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 15:35:25 -0800 (PST)
Date:   Thu, 10 Nov 2022 01:35:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net] MAINTAINERS: Move Vivien to CREDITS
Message-ID: <20221109233523.oe4b6nulglgcowh3@skbuf>
References: <20221109231907.621678-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109231907.621678-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 03:19:07PM -0800, Florian Fainelli wrote:
> Last patch from Vivien was nearly 3 years ago and he has not reviewed or
> responded to DSA patches since then, move to CREDITS.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Oof. I hope he's okay though? 2 years since the last email sent on
kernel mailing lists is something...

(admittedly, my criteria of "no kernel activity => is he fine?"
might be dubious to some)
