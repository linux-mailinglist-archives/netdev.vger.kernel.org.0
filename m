Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5651915CDE1
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 23:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgBMWK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 17:10:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgBMWK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 17:10:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DA9115B7533A;
        Thu, 13 Feb 2020 14:10:56 -0800 (PST)
Date:   Thu, 13 Feb 2020 14:10:53 -0800 (PST)
Message-Id: <20200213.141053.2156534172580678528.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 00/15][pull request] Intel Wired LAN Driver Updates
 2020-02-12
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2020 14:10:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 12 Feb 2020 13:33:42 -0800

> This series contains fixes to only the ice driver.

Pulled, thanks Jeff.
