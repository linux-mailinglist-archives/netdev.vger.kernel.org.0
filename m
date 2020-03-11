Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7081821A5
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgCKTN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:13:57 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43298 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730705AbgCKTN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:13:57 -0400
Received: by mail-qv1-f68.google.com with SMTP id c28so1407413qvb.10
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 12:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0BQ/obTVvYsf4e7ZrMtIjLfwdEhA7tlNVvd8b+igaj0=;
        b=A2AMebl8U3Bh6z22mtRrPVJCZdel0mZZbu3dJ7QRd5IxlzbsjXx1ApIdjI3XWuNyuu
         KCxkrtwQ/xImk6OQ6B92uBti2YH0gcAa5CZyFeuqBJmysa9QLsbzLDrojG1dyCJWyJSN
         +D8xUIrweKe4T6EIKhNgo8pRZJ11ioyhB4Ol80UB9uSkPaCyB/BCMOQHNlCrTC6Yx9sz
         AnE9yJr0XKkB7jp/IBMfY+RVm/mvSoSOTuAlUeWx88/xX2NgxUP7mhP5klsrYKVA9iZb
         plJwQW2NsXB553WIL6NdTY7hqzu4s9tbE0LvnN01iwR9+fryGkb7pqgisaHUfvrWYRbV
         SZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0BQ/obTVvYsf4e7ZrMtIjLfwdEhA7tlNVvd8b+igaj0=;
        b=VLJKAXTNwdTN0+jlSYNJBgd3Ms2wqsjnd69yOCIDBYN6rNggYmmpyWp2yj+B085tdF
         Mjp8RRKFMl6E/v/lpW06XzxY254tPBVwi+Quu2rcS72F0CjeqVC1zzX/a/IysYBMExsR
         oW8zy2BFU5nNK7xhTboijShGkn2GXiOIpYqBdrkR0kajNr0MRTzk/iX+gfyev9ASsgP5
         hHODbmXF33luebIedVpCNHwuNlTK0V0G8vItYqWlp50Qh0At5rs4jnxRssqrAa18hdJY
         fZVi876SCf4jVKmWjH+1rNqxaUbNeLo3kQNymxkSBKDK+ySxRDGt2Z5lDdro1q8v/QM1
         obAQ==
X-Gm-Message-State: ANhLgQ1GxmTJR4DqorA99ObrDEM/4Wkp9LOW0Vo6+ZlSzzxr7aDLn9SJ
        mXHVKrTWzI4Ax5uh3JCPDGC49uW2QrdJww==
X-Google-Smtp-Source: ADFU+vvaYRfaoTg6ygK4D4MGBgxlXD7urSScfQZb3YMZCr2VggzCGq0JUwUU7GTDTBFw3X516UzpZQ==
X-Received: by 2002:ad4:4026:: with SMTP id q6mr2288224qvp.118.1583954036302;
        Wed, 11 Mar 2020 12:13:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:29fb:61fe:d751:d9c1:d6c1])
        by smtp.gmail.com with ESMTPSA id a1sm25682091qkd.126.2020.03.11.12.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 12:13:55 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 19A69C3C60; Wed, 11 Mar 2020 16:13:53 -0300 (-03)
Date:   Wed, 11 Mar 2020 16:13:53 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next ct-offload v3 00/15] Introduce connection
 tracking offload
Message-ID: <20200311191353.GL2546@localhost.localdomain>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 04:33:43PM +0200, Paul Blakey wrote:
> Applying this patchset
> --------------------------
> 
> On top of current net-next ("r8169: simplify getting stats by using netdev_stats_to_stats64"),
> pull Saeed's ct-offload branch, from git git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
> and fix the following non trivial conflict in fs_core.c as follows:
> #define OFFLOADS_MAX_FT 2
> #define OFFLOADS_NUM_PRIOS 2
> #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)
> 
> Then apply this patchset.

I did this and I couldn't get tc offloading (not ct) to work anymore.
Then I moved to current net-next (the commit you mentioned above), and
got the same thing.

What I can tell so far is that 
perf script | head
       handler11  4415 [009]  1263.438424: probe:mlx5e_configure_flower__return: (ffffffffc094fa80 <- ffffffff93dc510a) arg1=0xffffffffffffffa1

and that's EOPNOTSUPP. Not sure yet where that is coming from.


Btw, it's prooving to be a nice exercise to find out why it is failing
to offload. Perhaps some netdev_err_once() is welcomed.

  Marcelo
