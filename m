Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A344B1653B0
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgBTAid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:38:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49708 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgBTAid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:38:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF08615BD7A60;
        Wed, 19 Feb 2020 16:38:32 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:38:31 -0800 (PST)
Message-Id: <20200219.163831.1329327787212130971.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/3][pull request] Intel Wired LAN Driver Updates
 2020-02-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219200251.370445-1-jeffrey.t.kirsher@intel.com>
References: <20200219200251.370445-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:38:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 19 Feb 2020 12:02:48 -0800

> This series contains fixes to the ice driver.

Pulled, thanks Jeff.
