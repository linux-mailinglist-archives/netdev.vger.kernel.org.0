Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF720EA5B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgF3AiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgF3AiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:38:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391F4C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:38:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C23A8127C1BB3;
        Mon, 29 Jun 2020 17:38:12 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:38:12 -0700 (PDT)
Message-Id: <20200629.173812.1532344417590172093.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/15] sfc: prerequisites for EF100 driver,
 part 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629173055.5b110949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
        <20200629173055.5b110949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:38:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 29 Jun 2020 17:30:55 -0700

> On Mon, 29 Jun 2020 14:30:32 +0100 Edward Cree wrote:
>> This continues the work started by Alex Maftei <amaftei@solarflare.com>
>>  in the series "sfc: code refactoring", "sfc: more code refactoring",
>>  "sfc: even more code refactoring" and "sfc: refactor mcdi filtering
>>  code", to prepare for a new driver which will share much of the code
>>  to support the new EF100 family of Solarflare/Xilinx NICs.
>> After this series, there will be approximately two more of these
>>  'prerequisites' series, followed by the sfc_ef100 driver itself.
> 
> I didn't spot anything questionable, so:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
