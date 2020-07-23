Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9F122A3A2
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733132AbgGWAaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGWAaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:30:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C7C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:30:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 854A211FFCC22;
        Wed, 22 Jul 2020 17:13:17 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:30:01 -0700 (PDT)
Message-Id: <20200722.173001.820541571854422126.davem@davemloft.net>
To:     vincent.ldev@duvert.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] appletalk: Fix atalk_proc_init return path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722113752.1218-1-vincent.ldev@duvert.net>
References: <20200722113752.1218-1-vincent.ldev@duvert.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:13:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Duvert <vincent.ldev@duvert.net>
Date: Wed, 22 Jul 2020 13:37:51 +0200

> Add a missing return statement to atalk_proc_init so it doesn't return
> -ENOMEM when successful. This allows the appletalk module to load
> properly.
> 
> Signed-off-by: Vincent Duvert <vincent.ldev@duvert.net>

Need an appropriate "Fixes: " tag here, if the module hasn't loaded
it means nobody has been using it at all.
