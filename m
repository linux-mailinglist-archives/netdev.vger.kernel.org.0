Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C84EE5EA8
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfJZS26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:28:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfJZS26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:28:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8000D14DE97F1;
        Sat, 26 Oct 2019 11:28:57 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:28:56 -0700 (PDT)
Message-Id: <20191026.112856.2093592407050461242.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: aquantia: ptp followup fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1572083797.git.igor.russkikh@aquantia.com>
References: <cover.1572083797.git.igor.russkikh@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 11:28:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Sat, 26 Oct 2019 11:05:30 +0000

> Here are two sparse warnings, third patch is a fix for
> scaled_ppm_to_ppb missing. Eventually I reworked this
> to exclude ptp module from build. Please consider it instead
> of this patch: https://patchwork.ozlabs.org/patch/1184171/

Series applied, thanks Igor.
