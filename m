Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6CDE5687
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJYWjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:39:16 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:39032 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfJYWjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 18:39:16 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id B66821F4C0;
        Fri, 25 Oct 2019 22:39:15 +0000 (UTC)
Date:   Fri, 25 Oct 2019 22:39:15 +0000
From:   Eric Wong <e@80x24.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        workflows@vger.kernel.org
Subject: Re: patch review delays
Message-ID: <20191025223915.GA22959@dcvr>
References: <CAADnVQK2a=scSwGF0TwJ_P0jW41iqnv6aV3FZVmoonRUEaj0kQ@mail.gmail.com>
 <20191025182712.GA9391@dcvr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191025182712.GA9391@dcvr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Wong <e@80x24.org> wrote:
> https://lore.kernel.org/lkml/_/text/help/ has other prefixes
> like "dfn:" which might be helpful for search.

Btw, I'm hoping to expand that search functionality to be
available for both local/private mail and git code repos
while being network-transparent and capable of handling
multiple accounts.

mairix and notmuch both hit scaling problems for my personal
mail; so I'll be needing on something that can replace them.
