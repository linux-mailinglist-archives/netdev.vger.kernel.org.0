Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A911741B0
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgB1Vv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:51:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36824 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgB1Vv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:51:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id d9so2184441pgu.3
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 13:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9GD06KjmcX8Sy3WIFzeZWhTdIK/pX438q54YaqvPvvI=;
        b=fWHM8bcuUIy3Q+qDmIs+uxScpsCcqiXdlsTqZ8FdkhAGiRavhUUklWjmQxYsLLbrif
         rzi7RWP23ZU+tQjgC/Xc3+keDJTdMnbz/6Pz3HSMFDdm/XjSQ+Jcnx2/ZR8y+U3qlxS5
         /eMVaRJvcYdcP+GIWi5X2H+VafwAjDbykR7HgIUYqswi4DtXyL3bFg0B/XcCWrMqvzsy
         PR5I4SxDXqCg4u6MefjNfdvMO63S7hLX0bHcrXYfaWPH+gCvx2sg2/uBDkXjpipHZgwZ
         tz17oe4faKeezYSrrYe9wLVpgHTLEG0mr29blN1SWFxe7FUXMBhQm4c5x7VD5GvlJtCe
         7H9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GD06KjmcX8Sy3WIFzeZWhTdIK/pX438q54YaqvPvvI=;
        b=YrNmhr+p9JDrss3Fcfem56sIH7N3MInZqOh5xXndvfw0Wznx1PoN2DT7XAHWO3CB7f
         4Zo+FffuZOj0LWKLU2Rn9jzGnP5/JZyuG8Xh2C+fS8bJ6ip2DEfHk0WLc3U0P9ARM5M5
         agSrvU6Ja59BfNYiyabVjUh+BRBUAIMriIQxljoFoNxwP3NDav6V0gtrOR8LMISR7e4t
         UhOIr75hPrhP94mfgYw4Ykx+gfrTdX7/xW1W6oWs0ZQD13Si4noFZXnKqjvS9g5bFJhv
         U8GKjC9tVxPDwwTNn4ArY87kGySTWxdBC0ddpNVZoTn6nkJALnC8ql8jUsqWKSp2S4a0
         Eluw==
X-Gm-Message-State: APjAAAUV7oIG5feFMqS258yDUD75VRTZR8Vub1Sd48MQiPFLqprCs7FI
        2XZ+1rh0w9/uJSORX3KB7cf0jbV1m0E=
X-Google-Smtp-Source: APXvYqx6+sK6n/hI5KG2udv8SfKhh3dkgcuqpYjiAwVNGXDPR9uFA4MwzbfKy0eicFU3uBra5zULkw==
X-Received: by 2002:a65:668c:: with SMTP id b12mr6693914pgw.14.1582926717800;
        Fri, 28 Feb 2020 13:51:57 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r145sm12570956pfr.5.2020.02.28.13.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:51:57 -0800 (PST)
Date:   Fri, 28 Feb 2020 13:51:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, steffen.klassert@secunet.com,
        sd@queasysnail.net
Subject: Re: [PATCH iproute2] xfrm: not try to delete ipcomp states when
 using deleteall
Message-ID: <20200228135154.61960560@hermes.lan>
In-Reply-To: <6d87af76cc3c311647c961e2f94e026bb15869d8.1582556221.git.lucien.xin@gmail.com>
References: <6d87af76cc3c311647c961e2f94e026bb15869d8.1582556221.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 09:57:01 -0500
Xin Long <lucien.xin@gmail.com> wrote:

> In kernel space, ipcomp(sub) states used by main states are not
> allowed to be deleted by users, they would be freed only when
> all main states are destroyed and no one uses them.
> 
> In user space, ip xfrm sta deleteall doesn't filter these ipcomp
> states out, and it causes errors:
> 
>   # ip xfrm state add src 192.168.0.1 dst 192.168.0.2 spi 0x1000 \
>       proto comp comp deflate mode tunnel sel src 192.168.0.1 dst \
>       192.168.0.2 proto gre
>   # ip xfrm sta deleteall
>   Failed to send delete-all request
>   : Operation not permitted
> 
> This patch is to fix it by filtering ipcomp states with a check
> xsinfo->id.proto == IPPROTO_IPIP.
> 
> Fixes: c7699875bee0 ("Import patch ipxfrm-20040707_2.diff")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>


Wow that has been broken for a long time, does anyone use this?

Applied
