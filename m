Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D30ACD22A
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfJFNpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:45:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfJFNpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:45:12 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A1C01428DA6B;
        Sun,  6 Oct 2019 06:45:11 -0700 (PDT)
Date:   Sun, 06 Oct 2019 15:45:10 +0200 (CEST)
Message-Id: <20191006.154510.1792195598411183621.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 00/10] net: genetlink: parse attrs for
 dumpit() callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191005180442.11788-1-jiri@resnulli.us>
References: <20191005180442.11788-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 06:45:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat,  5 Oct 2019 20:04:32 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> In generic netlink, parsing attributes for doit() callback is already
> implemented. They are available in info->attrs.
> 
> For dumpit() however, each user which is interested in attributes have to
> parse it manually. Even though the attributes may be (depending on flag)
> already validated (by parse function).
> 
> Make usage of attributes in dumpit() more convenient and prepare
> info->attrs too.
> 
> Patchset also make the existing users of genl_family_attrbuf() converted
> to use info->attrs and removes the helper.

I really like this transformation, series applied, thanks Jiri.
