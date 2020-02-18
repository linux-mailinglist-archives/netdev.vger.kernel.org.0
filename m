Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD8F16309E
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgBRTuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:50:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:50:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77D13121793C3;
        Tue, 18 Feb 2020 11:50:17 -0800 (PST)
Date:   Tue, 18 Feb 2020 11:50:14 -0800 (PST)
Message-Id: <20200218.115014.2022578847900470441.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        michal.simek@xilinx.com, ynezz@true.cz
Subject: Re: [PATCH 0/8] net: ll_temac: Bugfixes and ethtool support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218082607.7035-1-esben@geanix.com>
References: <20200218082607.7035-1-esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 11:50:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Several errors in this submission:

1) Do not mix bug fixes and new features.  Submit the bug fixes
   targetting 'net', and then wait for net to be merged into
   net-next at which time you can submit the new features on
   top.

2) As per Documentation/networking/netdev-FAQ.rst you should not
   ever CC: stable for networking patches, we submit bug fixes to
   stable ourselves.

Thank you.
