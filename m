Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34A930CBB6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhBBTdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239587AbhBBTbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 14:31:19 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD02C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 11:30:39 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id l23so15784623qtq.13
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 11:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8fkoU9zm4gATdbtkMdpLPBgQybgWaU56gpeMC4190qs=;
        b=OAZKSvQ3iSeaHlcOwTyAYxmeEy7YsTFtXARtJHjF2YUoKUkCv1l8tF3qPAAwo4nA71
         HYY6gKzp2NNQh4sQt2xg9OAwvJv3sE0v9xKPV6j6uHGx4CFq58s2NZVdqxSC2D5uG5G8
         vx851SbblRh4KkjTzhBqCREZW1wWGPKHYwAcrlzv1lMGuPF/Q8QcHXcG4mnPPDH5HKzw
         9T5FQ10RW9NnR3JYcGcEko5sriVtRV9fHW/Z6jBDMuHmY5XiUjyIzUNFer8wwRnM+5fd
         7sm2mixcDHXxH+KcUnEEtzWUGV5xtPxBpDBhWvu1XdIxVwrHmB5KJ2sKtYFiz+IQrHDB
         i5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8fkoU9zm4gATdbtkMdpLPBgQybgWaU56gpeMC4190qs=;
        b=P8PiVowWoteymm9deyipqLDdnTXWkJkZWzt98c2eMOTinOb4srHzpnT3WDrvA6xvJD
         w6nDXjI58w3MdJYzj6t0+slRqDsnTM+obXV3b6iIO+8hnAbvuqlNYJdDuTNUhhz7dC62
         d7D4rEfK9C6rXyemvi8+3AnIsiJmJA5/CgWDjYanZdzT3u8gd8yM0Kcim/Ly/29P1pug
         AMF2UbK40ii9333HLvU5NGymm9MSuh/4RA6AePt02WR6guVcBCs2we7BeMTTIP6p1Sqc
         bCwpjnX8V/4TFoU7f3QSk1Av9YMkh91cJIrlUMSIAfRvYIuCtkrwf4/uAwbo13VphNc0
         3waQ==
X-Gm-Message-State: AOAM531wwbFFWef4gEdDqXM+5MkkKYOS7xuJYiKH+8024/p5SW825CKz
        iDLXTXs7aiQLdrE3OaH8QZqKcWpHObWrHVKW
X-Google-Smtp-Source: ABdhPJx3UYtZwb0h5ZJ57ZrVFP5cPTGgfkSlaFdihe1OD1ZcBWkEGVl+vdN2Y8DXRiXd7IlZYBxgvQ==
X-Received: by 2002:ac8:57c1:: with SMTP id w1mr21645089qta.313.1612294238493;
        Tue, 02 Feb 2021 11:30:38 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id s15sm16624718qtn.35.2021.02.02.11.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:30:37 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 7B83CC008F; Tue,  2 Feb 2021 16:30:35 -0300 (-03)
Date:   Tue, 2 Feb 2021 16:30:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next] netlink: add tracepoint at NL_SET_ERR_MSG
Message-ID: <20210202193035.GI3288@horizon.localdomain>
References: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
 <20210201173400.19f452d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210202123007.GE3288@horizon.localdomain>
 <37002645-e09b-1067-eda6-ee30155afe47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37002645-e09b-1067-eda6-ee30155afe47@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 09:16:28AM -0700, David Ahern wrote:
> On 2/2/21 5:30 AM, Marcelo Ricardo Leitner wrote:
> > 
> > Also, if the message is a common one, one may not be able to easily
> > distinguish them. Ideally this shouldn't happen, but when debugging
> > applications such as OVS, where lots of netlink requests are flying,
> > it saves us time. I can, for example, look at a perf capture and
> > search for cls_flower or so. Otherwise, it will all show up as
> > "af_netlink: <err_msg>"
> 
> Modules should be using the NL_SET_ERR_MSG_MOD variant, so the message
> would be ""af_netlink: cls_flower: <err_msg>"

Ah, right. They don't always do, though (and that probably should be
fixed). Also, currently there is no _MOD variant for NL_SET_ERR_MSG_ATTR.

For example:
$ git grep NL_SET_ERR_MSG -- cls_flower.c
cls_flower.c:                   NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
cls_flower.c:           NL_SET_ERR_MSG_ATTR(extack,
cls_flower.c:           NL_SET_ERR_MSG_ATTR(extack,
cls_flower.c:           NL_SET_ERR_MSG(extack, "Missing MPLS option \"depth\"");
...

> 
> I get the value in knowing the call site, so not arguing against that.
> Just hoping that your experience matches theory.

Okay.

Thanks,
Marcelo
