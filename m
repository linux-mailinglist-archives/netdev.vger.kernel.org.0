Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8DA1076AA
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKVRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:44:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38176 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:44:39 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDFD51527DCBC;
        Fri, 22 Nov 2019 09:44:38 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:44:38 -0800 (PST)
Message-Id: <20191122.094438.2187613497633111748.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next] net: flow_dissector: Wrap unionized VLAN
 fields in a struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c2be1d959f0d710dbbb99392eeb190a81952307a.1574437486.git.petrm@mellanox.com>
References: <c2be1d959f0d710dbbb99392eeb190a81952307a.1574437486.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:44:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Fri, 22 Nov 2019 15:47:21 +0000

> In commit a82055af5959 ("netfilter: nft_payload: add VLAN offload
> support"), VLAN fields in struct flow_dissector_key_vlan were unionized
> with the intention of introducing another field that covered the whole TCI
> header. However without a wrapping struct the subfields end up sharing the
> same bits. As a result, "tc filter add ... flower vlan_id 14" specifies not
> only vlan_id, but also vlan_priority.
> 
> Fix by wrapping the individual VLAN fields in a struct.
> 
> Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Applied.
