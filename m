Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE68F1B312D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 22:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgDUU2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 16:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgDUU2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 16:28:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A7AC0610D5;
        Tue, 21 Apr 2020 13:28:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C12AF128D4B46;
        Tue, 21 Apr 2020 13:28:09 -0700 (PDT)
Date:   Tue, 21 Apr 2020 13:28:08 -0700 (PDT)
Message-Id: <20200421.132808.1673635156407152563.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, andy@greyhouse.net,
        bp@suse.de, ionut@badula.org, j.vosburgh@gmail.com,
        jeyu@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        salil.mehta@huawei.com, sre@kernel.org, snelson@pensando.io,
        vfalico@gmail.com, yisen.zhuang@huawei.com
Subject: Re: [PATCH net-next v2 0/4] Remove vermagic header from global
 include folder
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419141850.126507-1-leon@kernel.org>
References: <20200419141850.126507-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 13:28:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Sun, 19 Apr 2020 17:18:46 +0300

> This is followup to the failure reported by Borislav [1] and suggested
> fix later on [2].
> 
> The series removes all includes of linux/vermagic.h, updates hns and
> nfp to use same kernel versioning scheme (exactly like we did for
> other drivers in previous cycle) and removes vermagic.h from global
> include folder.
> 
> [1] https://lore.kernel.org/lkml/20200411155623.GA22175@zn.tnic
> [2] https://lore.kernel.org/lkml/20200413080452.GA3772@zn.tnic

Series applied to net-next, thanks.
