Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D75446DE5
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFOCtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:49:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfFOCtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:49:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6643D12D69F75;
        Fri, 14 Jun 2019 19:49:13 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:49:12 -0700 (PDT)
Message-Id: <20190614.194912.1623906433848870868.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/3] nfp: flower: loosen L4 checks and add
 extack to flower offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613211711.5505-1-jakub.kicinski@netronome.com>
References: <20190613211711.5505-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:49:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 13 Jun 2019 14:17:08 -0700

> Pieter says:
> 
> This set allows the offload of filters that make use of an unknown
> ip protocol, given that layer 4 is being wildcarded. The set then
> aims to make use of extack messaging for flower offloads. It adds
> about 70 extack messages to the driver.

Series applied.
