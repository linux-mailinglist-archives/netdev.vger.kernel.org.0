Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805BD247956
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgHQVzq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Aug 2020 17:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbgHQVzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:55:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2691C061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 14:55:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EC7815D679E6;
        Mon, 17 Aug 2020 14:38:57 -0700 (PDT)
Date:   Mon, 17 Aug 2020 14:55:42 -0700 (PDT)
Message-Id: <20200817.145542.1273892481485714633.davem@davemloft.net>
To:     alsi@bang-olufsen.dk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] macvlan: validate setting of multiple remote
 source MAC addresses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200817135858.2661316-1-alsi@bang-olufsen.dk>
References: <20200817135858.2661316-1-alsi@bang-olufsen.dk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:38:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin ¦ipraga <alsi@bang-olufsen.dk>
Date: Mon, 17 Aug 2020 15:58:59 +0200

> @@ -1269,6 +1269,9 @@ static void macvlan_port_destroy(struct net_device *dev)
>  static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
>  			    struct netlink_ext_ack *extack)
>  {
> +	int rem, len;
> +	struct nlattr *nla, *head;
> +

Reverse christmas tree ordering for local variables please.
