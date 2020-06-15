Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB01F8BEE
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 02:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgFOAX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 20:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgFOAX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 20:23:56 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04FFC061A0E
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 17:23:56 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z1so11351837qtn.2
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 17:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFkdgd/PyQCkiqAKVLG696044+AVF6GXn25/XKsTdUE=;
        b=qgsO4FAkP4/3LctbBMR5l7i1UYbTpLQ/quXMuC4rIT+VNEJVzZNMrTxZL/AW+E4AtJ
         vdub6+ppxIGWBmyHpc5kZXcE4zvg6XF0VsGz6rmXDMk+TWvxoiVa8vx0XUDV4UufxntA
         H9aIdc6UXlFtpUBB0mr0v6jDznz1VYwTjzxeIynNFD3nsyADAdm47m1FdVNAe4/iLs9A
         trBOo7Ijvs3yd73jg1nJ+VVcP9Fh5ywPkEeSBFZT/dIiEyw/g7vd6WnJk21lze710s6M
         iSF+W+O8+HNn5Z6hGRRreLeknQ0OEp+9LW+cMvCIH0Wx/idkLa2nGfs3tHDBGsdrUTlj
         n1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UFkdgd/PyQCkiqAKVLG696044+AVF6GXn25/XKsTdUE=;
        b=YGnP9YE6wFhIPU4cTIoKqkBBMNpzMCcmTGog23jcco5yh1YeJsdIGHCLBTZRzA8BrY
         /wUYhMwD/brHiqHuKZKfxoIflO92oD53U7F+gR805k1BPY6Jpjv1EjMt6/UF/kKAciDN
         YfWbO0ERV7nuNRwfhbl64ziajARk70DBcSrNX+Hk33O7zmrMX+cv+ei3SPxA28OKVNyB
         zDCPILu33BbePTyqXh3Hl1csgcfCevfKBgci+TjuNVhVDrkQFMrZVOHwFwHFOD3E5FeH
         KA8DQwz9RyMWZ0acfuSfzdIt+oi32BljBvAaVVH89FkypMOJcGJ37BH/9eBSsSFdeUOv
         3aTw==
X-Gm-Message-State: AOAM531eAjaXXjf1loF/gtUggoGskIY3Uy2h4aSnbIjQ9kgmkpUYRIgW
        X+XVqbPFXgSW+PUwbZdxD3gQG6Noxyy+pphJDTzq79JbopM=
X-Google-Smtp-Source: ABdhPJxyc1Ev3EgYLBLR6AuvAijQqKIl3WN/0xW6tU2NVDVwQ3oegLbtodjdVDMzGIIV1IXFcwZGPSObtMEA3htIKY0=
X-Received: by 2002:ac8:27b6:: with SMTP id w51mr13864036qtw.124.1592180635862;
 Sun, 14 Jun 2020 17:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200614071917.k46e3wvumqp6bj3x@SvensMacBookAir.sven.lan>
In-Reply-To: <20200614071917.k46e3wvumqp6bj3x@SvensMacBookAir.sven.lan>
From:   Matteo Croce <technoboy85@gmail.com>
Date:   Mon, 15 Jun 2020 00:23:20 +0000
Message-ID: <CAFnufp3oqcqsuhTC975iVu5-ZPAVZm3RBsY2fdq10=g1eOu7Tg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mvpp2: ethtool rxtx stats fix
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        gregory.clement@bootlin.com, maxime.chevallier@bootlin.com,
        thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com,
        Marcin Wojtas <mw@semihalf.com>, lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 7:19 AM Sven Auhagen <sven.auhagen@voleatech.de> wrote:
>
> The ethtool rx and tx queue statistics are reporting wrong values.
> Fix reading out the correct ones.
>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Hi Sven,

seems to work as expected now:

# ethtool -S eth2 |grep rxq
    rxq_0_desc_enqueue: 983
    rxq_0_queue_full_drops: 0
    rxq_0_packets_early_drops: 0
    rxq_0_packets_bm_drops: 0
    rxq_1_desc_enqueue: 14
    rxq_1_queue_full_drops: 0
    rxq_1_packets_early_drops: 0
    rxq_1_packets_bm_drops: 0
    rxq_2_desc_enqueue: 12
    rxq_2_queue_full_drops: 0
    rxq_2_packets_early_drops: 0
    rxq_2_packets_bm_drops: 0
    rxq_3_desc_enqueue: 4
    rxq_3_queue_full_drops: 0
    rxq_3_packets_early_drops: 0
    rxq_3_packets_bm_drops: 0

If you manage to find the commit which introduced this tag, please add
a Fixes tag.

Thanks,
-- 
Matteo Croce

perl -e 'for($t=0;;$t++){print chr($t*($t>>8|$t>>13)&255)}' |aplay
