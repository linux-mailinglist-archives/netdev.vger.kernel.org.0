Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580617C684
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfGaP1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:27:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:27:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C126F12715521;
        Wed, 31 Jul 2019 08:27:13 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:27:13 -0700 (PDT)
Message-Id: <20190731.082713.1487402244615844174.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com, idosch@mellanox.com
Subject: Re: [PATCH net] drop_monitor: Add missing uAPI file to MAINTAINERS
 file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731063819.10001-1-idosch@idosch.org>
References: <20190731063819.10001-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:27:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 31 Jul 2019 09:38:19 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Fixes: 6e43650cee64 ("add maintainer for network drop monitor kernel service")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied.
