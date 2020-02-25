Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEBE16EE93
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbgBYTG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:06:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgBYTGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:06:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED9BB13B48C26;
        Tue, 25 Feb 2020 11:06:24 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:06:24 -0800 (PST)
Message-Id: <20200225.110624.115432289669607520.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 00/10] mlxsw: Implement ACL-dropped packets
 identification
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 11:06:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 25 Feb 2020 11:45:17 +0100

> mlxsw hardware allows to insert a ACL-drop action with a value defined
> by user that would be later on passed with a dropped packet.
> 
> To implement this, use the existing TC action cookie and pass it to the
> driver. As the cookie format coming down from TC and the mlxsw HW cookie
> format is different, do the mapping of these two using idr and rhashtable.
 ...

Series applied, thanks Jiri.
