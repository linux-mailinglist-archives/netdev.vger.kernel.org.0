Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2662A34BB
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgKBT4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:56:22 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:42838 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgKBTzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:55:08 -0500
Received: by mail-qv1-f65.google.com with SMTP id b11so6694595qvr.9
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 11:55:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uyZUJT4qEW0VxstzzqGtp4pa7iFF84IFJ3iL+PvkDu4=;
        b=FrYC9i6hH3dq1wPIwALqhDy6+sdAycEoiy+cLXr47B4lfYWTAjc0QTvB93FtERh7se
         OllnlCdBrhUYmhSrNsvWhBwEYxxg5Dzp4amC3AXIpoHQUoY55p0txA9Vl2LJqgUqs/mA
         mSe2sA74p63MLlnN4DWMsMdU4oCUhRqPayDvqW7CrxZfOqEP8S2zp5Ecb9gK5xJUSdXV
         v/ntDunuHb0aw8nsZfW13dvyquupbMPR/zWqV4Dxc+glXMKydjqNrAH5Khs1wlOU+kac
         /FmloFD6PmU1uXAZ+/EELnAjoM8YhUb2gm91ofK8+DHEsJMUtf17ltkiTwIlH4bwwl7z
         p4aQ==
X-Gm-Message-State: AOAM533Ez0E1XyAv1ByzDLx4lo1dPa/w5FGtjqo+2YDAKWuq6YGbrKO8
        OTJPTXWa+/89oxkwbfUTXA96Kg==
X-Google-Smtp-Source: ABdhPJxENt1F+iI+JYAjamhVE8WZk6pfWC8u00eYDKUL3hoVja9EnAJIeI7mGfxMtdFqenMotYflyg==
X-Received: by 2002:a0c:edce:: with SMTP id i14mr24078873qvr.38.1604346906367;
        Mon, 02 Nov 2020 11:55:06 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id k24sm5390114qtp.35.2020.11.02.11.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 11:55:05 -0800 (PST)
Date:   Mon, 2 Nov 2020 14:55:03 -0500
From:   Jeffrey Layton <jlayton@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH net-next] net: ceph: Fix most of the kerneldoc warings
Message-ID: <20201102192920.GA923955@tleilax.poochiereds.net>
References: <20201028005907.930575-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028005907.930575-1-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 01:59:07AM +0100, Andrew Lunn wrote:
> net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oid' not described in 'ceph_cls_break_lock'
> net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oloc' not described in 'ceph_cls_break_lock'
> net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'osdc' not described in 'ceph_cls_break_lock'
> net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'oid' not described in 'ceph_cls_lock'
> net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'oloc' not described in 'ceph_cls_lock'
> net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'osdc' not described in 'ceph_cls_lock'
> net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'oid' not described in 'ceph_cls_unlock'
> net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'oloc' not described in 'ceph_cls_unlock'
> net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'osdc' not described in 'ceph_cls_unlock'
> net/ceph/crush/mapper.c:466: warning: Function parameter or member 'choose_args' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:466: warning: Function parameter or member 'weight_max' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:466: warning: Function parameter or member 'weight' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:466: warning: Function parameter or member 'work' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'bucket' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'choose_args' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'map' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'numrep' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'out2' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'out' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'outpos' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'parent_r' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'recurse_to_leaf' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'recurse_tries' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'tries' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'type' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'weight_max' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'weight' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'work' not described in 'crush_choose_indep'
> net/ceph/crush/mapper.c:655: warning: Function parameter or member 'x' not described in 'crush_choose_indep'
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/ceph/cls_lock_client.c | 12 +++++++++---
>  net/ceph/crush/mapper.c    | 21 ++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 

If you resend, please do cc ceph-devel.

> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
> index 17447c19d937..b130f7b25ea0 100644
> --- a/net/ceph/cls_lock_client.c
> +++ b/net/ceph/cls_lock_client.c
> @@ -10,7 +10,9 @@
>  
>  /**
>   * ceph_cls_lock - grab rados lock for object
> - * @oid, @oloc: object to lock
> + * @osdc: osd client grabbing the lock
> + * @oid: object to lock

id of object to lock

> + * @oloc: object to lock

location of object to lock

>   * @lock_name: the name of the lock
>   * @type: lock type (CEPH_CLS_LOCK_EXCLUSIVE or CEPH_CLS_LOCK_SHARED)
>   * @cookie: user-defined identifier for this instance of the lock
> @@ -82,7 +84,9 @@ EXPORT_SYMBOL(ceph_cls_lock);
>  
>  /**
>   * ceph_cls_unlock - release rados lock for object
> - * @oid, @oloc: object to lock
> + * @osdc: osd client releasing the lock
> + * @oid: object to lock
> + * @oloc: object to lock

ditto

>   * @lock_name: the name of the lock
>   * @cookie: user-defined identifier for this instance of the lock
>   */
> @@ -130,7 +134,9 @@ EXPORT_SYMBOL(ceph_cls_unlock);
>  
>  /**
>   * ceph_cls_break_lock - release rados lock for object for specified client
> - * @oid, @oloc: object to lock
> + * @osdc: osd client braaking the lock
> + * @oid: object to lock
> + * @oloc: object to lock

ditto

>   * @lock_name: the name of the lock
>   * @cookie: user-defined identifier for this instance of the lock
>   * @locker: current lock owner
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 7057f8db4f99..1b1c09006792 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -429,7 +429,10 @@ static int is_out(const struct crush_map *map,
>  /**
>   * crush_choose_firstn - choose numrep distinct items of given type
>   * @map: the crush_map
> + * @work: working area for a CRUSH placement computation
>   * @bucket: the bucket we are choose an item from
> + * @weight: weight vector (for map leaves)
> + * @weight_max: size of weight vector
>   * @x: crush input value
>   * @numrep: the number of items to choose
>   * @type: the type of item to choose
> @@ -445,6 +448,7 @@ static int is_out(const struct crush_map *map,
>   * @vary_r: pass r to recursive calls
>   * @out2: second output vector for leaf items (if @recurse_to_leaf)
>   * @parent_r: r value passed from the parent
> + * @choose_args: weights and ids for each known bucket
>   */
>  static int crush_choose_firstn(const struct crush_map *map,
>  			       struct crush_work *work,
> @@ -638,7 +642,22 @@ static int crush_choose_firstn(const struct crush_map *map,
>  
>  /**
>   * crush_choose_indep: alternative breadth-first positionally stable mapping
> - *
> + * @map: the crush_map
> + * @work: working area for a CRUSH placement computation
> + * @bucket: the bucket we are choose an item from
> + * @weight: weight vector (for map leaves)
> + * @weight_max: size of weight vector
> + * @x: crush input value
> + * @numrep: the number of items to choose
> + * @type: the type of item to choose
> + * @out: pointer to output vector
> + * @outpos: our position in that vector
> + * @tries: number of attempts to make
> + * @recurse_tries: number of attempts to have recursive chooseleaf make
> + * @recurse_to_leaf: true if we want one device under each item of given type (chooseleaf instead of choose)
> + * @out2: second output vector for leaf items (if @recurse_to_leaf)
> + * @parent_r: r value passed from the parent
> + * @choose_args: weights and ids for each known bucket
>   */
>  static void crush_choose_indep(const struct crush_map *map,
>  			       struct crush_work *work,
> -- 
> 2.28.0
> 
