Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8635219CE01
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 02:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgDCA7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 20:59:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388961AbgDCA7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 20:59:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C21F12748FE6;
        Thu,  2 Apr 2020 17:59:31 -0700 (PDT)
Date:   Thu, 02 Apr 2020 17:59:30 -0700 (PDT)
Message-Id: <20200402.175930.1776120638916419969.davem@davemloft.net>
To:     petko.manolov@konsulko.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] pegasus.c: Remove pegasus' own workqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402143329.GC4089@carbon>
References: <20200402143329.GC4089@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 17:59:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petko.manolov@konsulko.com>
Date: Thu, 2 Apr 2020 17:33:29 +0300

> Remove pegasus' own workqueue and replace it with system_long_wq.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

Applied, thank you.
