Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD65C587A8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfF0Qvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:51:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47051 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfF0Qvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:51:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so3331557wrw.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bj+nVcLK7F9gx6IMkKjShqPCMi82gkoatJIMUMDCp6Q=;
        b=rrjvoSpjArU1wlf/4rEEd8bWn58rUskvI6IHgkMtvphxBUhuwq45YuZ7+fongWMKzP
         rLYOR1rQAPPrxX0vnQEG9VXomMzAJQb6gBuxULxqeUBQ1RrTeFbLUy9bsfR2epgwfs4l
         mljUbMpO5O0LxSH+uUpP8njEvkpzwZ5u/IpVUiLGKlaDRyI3MNpbXPci4bmN+wn06dPq
         yT8y652ytrDHnOnUahbkTiLWb/u7j77ChnqIqyzJBVz0El+cneMcNZwZe/8pza/h2G3d
         adKQuWQ795MgC86a0NucU6EMi740aZeM1bTI/n1pC/u3HJPbcmnm7XygX6QI4i0b+6c2
         Jocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bj+nVcLK7F9gx6IMkKjShqPCMi82gkoatJIMUMDCp6Q=;
        b=sUjeDEuj+jZxhMPBCzx0CI065yMKthByuV29uUfhRGwbEe+o8ixxxT1mC+rA4IHhSk
         Kc5dc7pcJCA8QGjLTk8w2wDQQeCSCI9wCoPeM30DdsQrUSQBR3lhFJ4KRUeFtOvwMI7t
         jeL8sSswUEbs0y0excd7YLnsunLrTvUV69ysVH8XTpWlr0MoJrLYb4UGAjpdjmKaz7En
         /VOJ45+gLqEBFALJ02BySjrtZOq7DssLbUU/ZYj08/R5YtvdltpnW5Uk5SNi2gxCpJVO
         B978G1HlMC9E1onTXNptOdwVKth1JyAAmNOG/sWxs1DrqlgZdc5+BDNpmpSqkIVzW1zt
         rjkg==
X-Gm-Message-State: APjAAAUgW21yqparF7MTYnf7bpu+qqi+WpraTklEc5clKAZOyIBf1Rdg
        CvV8oGLbDQ3eAAWpks138+E=
X-Google-Smtp-Source: APXvYqyPs+3twGVkoqL3xKatIDRZnyN3RHLYE/wN84UXKi7GomdLQqkNVCwhSSPtArcLY9hYrI7kPg==
X-Received: by 2002:adf:e301:: with SMTP id b1mr4295227wrj.304.1561654297318;
        Thu, 27 Jun 2019 09:51:37 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id y12sm1904541wrr.3.2019.06.27.09.51.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Jun 2019 09:51:36 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:51:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/16] mlxsw: PTP timestamping support
Message-ID: <20190627165134.zg7rdph2ct377bel@localhost>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 04:52:43PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This is the second patchset adding PTP support in mlxsw. Next patchset
> will add PTP shapers which are required to maintain accuracy under rates
> lower than 40Gb/s, while subsequent patchsets will add tracepoints and
> selftests.

Please add the PTP maintainer onto CC for PTP patch submissions.

Thanks,
Richard
