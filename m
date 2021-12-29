Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE0480F6D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhL2Dua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbhL2Dua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 22:50:30 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C2AC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 19:50:30 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id v11so17713014pfu.2
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 19:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h8IUndyKz+9Bc8viNZY0CRqNhLarhk1Tr2DPySo1/C4=;
        b=odGVN/9IXcfb4qhHETH5uJblv7En896cE49Rark4PPUHiRhJfo6Muucoo0dOTYcKK4
         sJDXhlgXQIldX0VYVcuw46DocYuJ2QDPb+vCjS8kpMlmQ9xQzF8PyqMZefGBi/ME42H/
         YtJJ0gz2itjvu+Csonl0mGjd2CLQqTvOurv3KsSE84fcDNaOgVGQy3FtjgDMuFrBr6q8
         IMZlovHQ+iOle4pwDlBE8AS+tfDztqf1X7J8L0pwcnRjUbrJV1m8zk811M9bQcnGqLPZ
         /ssh1kcIS/jOhfUyH0+zrqCDExLUuW+A3g5NNv85WcoBF8lQqdNdHuYLXTIOu33kfXa7
         B94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h8IUndyKz+9Bc8viNZY0CRqNhLarhk1Tr2DPySo1/C4=;
        b=Vt2OpQMyrE1Ggfd6/+B9ANVUzcDNmfh4QY+IAfQlGro6jx1uzSovqs6TlbSo9bGyLZ
         IIhQR5Xqrr758tXDCdbJQnfm3CES97TohsDEMDjzMzaOuCHcyihUknpbJrhXkzFXEQ3C
         x9ePxUM0DlGGOl80WRJN7tbSe+VRkiQKQE7TkBEzb0IxSo2mDGPdY0qY9VliUC18U5K3
         pzSEtEfgDsmF+9C7szkJH8DRfGka56+J4jXHcFmQjH2D8bNp463pzEJYI8qP9gtFVkZ9
         2NwWkMr4QJbqKMRjyNmP2DViRa64UX1oWKLkF09OhcKjG8Ry8Fi0ysgIzOEii5RsPU4n
         fsEg==
X-Gm-Message-State: AOAM533nAgIBXol8EQaLJXVL4tfacKsMEWm/tsykncDnlMgd9Ns+ZPFa
        0oI7xPS4Yw3dB4oE2Bvy9iEZJ6mba6Q=
X-Google-Smtp-Source: ABdhPJxFpQEbJARqYXn+R17Qb/GcNsaFBlBnxcxVSyMa8awOnNtyBe/UXpC4rf3A8QqNO79tY9IYAA==
X-Received: by 2002:a63:7e01:: with SMTP id z1mr21749333pgc.238.1640749829571;
        Tue, 28 Dec 2021 19:50:29 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s25sm22097519pfg.208.2021.12.28.19.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 19:50:29 -0800 (PST)
Date:   Wed, 29 Dec 2021 11:50:23 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <Ycva/zEW4P0B5RAM@Laptop-X1>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
 <20211210085959.2023644-2-liuhangbin@gmail.com>
 <Ycq2Ofad9UHur0qE@Laptop-X1>
 <20211228071528.040fd3e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20211228160050.GA13274@hoboy.vegasvil.org>
 <20211228081748.084e9215@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20211229020339.GA3213@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229020339.GA3213@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 06:03:39PM -0800, Richard Cochran wrote:
> On Tue, Dec 28, 2021 at 08:17:48AM -0800, Jakub Kicinski wrote:
> > That's still just a compile-time fix,
> 
> I think Hangbin's immediate question was about compilation.  linuxptp
> needs to be able to compile against older system headers.

Yes. That's what I mean.

> 
> > if the user space binary 
> > is distributed in binary form (distro package) there is no knowing
> > on which kernel versions it will run. I think runtime probing will
> > be necessary.
> 
> Yes, that too.

Thanks, I will pay attention on this when do user space implementation.

>  
> > If we want the define it should be to the enum name:
> > 
> > What about adding matching #defines into the enum declaration?
> > 
> > enum hwtstamp_flags {
> > 	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
> > #define HWTSTAMP_FLAG_BONDED_PHC_INDEX HWTSTAMP_FLAG_BONDED_PHC_INDEX
> > };
> > 
> > Examples in include/uapi/linux/rtnetlink.h
> 
> Ha!  I knew I saw this somewhere.

Thanks for this hint.

Cheers
Hangbin
