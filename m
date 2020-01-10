Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5D136583
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbgAJCqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:46:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730944AbgAJCqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:46:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F5651573FF1E;
        Thu,  9 Jan 2020 18:46:42 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:46:41 -0800 (PST)
Message-Id: <20200109.184641.1937829853627214544.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/7][pull request] Intel Wired LAN Driver Updates
 2020-01-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
References: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:46:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu,  9 Jan 2020 09:47:06 -0800

> This series contains fixes to e1000e, igb, ixgbe, ixgbevf, i40e and iavf
> drivers.

Pulled, thanks Jeff.
