Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64AD5C0ADD
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfI0SM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:12:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfI0SM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:12:57 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 648AA153E82D5;
        Fri, 27 Sep 2019 11:12:55 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:12:54 +0200 (CEST)
Message-Id: <20190927.201254.1845107055780234974.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        jakub.kicinski@netronome.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com,
        frederik.lotter@netronome.com, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: fix memory leak in
 nfp_flower_spawn_vnic_reprs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925190512.3404-1-navid.emamdoost@gmail.com>
References: <20190925190512.3404-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:12:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Wed, 25 Sep 2019 14:05:09 -0500

> In nfp_flower_spawn_vnic_reprs in the loop if initialization or the
> allocations fail memory is leaked. Appropriate releases are added.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied.
