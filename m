Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4391149A8
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 00:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfLEXFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 18:05:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfLEXFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 18:05:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62B4F150BC2FE;
        Thu,  5 Dec 2019 15:05:46 -0800 (PST)
Date:   Thu, 05 Dec 2019 15:05:45 -0800 (PST)
Message-Id: <20191205.150545.1658349952591775835.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     klju@umn.edu, mostrows@earthlink.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pppoe: remove redundant BUG_ON() check in pppoe_pernet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205230342.8548-1-pakki001@umn.edu>
References: <20191205230342.8548-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 15:05:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Why are you sending this twice?
