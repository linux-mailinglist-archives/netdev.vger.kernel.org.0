Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C7731E1EF
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhBQWRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbhBQWQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 17:16:56 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7BBC061574;
        Wed, 17 Feb 2021 14:16:15 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C50F04D2DE5F1;
        Wed, 17 Feb 2021 14:16:12 -0800 (PST)
Date:   Wed, 17 Feb 2021 14:16:07 -0800 (PST)
Message-Id: <20210217.141607.975797701534267256.davem@davemloft.net>
To:     thesven73@gmail.com
Cc:     Bryan.Whitehead@microchip.com, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, rtgbnm@gmail.com,
        sbauer@blackbox.su, tharvey@gateworks.com,
        anders@ronningen.priv.no, hdanton@sina.com, hch@lst.de,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/5] lan743x speed boost
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAGngYiUV_c7Z-gUCt0xKcP-E_5UVyM9PWBQ_wYK9o5_L0D-1qA@mail.gmail.com>
References: <20210216010806.31948-1-TheSven73@gmail.com>
        <BN8PR11MB3651BB478489CF5B69A9DB6DFA869@BN8PR11MB3651.namprd11.prod.outlook.com>
        <CAGngYiUV_c7Z-gUCt0xKcP-E_5UVyM9PWBQ_wYK9o5_L0D-1qA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 17 Feb 2021 14:16:13 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>
Date: Wed, 17 Feb 2021 17:04:05 -0500

> Hi Jakub and Bryan,
> 
> Jakub, is there anything else you'd like to see from us, before you
> are satisfied that patches 1/5 and 2/5 can be merged into your tree?

They are already merged into net-next
