Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9867AE4CE
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391030AbfIJHpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:45:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfIJHpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 03:45:24 -0400
Received: from localhost (unknown [88.214.187.83])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2AF2154A52AB;
        Tue, 10 Sep 2019 00:45:22 -0700 (PDT)
Date:   Tue, 10 Sep 2019 09:45:19 +0200 (CEST)
Message-Id: <20190910.094519.58105218387331453.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] Intel Wired LAN Driver
 Updates 2019-09-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
References: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 00:45:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon,  9 Sep 2019 15:47:47 -0700

> This series contains a variety of cold and hot savoury changes to Intel
> drivers.  Some of the fixes could be considered for stable even though
> the author did not request it.
 ...

Pulled.
