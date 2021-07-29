Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E7A3D9B90
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhG2CDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhG2CDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:03:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F56C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 19:03:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d1so5077680pll.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 19:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IZah8dMI3miWSXLvjvWWjJ+HQXuxd8zF9a3wtlgK9eg=;
        b=HGwBRSqighFYIKvIv6CqqX28o7rht7Hqo4Fi+PjI9lIhLArlu2Ev1m1+3gZksAHamq
         VeBZeHvt+D0WlPHvUXvrPvPGhVvCvtO0dpIHv0jXOfUXfSsGwzSjmhiAqyBvo7EFaXKC
         mpszz3J3/1R3N+o4BdUB9MLVdnHB8Rlz/9G4eNCJzCGn6AFdmRfA5OBT8s38R3mHN4bk
         L8VaQorkZDyzLYN7MvEda8XSiObnl4E9JDCPUXMB5rea+nPJXMNO36gCsmWTZnLl4T4K
         Jcy4FqdarlN0buyX9VMn5cL80BEEZKLg5UgnYHTXb6XePaM9OGbhB7wNBRNCmKWnYfT8
         G0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IZah8dMI3miWSXLvjvWWjJ+HQXuxd8zF9a3wtlgK9eg=;
        b=CXYsNcA4XNqzdOvvnlTfVQG7UrrvFJyfV2FOM9rIbTTGCVKoERFGEz/YmT3/7zUH2q
         G3O7eltkc8tFGZQJ+4GCy1ihQeeugjlXirHl4qQvRtNNmHFMjnwwWxUuhyAVkCcr9Wm+
         KSE1L5HXQ553XWQ53RCG4qImScpxLecI2hM7YR8FbByM3wUg03JUjqm9LZ13k8XOn1km
         CtlES/S9bGOHyG87hqrYStFxU4qiYJYA8ixjIfj1wcIG9p87zvF4DGskey81DoFLJHis
         S5z5F29T8WMWF96YuhK2lB+7oSYNqq2m2o0B2dkTqPI6pgQzCBaPfSgX2Sx3KCoeIbFH
         CZcA==
X-Gm-Message-State: AOAM533An2wCC0Rbol+yRygcXFJ14HsByIRNdpP5GCMh0pr8On0J2pQu
        tunE2H6mdyjMUdU4yJZaCTs=
X-Google-Smtp-Source: ABdhPJyEZ7uy7ZbK4+DGcDqFjwq8CG+YSAkbbEAKX/tWfWPMAxuflirVGgzrA40e5JwC0oUjvF+Sxg==
X-Received: by 2002:a63:3f42:: with SMTP id m63mr1712705pga.33.1627524210105;
        Wed, 28 Jul 2021 19:03:30 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v7sm1057720pjk.37.2021.07.28.19.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 19:03:29 -0700 (PDT)
Date:   Thu, 29 Jul 2021 10:03:23 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] bonding: add new option lacp_active
Message-ID: <YQIMay98k1OjAmjm@Laptop-X1>
References: <20210728095229.591321-1-liuhangbin@gmail.com>
 <YQFiJQx7gkqNYkga@nanopsycho>
 <3752.1627499438@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3752.1627499438@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 12:10:38PM -0700, Jay Vosburgh wrote:
> Jiri Pirko <jiri@resnulli.us> wrote:
> 
> >Wed, Jul 28, 2021 at 11:52:29AM CEST, liuhangbin@gmail.com wrote:
> >
> >[...]
> >
> >>+module_param(lacp_active, int, 0);
> >>+MODULE_PARM_DESC(lacp_active, "Send LACPDU frames as the configured lacp_rate or acts as speak when spoken to; "
> >>+			      "0 for off, 1 for on (default)");
> >
> >Afaik adding module parameters is not allowed.
> 
> 	Correct; also, adding options requires adding support to
> iproute2 to handle the new options via netlink.

Hi Jay, Jiri,

Thanks for this info. I will remove the module param. For iproute2, I already
have a patch to support this options. I planed to post it after the
kernel patch applied.

Thanks
Hangbin
