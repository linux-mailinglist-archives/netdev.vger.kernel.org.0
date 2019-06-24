Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDAF50F91
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfFXPEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:04:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfFXPEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:04:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B58C31504341B;
        Mon, 24 Jun 2019 08:04:01 -0700 (PDT)
Date:   Mon, 24 Jun 2019 08:04:01 -0700 (PDT)
Message-Id: <20190624.080401.605091064881218530.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     jakub.kicinski@netronome.com, andrew@lunn.ch,
        netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/7] net: aquantia: replace internal driver
 version code with uts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <120088f1-c860-a643-c675-fdeed4faf1ef@aquantia.com>
References: <20190622150514.GB8497@lunn.ch>
        <20190623204954.3aa09ded@cakuba>
        <120088f1-c860-a643-c675-fdeed4faf1ef@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 08:04:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Mon, 24 Jun 2019 11:02:54 +0000

> 
>> 
>>> Devlink has just gained something similar to ethtool -i. Maybe we
>>> should get the devlink core to also report the kernel version?
>> 
>> I don't think we have the driver version at all there, my usual
>> inclination being to not duplicate information across APIs.  Do we 
>> have non-hypothetical instances of users reporting ethtool -i without
>> uname output?  Admittedly I may work with above-average Linux-trained
>> engineers :S  Would it be okay to just get devlink user space to use
>> uname() to get the info?
> 
> I work alot with field support engineering people, they have a 'NIC-centric'
> view on a system and often assume NIC driver version is all that matters.
> 
> Therefore `ethtool -i` is often the only thing we get when debugging user issues.

This is an education issue, not one of what we should be doing in the
kernel.
