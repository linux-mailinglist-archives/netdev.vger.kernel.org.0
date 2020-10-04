Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F097282DC2
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgJDV32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgJDV32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:29:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F718C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 14:29:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 168981277E5AC;
        Sun,  4 Oct 2020 14:12:37 -0700 (PDT)
Date:   Sun, 04 Oct 2020 14:29:22 -0700 (PDT)
Message-Id: <20201004.142922.2271238418704854925.davem@davemloft.net>
To:     martin.varghese@nokia.com
Cc:     gnault@redhat.com, kuba@kernel.org, netdev@vger.kernel.org,
        dcaratti@redhat.com
Subject: Re: [PATCH net] net/core: check length before updating Ethertype
 in skb_mpls_{push,pop}
From:   David Miller <davem@davemloft.net>
In-Reply-To: <DB7PR07MB388310D80E3D8AF484EEB266ED0F0@DB7PR07MB3883.eurprd07.prod.outlook.com>
References: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
        <DB7PR07MB388310D80E3D8AF484EEB266ED0F0@DB7PR07MB3883.eurprd07.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:12:37 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Date: Sun, 4 Oct 2020 14:50:58 +0000

> Is this check redundant. I believe Openvswitch already takes care of it ?

Openvswitch isn't the only user of these skb_mpls_*() helpers.
