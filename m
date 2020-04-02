Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24DA19C360
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgDBN6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:58:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47014 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgDBN6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:58:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9A4C128A034D;
        Thu,  2 Apr 2020 06:58:06 -0700 (PDT)
Date:   Thu, 02 Apr 2020 06:58:06 -0700 (PDT)
Message-Id: <20200402.065806.2056385842327013538.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv6: rpl_iptunnel: remove redundant assignments
 to variable err
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402101859.502158-1-colin.king@canonical.com>
References: <20200402101859.502158-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 06:58:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  2 Apr 2020 11:18:59 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being initialized with a value that is never
> read and it is being updated later with a new value.  The initialization
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
