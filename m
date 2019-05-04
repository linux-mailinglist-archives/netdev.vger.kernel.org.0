Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035F713721
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfEDDdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:33:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDDdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:33:04 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB79B14D674F8;
        Fri,  3 May 2019 20:32:59 -0700 (PDT)
Date:   Fri, 03 May 2019 23:32:55 -0400 (EDT)
Message-Id: <20190503.233255.1664728862840773569.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/11][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-05-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 20:33:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri,  3 May 2019 16:09:28 -0700

> This series contains updates to the i40e driver only.

Pulled, thanks Jeff.
