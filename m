Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA396DFE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfHUAC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:02:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53192 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfHUAC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 20:02:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E758C14DB531D;
        Tue, 20 Aug 2019 17:02:57 -0700 (PDT)
Date:   Tue, 20 Aug 2019 17:02:57 -0700 (PDT)
Message-Id: <20190820.170257.2068135181099832696.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v3 00/14][pull request] 100GbE Intel Wired LAN
 Driver Updates 2019-08-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 17:02:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 20 Aug 2019 14:50:34 -0700

> This series contains updates to ice driver only.

Pulled, thanks Jeff.
