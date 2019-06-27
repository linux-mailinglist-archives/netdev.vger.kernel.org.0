Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CA75895E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfF0R6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:58:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfF0R6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:58:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9BEF12D8E1E9;
        Thu, 27 Jun 2019 10:58:54 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:58:54 -0700 (PDT)
Message-Id: <20190627.105854.544510812072746208.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 10:58:54 -0700 (PDT)
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

Series applied, thank you.
