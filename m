Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B71E937D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfJ2XU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:20:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJ2XUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:20:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1570214EBC324;
        Tue, 29 Oct 2019 16:20:55 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:20:54 -0700 (PDT)
Message-Id: <20191029.162054.1719938267738224650.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: i2400: Fix memory leak in
 i2400m_op_rfkill_sw_toggle
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191026045331.1097-1-navid.emamdoost@gmail.com>
References: <20191026045331.1097-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:20:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Fri, 25 Oct 2019 23:53:30 -0500

> In the implementation of i2400m_op_rfkill_sw_toggle() the allocated
> buffer for cmd should be released before returning. The
> documentation for i2400m_msg_to_dev() says when it returns the buffer
> can be reused. Meaning cmd should be released in either case. Move
> kfree(cmd) before return to be reached by all execution paths.
> 
> Fixes: 2507e6ab7a9a ("wimax: i2400: fix memory leak")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied.
