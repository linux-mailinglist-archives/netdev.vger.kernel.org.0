Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7392030E8
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 09:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgFVH4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 03:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730106AbgFVH4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 03:56:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78085C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 00:56:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y20so14732261wmi.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 00:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/b9OG2s/IAOzNyC1p8NoRKjBH9s9rYGS5ztSIjGSCoE=;
        b=BcvNckorixD4BmFdCvs9j5MkNH1+wPJ6HwO/DZKjOnu8v/F3k2DyBU8CHakLi3J8pL
         ti3yTwAfNGkF5qWwgFSOSGnjl7iBPMnJ9/RpjRGAWCLqVsjYg4vsANkYBbBDD2a9Mt7t
         JUBmD4AA9L1RGsUt8umxjUETfLk9zaI/oNJofUYGIa4wOM5E5Tvt31UAjphGNsS+wex2
         Zm51uKUYTNercOxTt3VuN60lsqHEWiivk70XAxSn5RW89TkQEs3pR40QOnWNj4fr9zOD
         2RcVDLQokslB/sv/9H4Jm6rruMfgP9e+/GZCqf0Nux9VeEvxwuAEpPQzqYX5c8XjxP7z
         Ur+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/b9OG2s/IAOzNyC1p8NoRKjBH9s9rYGS5ztSIjGSCoE=;
        b=luHH4aYgqmTWAqrqqw4UD/+fOV9kanzY4EaU+GGK/fersm9T3di9TnH2UrB+YZ5P+t
         QcP9CQfg98zMMuMLATU3hBRJWfhudCiY+DkVl0r1ulDkF5KvVpHYOyDRVjtOxL+OMY0X
         XgL1z7nFuCOusk4HPkgZC+Q+6ip9uVe7EFvX1sG+q/jiniZ8SJzrgDYssFm30Ttb/Ba1
         gG12imJxxw5A983S1muOhnvrhsIcZ45bhc+AM/BPzvKC46sPytRpUSUnfKEGSuiCvy1s
         RKBl3FG3ErH3fdTqCKvvpn6BHKZUstvOcIxE99bv7nrfECPn/6nraJbuMjTk+tio6IRZ
         wzVg==
X-Gm-Message-State: AOAM530QbLVnvyOXnZGfRhj4fAtzq2LpfBd5jugcteQbyoN2Gn2c9Mdp
        5QIw895UsRKkjkKTjn1emqN/2w==
X-Google-Smtp-Source: ABdhPJzt7ZIBCes8vYTEhfN+y2kip/got3RTOo1/ysjasEcyAxDEpCGXsihpGThj1Q3sQCqI1hd5Kg==
X-Received: by 2002:a7b:cd06:: with SMTP id f6mr16964012wmj.8.1592812567286;
        Mon, 22 Jun 2020 00:56:07 -0700 (PDT)
Received: from localhost (ip-94-113-156-94.net.upcbroadband.cz. [94.113.156.94])
        by smtp.gmail.com with ESMTPSA id z16sm7576418wrr.35.2020.06.22.00.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:56:06 -0700 (PDT)
Date:   Mon, 22 Jun 2020 09:56:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH v2 net-next 2/2] bnxt_en: Add board.serial_number field
 to info_get cb
Message-ID: <20200622075605.GA3280@nanopsycho>
References: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1592670717-28851-3-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592670717-28851-3-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jun 20, 2020 at 06:31:57PM CEST, vasundhara-v.volam@broadcom.com wrote:
>Add board.serial_number field info to info_get cb via devlink,
>if driver can fetch the information from the device.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
