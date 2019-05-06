Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5E1441E
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfEFEil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:38:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfEFEil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:38:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C39FE12D6C873;
        Sun,  5 May 2019 21:38:40 -0700 (PDT)
Date:   Sun, 05 May 2019 21:38:40 -0700 (PDT)
Message-Id: <20190505.213840.134401337700718153.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/12][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-05-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
References: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:38:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sat,  4 May 2019 18:13:57 -0700

> This series contains updates to i40e only.

Pulled, thanks Jeff.
