Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494C61BAEA7
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgD0UDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbgD0UDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:03:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAFEC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:03:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DDDE615D6797E;
        Mon, 27 Apr 2020 13:03:23 -0700 (PDT)
Date:   Mon, 27 Apr 2020 13:03:23 -0700 (PDT)
Message-Id: <20200427.130323.976439318095795210.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/4] pull request for net: batman-adv 2020-04-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427150039.28730-1-sw@simonwunderlich.de>
References: <20200427150039.28730-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 13:03:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Mon, 27 Apr 2020 17:00:35 +0200

> here are some bugfixes which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
