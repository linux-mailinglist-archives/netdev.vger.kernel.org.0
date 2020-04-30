Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E811BED15
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgD3AqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726329AbgD3AqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:46:00 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0912C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:45:59 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h124so4071955qke.11
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yvw3P+CpB7Wk5MYRL7tnjKZJvayMQVWrJZk/gWus2WE=;
        b=ailhYzc/n6gdzhjfLR+KsqJzo4FRn9q+hhaxcnDIveRXvhmMwuy4pQlKWt6jHzoOLT
         OKu3b4sMAWzXkVRG7SVDpWTa7m6hoSC41eMaAeZZ+fHWVLKhF31wHWgCfHrNwD8Ps/yM
         jwrAcmRA5wY0hnzd+e9IUamgLZ1B22xJBSDFv1gfMOnki00rvT/slYZbQZPUnYHPrAw6
         qQ58xyB/sAsdJOThG23jRr088gCXrSyIi5HLptLgAMzmlqH1WJcAxwbt+aSx2QRkDVj3
         exVSj2ZnARy7uIe6ALkQlSIcesc8XY68OGxo0xe/oEITtP/lWJAszy+iDDQ/aVmk5HHS
         1zRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yvw3P+CpB7Wk5MYRL7tnjKZJvayMQVWrJZk/gWus2WE=;
        b=rKl21TPiEpdITnDBIkpxTAeZXHUcPOSa0+vV9/Ot41uaGN0ek722ZQzEwWCLoueizS
         u3hwp1VPV/DDkG6yjsMTMLAdZgYWzsOKQ9gLsPrVKPRLW3tD9qg6hq7yVDpnyVqaa6AT
         rtWPIjvR+DxWwEnSz0AUUnVYCewp9dE7Zfj1IZJccGvQ4XvYjGIi8ccvtJ7l6QXHei0m
         ccMQtA4oj9OPYMbdt7CgOnu+fwOpjdg2OifvRamLlnPcj2YGJ/UyGcfCjPK2jlFQ+6ul
         Ni2XMWI/dzmXFfBk2hCqKUxMRqgp2ZNHSJKBwEtHU8+7V/AZpmZqQQbVmXD2joYDYDoL
         Gupw==
X-Gm-Message-State: AGi0PuaSiYIjG4E0LrsD8K51EhX7lVQ6Gm7BG0okkZGCP/E7u0CtStXG
        QIpJKciiFN7RB2mjWHH2tYMzu6pu9lCEnELh+rI=
X-Google-Smtp-Source: APiQypIXLiZ+Xy0u0aiUlLcq6Q5dNGIBxoLyYvnJ36F9VONCVhmOQmDIv8qmHLalbRs+M8mzZSnAjlU+RP/ZKiWKtyw=
X-Received: by 2002:a37:2714:: with SMTP id n20mr1131567qkn.291.1588207558985;
 Wed, 29 Apr 2020 17:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <1587913455-78048-1-git-send-email-u9012063@gmail.com> <435b0763-5b7f-fc4b-5490-e6ac36ec0ff0@gmail.com>
In-Reply-To: <435b0763-5b7f-fc4b-5490-e6ac36ec0ff0@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 29 Apr 2020 17:45:23 -0700
Message-ID: <CALDO+SZY+VVfYXfwUE6z7TzqGkK8fpak8-a3XJ8_ghwyyxJjwg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] erspan: Add type I version 0 support.
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Xin Long <lucien.xin@gmail.com>, guy@alum.mit.edu,
        Dmitriy Andreyevskiy <dandreye@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 2:52 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/26/20 9:04 AM, William Tu wrote:
> > The Type I ERSPAN frame format is based on the barebones
> > IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
> > Both type I and II use 0x88BE as protocol type. Unlike type II
> > and III, no sequence number or key is required.
>
> should this be considered a bug fix or -next is what you prefer?
>
Hi David,
Since it's supporting a new type, I'd consider -next.
But either way is ok to me, I don't have have any preference.
Thanks!
William
