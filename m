Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9415EB931
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfJaVrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:47:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbfJaVrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:47:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DD311500396F;
        Thu, 31 Oct 2019 14:47:06 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:47:05 -0700 (PDT)
Message-Id: <20191031.144705.1438444010840329715.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     linux-kernel@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] net: dsa: replace routing tables with
 a list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:47:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 30 Oct 2019 22:09:12 -0400

> This branch gets rid of the ds->rtable static arrays in favor of
> a single dst->rtable list. This allows us to move away from the
> DSA_MAX_SWITCHES limitation and simplify the switch fabric setup.
> 
> Changes in v2:
>   - fix the reverse christmas for David

Series applied, thanks Vivien.
