Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5201F268D0C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgINOMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgINOM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 10:12:28 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACF3C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 07:12:27 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so17771173edv.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 07:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YkDjJRWfqlGAuduCEVOILaEtaqS3c7Ol34fg5k0MENw=;
        b=TEalkhKhjRApsZQOHhwz/lM+USWzpU7x6Ybv1YH7KyJ0porTpeAO+tt7QEGspKWEMa
         CVJooXpiuj50M62pZO7HqLQnadCCugcpOPb29kyYMueDBY5s14jZy9fB6rVjYh5eEihX
         0B2SjDblDqqpMmMzCnLAa0utE+7snU1lre1+l8yyPGKX2bLuKLAjhpCayEIe2oBd6G5N
         inn/TlbARMwFDieGtoPyvXkm50GqMeXDFq0Ru40fQVcjbcRcSJjjfHO3vP3oJQNL28xQ
         3aINoi3gpXZKznij00Od4jPQj0R8yM9quIx5QyXHSV3KmYRevakTWIIzW0nhaD6uqTIi
         GByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YkDjJRWfqlGAuduCEVOILaEtaqS3c7Ol34fg5k0MENw=;
        b=TnyEhhELvxTAngD8/FdJMlhfvL30S6NBf69b414svGtwlRaoOZWL1OjMzpWNRXX0ft
         hiqzwBynRIua2xF/ITUITXTyVrixue0cRAADYJANazFC4520YievAn155IfSj4lbz2gh
         iUKIjJpjBGVHqUI3dEXQ5VIEcsze925YTBvspG4o/nzhFRihXmwNuMQBHEVZ+CoMM86n
         iSeot/sCE2xD4jMdHg/O90KAU3Hw4JPOSKk1PSbX1hMQP7cIc7YgD3PNa/fDXkllY0a3
         pqKzCjXhRns4Zx3ZHoVH2GxhKsFfd0YmRo9NSwQ4TtwdIFKHlWfK1JrEN3rQ3WJk0md3
         PpSw==
X-Gm-Message-State: AOAM5328EiO/DBjqKBWGfAqmmkz9Kc9e5fzPCUgdvhgn2RHmTnSz9XaD
        MoT8UfpKUs6+oVQdDAZ6/YRdaj9GvxYbjGp7
X-Google-Smtp-Source: ABdhPJwmk/+mNmcLyM6kTq4XXNnc5tWnPlItZjDw6sTwDcn6zX0ztg86nqWfKC8lEzKGBx0Vlz8jrg==
X-Received: by 2002:a50:fc08:: with SMTP id i8mr17876143edr.257.1600092746469;
        Mon, 14 Sep 2020 07:12:26 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id si28sm7735535ejb.95.2020.09.14.07.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 07:12:26 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:12:25 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 11/15] devlink: Add
 enable_remote_dev_reset generic parameter
Message-ID: <20200914141225.GK2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-12-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600063682-17313-12-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 14, 2020 at 08:07:58AM CEST, moshe@mellanox.com wrote:
>The enable_remote_dev_reset devlink param flags that the host admin
>allows device resets that can be initiated by other hosts. This
>parameter is useful for setups where a device is shared by different
>hosts, such as multi-host setup. Once the user set this parameter to
>false, the driver should NACK any attempt to reset the device while the
>driver is loaded.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
