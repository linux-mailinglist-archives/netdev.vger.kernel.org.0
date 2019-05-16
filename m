Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7414B20FFB
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfEPVZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:25:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfEPVZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:25:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AAC412D6C858;
        Thu, 16 May 2019 14:25:32 -0700 (PDT)
Date:   Thu, 16 May 2019 14:25:31 -0700 (PDT)
Message-Id: <20190516.142531.1745765236415091869.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org, oneukum@suse.com,
        Dmitry.Bezrukov@aquantia.com
Subject: Re: [PATCH net 0/3] aqc111: revert endianess fixes and cleanup mtu
 logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1558017386.git.igor.russkikh@aquantia.com>
References: <cover.1558017386.git.igor.russkikh@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 14:25:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Thu, 16 May 2019 14:52:18 +0000

> This reverts no-op commits as it was discussed:
> 
> https://lore.kernel.org/netdev/1557839644.11261.4.camel@suse.com/
> 
> First and second original patches are already dropped from stable,
> No need to stable-queue the third patch as it has no functional impact,
> just a logic cleanup.

Series applied, thank you.
