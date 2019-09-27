Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D128C0B0F
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfI0S3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:29:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfI0S3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:29:51 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5AA0153EFC0A;
        Fri, 27 Sep 2019 11:29:50 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:29:49 +0200 (CEST)
Message-Id: <20190927.202949.1014916876082211694.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net-next v3 0/7] new PTP ioctl fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190926181109.4871-1-jacob.e.keller@intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:29:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Bug fixes should target 'net' not 'net-next'
