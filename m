Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AC456EAA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFZQ0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:26:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37426 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQ0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:26:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71F4F14B2A334;
        Wed, 26 Jun 2019 09:26:34 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:26:33 -0700 (PDT)
Message-Id: <20190626.092633.1591590459843934791.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/8] net: aquantia: implement vlan offloads
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1561552290.git.igor.russkikh@aquantia.com>
References: <cover.1561552290.git.igor.russkikh@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:26:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Wed, 26 Jun 2019 12:35:30 +0000

> This patchset introduces hardware VLAN offload support and also does some
> maintenance: we replace driver version with uts version string, add
> documentation file for atlantic driver, and update maintainers
> adding Igor as a maintainer.
> 
> v3: shuffle doc sections, per Andrew's comments
> 
> v2: updates in doc, gpl spdx tag cleanup

This looks good to me, I'll let Andrew et al. have one last chance at re-review.
