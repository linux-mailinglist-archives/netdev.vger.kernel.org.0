Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B126ECA8A
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKAVwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:52:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46650 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAVwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 17:52:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 714BA151AD4C3;
        Fri,  1 Nov 2019 14:52:48 -0700 (PDT)
Date:   Fri, 01 Nov 2019 14:52:45 -0700 (PDT)
Message-Id: <20191101.145245.320354888058358595.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net v2 0/7][pull request] Intel Wired LAN Driver Updates
 2019-11-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101202538.665-1-jeffrey.t.kirsher@intel.com>
References: <20191101202538.665-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 14:52:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri,  1 Nov 2019 13:25:31 -0700

> This series contains updates to e1000, igb, igc, ixgbe, i40e and driver
> documentation.

Pulled, thank Jeff.
