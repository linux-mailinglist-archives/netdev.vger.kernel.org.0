Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4EB1E9D2C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 07:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgFAFTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 01:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgFAFTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 01:19:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9ADC061A0E;
        Sun, 31 May 2020 22:19:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s88so3859778pjb.5;
        Sun, 31 May 2020 22:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sO8jcvPiOukatlC6URpKN2G0/iDSlj0IFO4ApIBDM5Q=;
        b=BX8Vuxfjwu6ye+y9HvZFXuGYzvBaaleulIo30K+5I0RyTywGmZuI+Ccn82aMK+DD6j
         LTAyYFs8Tf7WEHAnNkbpOMLmFA9K4+95SXaA6/03MQBwLw7eMrzzm+0MPK4wvWhAHQti
         znXATEvs/CfYBMnvGzmmROla2P1m9VK2R69dkTwpeo58bCHCBbM4bUi7UIfzXUnL2LbV
         tPAGNMUKxb9Elli2yoyDHuMJxqyikf6p5EiFA545v5jcpCTbOqr/Osgrvix5aphY9yvy
         De6me9qB46xlLouxc1gTOZjKaPikpiFA0bOO6U4zUUCRseFzU50SWfJOt616NRjG7an9
         S5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sO8jcvPiOukatlC6URpKN2G0/iDSlj0IFO4ApIBDM5Q=;
        b=N3gPNavAqQb3DTYCbauv8FEFht2aleesu8Nbk3WON6ggGx2aQwRaSqdoh/Y0FTR8m2
         K+DRv3oFExPjo9+ZpWA+BdNIuKDYP0lEV4Ni9vSQZMQJPuo0I7bcGMpeWxO/m4gBLYBg
         6vqSJogbcZ5gykoB89CrQBOoKqTLP6zBFcqxkaVZkoc/qchBmOQch8afDT8ak9Dzjoby
         l3GTzGK0c4pQj7kDZ6VNWgOeQUMwe5iISSgUKwdAlrcjAUgCyJt9uAoL9p3NifHH/Kup
         meZUhOJTWUbBIGV56XoM8R6u1/ckjJdO725g13vWJGp8AoZ8rITqDZMOS72FFSpmlfC+
         DRYw==
X-Gm-Message-State: AOAM531Sjrcr7IoJANPSVkWRye/l7Cf6K5MkjNijwCF6XBIiLk6D6/Lv
        Ewxlv1uQm3ttUEqKy2x+z70=
X-Google-Smtp-Source: ABdhPJyY9uOLpdfNARQ7gU6mScXwZv/e5G3IgkWWLW3MEl7XePDvpgX/zsqnAn006JfMQ3kLxIVe1Q==
X-Received: by 2002:a17:902:9f90:: with SMTP id g16mr11468281plq.146.1590988793099;
        Sun, 31 May 2020 22:19:53 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id v9sm6598865pfu.212.2020.05.31.22.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 22:19:51 -0700 (PDT)
Date:   Mon, 1 Jun 2020 14:19:47 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jil Rouceau <jilrouceau@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: qlge_main.c: fixed spaces coding style
 issues
Message-ID: <20200601051947.GA12667@f3>
References: <20200529151749.34018-1-jilrouceau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529151749.34018-1-jilrouceau@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-29 17:17 +0200, Jil Rouceau wrote:
> Fixed the missing spaces before and after binary operators.
> 
> Signed-off-by: Jil Rouceau <jilrouceau@gmail.com>

This patch does not apply cleanly. I think your base tree is missing
commit ec269f1250c6 ("staging: qlge: Remove unnecessary spaces in
qlge_main.c").
