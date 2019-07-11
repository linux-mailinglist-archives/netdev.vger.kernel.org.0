Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D8F652D4
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfGKIIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 04:08:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55763 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbfGKII3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:08:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so4675281wmj.5
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 01:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FjI8zT9BaBhenvixFKkuibZ0s0HWhdFYdb6AGhH4zHQ=;
        b=TGPYsk/RMY0LJIGAG95XOlfHDTwUcZ4vj/muqYNitv6gRNGbDMU49279Psune3J7Lu
         5Db0pVbsXcBLQU5KZvBjhqoksZKkQZW/5HcCUjE6iARrO4ajth4YcjaeyK81Snw0qAg6
         LEKmwH0OaVqGx3qSUvWBFWvcb8lEFUU7krs7SDwqy6V29al0rQraZm0FofkUCKAYedLH
         x2TZLNZL3AOrGICYIsmn/SrpmNlUp+BPyKfxLinoJN/Q7Evtz46+u2gkjxmfMMWH/2bs
         trnjM9oXbXhEGUPqHEk+DIPaFhxwWeYnaGqQ10HEoNg4/Mv0w518gj6iy/JFs5H+OXug
         wW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FjI8zT9BaBhenvixFKkuibZ0s0HWhdFYdb6AGhH4zHQ=;
        b=YqjnyuSv5ZoRA/rNv9U31fNcyAh70WFTvV2DcdWk7Vr2iKGGzm3rbIse4OYZ1NSCVY
         i8vVSI9hfD4EDhBpoZmBib8CH9EAvzmkI2h/ZqkUSJ+OCePWByStwsvovjPYb+E9DVIg
         D+ppJR68WpA3zZdEPy9kSY0WWOHjD9b6m/jV1SweBr9QKfOVLcHzh1IUi/8GAjElIT8m
         JE45+az1wxZFQFbIxeGy/dhpfdM5UG7DqKvr4/sUv4rimhwr7malzjc3thFiUWZvAR8E
         T2w7x4OCVAE1Efu2GNR44tSOHrS2g3vA6uWnkia4jW9K5IXjcCz64GHNw74ezHqbBjug
         /sNQ==
X-Gm-Message-State: APjAAAV9G+2YmK3I97dhkLk83Hy58sVGlOHNWFSdncpfj40gGIm12XCi
        6dH12qcl1EaYnkjFIasSE/E=
X-Google-Smtp-Source: APXvYqx0j0ILJ/qZZ8/PzjikPH4K+IX3CWl3P0keVoaHEz/oMM+Is4QJBZY4agD2TINyBYxr/u9AUQ==
X-Received: by 2002:a1c:f418:: with SMTP id z24mr2648264wma.80.1562832507573;
        Thu, 11 Jul 2019 01:08:27 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id v15sm4767154wrt.25.2019.07.11.01.08.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 01:08:27 -0700 (PDT)
Date:   Thu, 11 Jul 2019 10:08:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 1/3] net: flow_offload: remove netns parameter
 from flow_block_cb_alloc()
Message-ID: <20190711080826.GH2291@nanopsycho>
References: <20190711001235.20686-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711001235.20686-1-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 11, 2019 at 02:12:33AM CEST, pablo@netfilter.org wrote:
>No need to annotate the netns on the flow block callback object,
>flow_block_cb_is_busy() already checks for used blocks.
>
>Fixes: d63db30c8537 ("net: flow_offload: add flow_block_cb_alloc() and flow_block_cb_free()")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
