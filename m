Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368A0A4635
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfHaUgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:36:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfHaUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:36:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8AB1136D763E;
        Sat, 31 Aug 2019 13:36:18 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:36:18 -0700 (PDT)
Message-Id: <20190831.133618.60802477215444924.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     Igor.Russkikh@aquantia.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] net: aquantia: fixes on vlan filters and other
 conditions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830232856.6200abd2@cakuba.netronome.com>
References: <cover.1567163402.git.igor.russkikh@aquantia.com>
        <20190830232856.6200abd2@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 13:36:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 30 Aug 2019 23:28:56 -0700

> On Fri, 30 Aug 2019 12:08:28 +0000, Igor Russkikh wrote:
>> Here is a set of various bug fixes related to vlan filter offload and
>> two other rare cases.
> 
> LGTM, Fixes tag should had been first there on patch 4.

Series applied with fixes tag ordering fixed in patch 4.
