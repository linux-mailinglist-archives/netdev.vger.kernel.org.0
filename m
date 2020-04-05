Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0FC19EDDC
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 22:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgDEUOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 16:14:51 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:38253 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDEUOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 16:14:50 -0400
Received: by mail-ua1-f67.google.com with SMTP id g10so4752927uae.5
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 13:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5RZZPCFdrZOQUY0NpVhCKIfJRTC5bG/d80lCyOIHMvI=;
        b=GGhHZrDPPbkuzuguWgms3SM2M2r0UKmzXGPaAggqc+tXUrrldJO9EKkeDqA8Xq4f4M
         n6SE42S3xLoU8IYHjcxnJtJcsXwJqwpf4FnHHnJA/3G79TzB+hKrLF8lGCWgNKfmK/6N
         vhyhilkBjED6nXY3rv8nCdf+t8Q4Mtk49+hKNmdfXoRTbLcnzpfXqLsrlKHI2ZGUQr0u
         Mwirm4hw3GYZLAmtCJSijBMF5SHXE20JO7gBJOKiVHx/Sr4WC+QxTNifGHPrxfRyOJlM
         OuKbZiiLA+LY/YyfGaJ+raq8FpX55yIvJriPPGMyfrMd6Ry+LufuOqNzNaVcLvQZrx9w
         92MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5RZZPCFdrZOQUY0NpVhCKIfJRTC5bG/d80lCyOIHMvI=;
        b=DQUVpI+0isPQN14KDHV5dRIXjv8STFEfe8Z/h1BZ16cOv0b9dCnPArz8PVro+yejTQ
         o4WvITnoN2bhNe1/B6W67v2dCO4/25XpmowwwLE0hdkjlwBH7J/YWgCA1l386GSrcNpJ
         h2rv8LfeCyeertomSpvZKJPekfQfLPc3IIScgAtUVpICaD0Z1/uZhrY8tnttCD4IDpE0
         Cjgr0/0gTGw/bk+/c/IO/+iWgB+1lPFAKn82HS1JWFzoy8x3Q+1yW7nqh+4bKp7MV7wE
         7AUl6ZlhsOVqKIYldX0k6dYoSRUEGeyPq5Eks+lBCO9Yqh4/lg8PxHLsyVQg2vijagoL
         suTw==
X-Gm-Message-State: AGi0PuZ+jQbId+qAC458Z6bidIaDZnCGFzvFmYgjBu+lhA5jbOqeRqUE
        qDKksUpwMVcALQEWWS0ZSKQ6VbV/oVPa27R6q/9Nyw==
X-Google-Smtp-Source: APiQypK5FH36bz+ECXHur6NM82rZjixh9mlkCGmXkvklZL2waKqFuFQoW77uZcqw/ZVBnmI0yqkHaVY/mKm0ENokkPE=
X-Received: by 2002:ab0:6185:: with SMTP id h5mr13446724uan.23.1586117689615;
 Sun, 05 Apr 2020 13:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200331163559.132240-1-zenczykowski@gmail.com> <20200405200522.5pcxitjcnxss4e7r@salvia>
In-Reply-To: <20200405200522.5pcxitjcnxss4e7r@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sun, 5 Apr 2020 13:14:39 -0700
Message-ID: <CANP3RGczLdp831hQvxAPp_RPdf=A75zKoEEkFE+QGcw0sPy62w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jan Engelhardt <jengelh@inai.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Maciej,
>
> I'm attaching a new version, including EOPNOTSUPP if the send_nl_msg
> field is set, it's the most basic handling I can think of until this
> option becomes useful.
>
> Would you commit to send a patch for this new merge window to make it
> useful?

Yes, I can do that.

Thank you.

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
