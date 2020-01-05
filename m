Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3DF130541
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 02:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAEBCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 20:02:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgAEBCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 20:02:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DF47156E97FC;
        Sat,  4 Jan 2020 17:02:36 -0800 (PST)
Date:   Sat, 04 Jan 2020 17:02:33 -0800 (PST)
Message-Id: <20200104.170233.1621585275877414562.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/16][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-01-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jan 2020 17:02:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri,  3 Jan 2020 18:49:37 -0800

> This series contains updates to the ice driver only.

Pulled, thanks Jeff.
