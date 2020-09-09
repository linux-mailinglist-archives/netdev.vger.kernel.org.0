Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91266263875
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIIV2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIV2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:28:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A753C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:28:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EB4F12979AE5;
        Wed,  9 Sep 2020 14:11:48 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:28:34 -0700 (PDT)
Message-Id: <20200909.142834.544083235794477438.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, dbogdanov@marvell.com
Subject: Re: [PATCH v3 net 0/3] net: qed disable aRFS in NPAR and 100G
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909174310.686-1-irusskikh@marvell.com>
References: <20200909174310.686-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:11:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Wed, 9 Sep 2020 20:43:07 +0300

> This patchset fixes some recent issues found by customers.
> 
> v3:
>   resending on Dmitry's behalf
> 
> v2:
>   correct hash in Fixes tag

Series applied, thank you.

 
