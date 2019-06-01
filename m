Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170DC31888
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFAACk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:02:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfFAACk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:02:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98AAD1503DC10;
        Fri, 31 May 2019 17:02:39 -0700 (PDT)
Date:   Fri, 31 May 2019 17:02:38 -0700 (PDT)
Message-Id: <20190531.170238.2103466000677539047.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/13][pull request] Intel Wired LAN Driver Updates
 2019-05-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 17:02:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 31 May 2019 01:15:05 -0700

> This series contains updates to the iavf driver.

Pulled, thanks Jeff.

I do agree with Joe that the debug logging macro can be improved.
Please take a look at his feedback.

Thanks.
