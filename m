Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B913B235B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388634AbfIMP2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388392AbfIMP2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 11:28:40 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BB92089F
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568388520;
        bh=y6gVoSPeyEbRyda+ibEtbvEXeVxaYpe+xbTa7TiEgYI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bw3x0H7Na1yXZ3aRDDjTO6mTByF+b2Zsv4Iv0tBrc9o8Yq/7GAJtgmF1g7yKYmGfn
         WS+QZu5v54hdPMmHhDXqsR0Ly1dxNYyzGzBxIWNufJnylsJPFsS3mQwvdSWvlciLsM
         k5niJI0Vk5LwENzlNFpKFW9KPsxPCg17CgQB7li8=
Received: by mail-qt1-f181.google.com with SMTP id u9so8396437qtq.2
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 08:28:39 -0700 (PDT)
X-Gm-Message-State: APjAAAXycEINDvOzQ46ba3JIPLi84pKv7tMa33da2o59sa2CeA5f6xW2
        c8N1IK1aDL+dl/wyrspGvZu+L2okfes81aNw0iI=
X-Google-Smtp-Source: APXvYqzZ2LKKLGm7/ohlbW6kF0/Ipz0GRfejg+oJV/YyJWQRZJqu6mgLfaijOoxXd8Fu4NUtRyMX4buHios8TmQvWdE=
X-Received: by 2002:a0c:9082:: with SMTP id p2mr5914578qvp.197.1568388519162;
 Fri, 13 Sep 2019 08:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190913124727.3277-1-paul.durrant@citrix.com>
In-Reply-To: <20190913124727.3277-1-paul.durrant@citrix.com>
From:   Wei Liu <wei.liu@kernel.org>
Date:   Fri, 13 Sep 2019 16:28:34 +0100
X-Gmail-Original-Message-ID: <CAHd7Wqw6bQbzR2gvzGM+bBgVQ8HHQPCBJppSWWqHT7S7Dp27qg@mail.gmail.com>
Message-ID: <CAHd7Wqw6bQbzR2gvzGM+bBgVQ8HHQPCBJppSWWqHT7S7Dp27qg@mail.gmail.com>
Subject: Re: [PATCH net-next] MAINTAINERS: xen-netback: update my email address
To:     Paul Durrant <paul.durrant@citrix.com>
Cc:     netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Sep 2019 at 13:47, Paul Durrant <paul.durrant@citrix.com> wrote:
>
> My Citrix email address will expire shortly.
>
> Signed-off-by: Paul Durrant <paul.durrant@citrix.com>

Acked-by: Wei Liu <wl@xen.org>
