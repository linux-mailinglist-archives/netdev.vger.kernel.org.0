Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D875EFC08
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfKELGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 06:06:45 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41048 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfKELGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 06:06:45 -0500
Received: by mail-wr1-f44.google.com with SMTP id p4so20808355wrm.8
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 03:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7Et23a+EwcsILQrtYEtbuKMdE4GHZ7vJ0zIpIYFLl/I=;
        b=r3Bc7xygU9dmMtM2lMtK3ZIhNmXr51ep1hk6Jk/FB2ZIr2N5KEXwTkuHNslnb8zk8E
         fHfjsfsiqEEuzkVNx5PwQPJo03ExK9H4OjKBTPeOXhq2fb+aAS/gGTbzLhvVKY7BiUpl
         zkMMKo/LLpTzL/REuCqGUVQDOW7gN+6vrVtAAXf5GfAgh/EAiGocXod7T+MyEgiwYDlK
         fJA05rwRoRx11nnnqgwQirBWCzapritubzSLrScZsRVT7FbTRf6AhQSkJxOQyP3NKxMC
         BlV74lf9J0Kb2kK55BLwxJ92ig1nBBwhVqW24z3B44GHkLAklJbbcsUsqdfGEvTS/cOo
         Er5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7Et23a+EwcsILQrtYEtbuKMdE4GHZ7vJ0zIpIYFLl/I=;
        b=GhfNBNwyuFgeF7Zjdvh04hI/zUlBrY6nFc4zwfKB7uBOsMMD5d1xZYboTqXQnwTETH
         howGDcDfZjWGfi7WSlVG5MQDqmzsVBBAXj7Qh7qVWKPguifDUYfrgQb3HvaAO4bIahmV
         dEaiBuHu7ybEnm9NmvTwmofEUp00F1zqPxLwhhnE6CzT7kKTrQJxgUnacZvQOI/yGcLO
         LeZuOE0ZcioDn9ustI/LlN728d0NcFPLXZg7h8pSyMSEIWoX6sfF6LoeDQ1vwH4UzNlU
         X4DbzhREYJiuVUbbowOhzTqt1o21dBy6UUTi4YQwDaEY+KyQJxGipbjTf5wgl1FBFe0P
         Wx6g==
X-Gm-Message-State: APjAAAWOcU1IM97lx0MjRwe7QrH+zhHY1RvEC43thdQ12blJ6Ed6NM0D
        2HB+iok7LSHqxyZN4PmA9s0EeYXF1UeMuurru0WBvg==
X-Google-Smtp-Source: APXvYqxbdXjsA3597J3Tn6Yzu4g6ipkLxCKRkl3zh3QH5JQpw8mxJUcIe9gjSLfyxUP1P63epxQ2VXEpmiMzetYhXb8=
X-Received: by 2002:adf:c50a:: with SMTP id q10mr20320312wrf.374.1572952002158;
 Tue, 05 Nov 2019 03:06:42 -0800 (PST)
MIME-Version: 1.0
References: <CAKhyrx_DyX5brCeMrPOvrBWmq0TscCi0z=WkvwKgJ6gGfz6ysw@mail.gmail.com>
In-Reply-To: <CAKhyrx_DyX5brCeMrPOvrBWmq0TscCi0z=WkvwKgJ6gGfz6ysw@mail.gmail.com>
From:   vijay nag <vijunag@gmail.com>
Date:   Tue, 5 Nov 2019 16:36:30 +0530
Message-ID: <CAKhyrx_n9SOUYxCGq=HNzqHWqwLvfoxbeJ8rpxswFxMrBGRUkw@mail.gmail.com>
Subject: Fwd: veth ethtoolk settings
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Netdev,
I'm trying to set a feature on veth pair in the container namespace
but I see that the setting is not applied to it's peer. I'm trying to
turn off gso using ethtool but looks like it has no effect since it is
not percolated to it's peer.
Do we need a veth_set_link_ksettings() for veth device ?
