Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B1E2D580
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfE2G2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:28:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfE2G2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:28:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D43F1476D090;
        Tue, 28 May 2019 23:28:49 -0700 (PDT)
Date:   Tue, 28 May 2019 23:28:44 -0700 (PDT)
Message-Id: <20190528.232844.208799324710759685.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/10][pull request] 1GbE Intel Wired LAN Driver
 Updates 2019-05-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
References: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 23:28:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 28 May 2019 17:17:16 -0700

> This series contains updates to e1000e, igb and igc.

Pulled, thanks Jeff.
