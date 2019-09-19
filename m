Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC6B74C2
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbfISILH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:11:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731341AbfISILG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:11:06 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D71C154EE362;
        Thu, 19 Sep 2019 01:11:03 -0700 (PDT)
Date:   Thu, 19 Sep 2019 10:10:59 +0200 (CEST)
Message-Id: <20190919.101059.1330167782179062709.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     navid.emamdoost@gmail.com, andrew@lunn.ch, emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: sja1105: prevent leaking memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com>
References: <20190918172106.GN9591@lunn.ch>
        <20190918180439.12441-1-navid.emamdoost@gmail.com>
        <8d6f6c54-1758-7d98-c9b5-5c16b171c885@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 01:11:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 18 Sep 2019 23:00:20 +0300

> Hi Navid,
> 
> Thanks for the patch.
> 
> On 9/18/19 9:04 PM, Navid Emamdoost wrote:
>> In sja1105_static_config_upload, in two cases memory is leaked: when
>> static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
>> fails. In both cases config_buf should be released.
>> Fixes: 8aa9ebccae876 (avoid leaking config_buf)
>> Fixes: 1a4c69406cc1c (avoid leaking config_buf)
>> 
> 
> You're not supposed to add a short description of the patch here, but
> rather the commit message of the patch you're fixing.
> Add this to your ~/.gitconfig:
> 
> [pretty]
> 	fixes = Fixes: %h (\"%s\")
> 
> And then run:
> git show --pretty=fixes 8aa9ebccae87621d997707e4f25e53fddd7e30e4
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105
> 5-port L2 switch")
> 
> git show --pretty=fixes 1a4c69406cc1c3c42bb7391c8eb544e93fe9b320
> 
> Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during
> switch reset")

However the Fixes: line should not be broken up like this with newlines.
