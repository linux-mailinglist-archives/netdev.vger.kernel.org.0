Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA810425
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfEADQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:16:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfEADQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:16:24 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A450E136DFB83;
        Tue, 30 Apr 2019 20:16:23 -0700 (PDT)
Date:   Tue, 30 Apr 2019 23:16:22 -0400 (EDT)
Message-Id: <20190430.231622.754911974508203277.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/4] Convert mv88e6060 to mdio device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190428005624.21550-1-andrew@lunn.ch>
References: <20190428005624.21550-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 20:16:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 28 Apr 2019 02:56:20 +0200

> This patchset builds upon the previous patches to mv88e6060. It adds
> support for probing the switch as an MDIO device and then removes the
> legacy probe method. Since this is the last device supporting legacy
> probe, this allows legacy probe to be removed, originally planned to
> be removed in 4.17, but took a bit longer.
> 
> This change to the mv88e6060 is more risky than the previous
> patchset. Some attempts to test it have been made, by hacking the
> driver to match on an mv88e6352 so that it probes. These changes are
> all about probe, so it is a reasonable test. But testing on a real
> mv88e6060 would be great.

Series applied, thanks Andrew.
