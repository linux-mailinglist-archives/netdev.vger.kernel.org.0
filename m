Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A75F5A70
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKHVy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:54:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKHVy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:54:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6C9F153B3E78;
        Fri,  8 Nov 2019 13:54:58 -0800 (PST)
Date:   Fri, 08 Nov 2019 13:54:58 -0800 (PST)
Message-Id: <20191108.135458.1093189297538153167.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] 100GbE Intel Wired LAN
 Driver Updates 2019-11-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 13:54:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri,  8 Nov 2019 12:37:51 -0800

> Another series that contains updates to the ice driver only.

Pulled, thanks Jeff.
