Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AAE12DDF2
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 06:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgAAFnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 00:43:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgAAFnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 00:43:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7993A154ECAB1;
        Tue, 31 Dec 2019 21:43:48 -0800 (PST)
Date:   Tue, 31 Dec 2019 21:43:45 -0800 (PST)
Message-Id: <20191231.214345.2216989512800564273.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/11][pull request] 1GbE Intel Wired LAN Driver
 Updates 2019-12-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
References: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Dec 2019 21:43:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 31 Dec 2019 14:27:39 -0800

> This series contains updates to e1000e, igb and igc only.
 ...

Pulled, thanks Jeff.
