Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630551E10ED
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391020AbgEYOqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390935AbgEYOqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:46:37 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C89C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 07:46:36 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id h9so3699787qtj.7
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 07:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KgbOuvAOz9kyJXcW6HH6JT79cNyDLpEvQjZoxM71hGk=;
        b=H0gYlk+X04azJifnD2RCD+iFNekSe3t7G+RftOaRqGGwv9ekX79V2gvwKZ370pQvmr
         8/aGAmOZzgLypbiYLrBRxgASfvaRj6z4ONXLzEHXOkwkxLwwlqIkAv/STW0LzQMKGhkh
         YoJRMbxNBNTweJ6oAVVnhsM/oJad/jrIKNK/6WLa5mIoTN6G/orQAzICVoM6dfGDS5U4
         knqa8+rLwrka/jTwurm6AtXDyKOS/PdgMi/iouWp8ECNuJ0ZPtWfPbmu5azW9QgO8dav
         L4To4OIzjNNblEe4vn88cOlSIc1GZHDv1FENV3lyS3AkIoAtGWFn4pWvLyyk4CP8Wzmk
         hiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KgbOuvAOz9kyJXcW6HH6JT79cNyDLpEvQjZoxM71hGk=;
        b=tIPmvnJQ46GDw2tk+iZBZL/+B+e0jDPa3+wXXAIepGmOTDraDDnGME42qycCW+TNc6
         q99rEWChY2/AkvLpV68iO6a2tUvt/Qq+JG+VebRRvHB7aD1enhGtgEQuMPeceNCIF8Lm
         85/UpxlgfVPhRKg7cli86Rf1EKVPRCx5SZUOxnhcanH2sRR3EfHhYJF2y1c7KqLkeDnX
         0QhQ2LG9lnlt03xQykjzl2albYQSsUjaK/hYz9mdg+fXlqaQdIPVRZb6YJxPQqeadURP
         kz4OPePXqNOz10B5p7DpmIRDzoO9SSbncmw1THrAklkJzelVvtdGR5GVC+938GF0TRQr
         mTWw==
X-Gm-Message-State: AOAM53344iUYPBVLJXQn11DhI0itcx3vWksC3zFnhQav76MUEZ10dI2Z
        mEfbu73M3oQnueAJG7FvjhI=
X-Google-Smtp-Source: ABdhPJwGC6Y7Tw/pddT/Wbtw6gKN+v9KWrY2x0o/v3NQYIZH3Swbl53sJE7CKUyntKFupiVrATsANQ==
X-Received: by 2002:ac8:4d8e:: with SMTP id a14mr8801740qtw.343.1590417995547;
        Mon, 25 May 2020 07:46:35 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:8992:a39b:b6ab:3df8:5b60])
        by smtp.gmail.com with ESMTPSA id l186sm13910947qkf.89.2020.05.25.07.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 07:46:34 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 971BBC1632; Mon, 25 May 2020 11:46:32 -0300 (-03)
Date:   Mon, 25 May 2020 11:46:32 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [net-next 05/10] net/mlx5e: Introduce kconfig var for TC support
Message-ID: <20200525144632.GD74252@localhost.localdomain>
References: <20200522235148.28987-1-saeedm@mellanox.com>
 <20200522235148.28987-6-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522235148.28987-6-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:51:43PM -0700, Saeed Mahameed wrote:
...
> +config MLX5_CLS_ACT
> +	bool "MLX5 TC classifier action support"
> +	depends on MLX5_ESWITCH && NET_CLS_ACT
> +	default y
> +	help
> +	  mlx5 ConnectX offloads support for TC classifier action (NET_CLS_ACT),
> +	  works in both native NIC mdoe and Switchdev SRIOV mode.

Typo here btw, "mdoe".

> +	  Actions get attached to a Hardware offloaded classifiers and are
> +	  invoked after a successful classification. Actions are used to
> +	  overwrite the classification result, instantly drop or redirect and/or
> +	  reformat packets in wire speeds without involving the host cpu.
> +
> +	  If set to N, TC offloads in both NIC and switchdev modes will be disabled.
> +	  If unsure, set to Y
> +
>  config MLX5_TC_CT
>  	bool "MLX5 TC connection tracking offload support"
> -	depends on MLX5_CORE_EN && NET_SWITCHDEV && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
> +	depends on MLX5_CLS_ACT && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
>  	default y
>  	help
>  	  Say Y here if you want to support offloading connection tracking rules
