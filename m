Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB243EE861
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 10:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbhHQIYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 04:24:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:40914 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239197AbhHQIYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 04:24:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="212902184"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="212902184"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 01:23:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="505214296"
Received: from mylly.fi.intel.com (HELO [10.237.72.203]) ([10.237.72.203])
  by orsmga001.jf.intel.com with ESMTP; 17 Aug 2021 01:23:40 -0700
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: Re: Regression with commit e532a096be0e ("net: usb: asix: ax88772:
 add phylib support")
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
 <20210816081314.3b251d2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210816161822.td7jl4tv7zfbprty@pengutronix.de>
Message-ID: <e575a7a9-2645-9ebc-fdea-f0421ecaf0e2@linux.intel.com>
Date:   Tue, 17 Aug 2021 11:23:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210816161822.td7jl4tv7zfbprty@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 8/16/21 7:18 PM, Oleksij Rempel wrote:
>>> v5.13 works ok. v5.14-rc1 and today's head 761c6d7ec820 ("Merge tag
>>> 'arc-5.14-rc6' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc") show the
>>> regression.
>>>
>>> I bisected regression into e532a096be0e ("net: usb: asix: ax88772: add
>>> phylib support").
>>
> It sounds like issue which was fixed with the patch:
> "net: usb: asix: ax88772: suspend PHY on driver probe"
> 
> This patch was taken in to v5.14-rc2. Can you please test it?
> 
Unfortunately it does not fix and was included in last week head 
761c6d7ec820. I tested now also linux-next tag next-20210816 and the 
issue remains.

Jarkko
