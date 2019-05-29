Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26382E7AA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfE2VxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:53:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2VxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:53:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F413137160FC;
        Wed, 29 May 2019 14:53:08 -0700 (PDT)
Date:   Wed, 29 May 2019 14:53:07 -0700 (PDT)
Message-Id: <20190529.145307.86903185959229796.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-05-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 14:53:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 29 May 2019 11:47:39 -0700

> This series contains updates to ice driver only.

Pulled, thanks Jeff.
