Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C92BA0DFE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfH1XAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:00:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfH1XAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:00:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8601614522EEF;
        Wed, 28 Aug 2019 16:00:32 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:00:32 -0700 (PDT)
Message-Id: <20190828.160032.599086044004802986.davem@davemloft.net>
To:     benwei@fb.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next] net/ncsi: add response handlers for PLDM over
 NC-SI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CH2PR15MB3686302D8210855E5AB643B1A3A00@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB3686302D8210855E5AB643B1A3A00@CH2PR15MB3686.namprd15.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 16:00:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Wei <benwei@fb.com>
Date: Tue, 27 Aug 2019 23:03:53 +0000

> This patch adds handlers for PLDM over NC-SI command response.
> 
> This enables NC-SI driver recognizes the packet type so the responses don't get dropped as unknown packet type.
> 
> PLDM over NC-SI are not handled in kernel driver for now, but can be passed back to user space via Netlink for further handling.
> 
> Signed-off-by: Ben Wei <benwei@fb.com>

I don't know why but patchwork puts part of your patch into the commit message, see:

https://patchwork.ozlabs.org/patch/1154104/

It's probably an encoding issue or similar.

> +static int ncsi_rsp_handler_pldm(struct ncsi_request *nr) {
> +	return 0;
> +}
> +
>  static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)  {

I know other functions in this file do it, but please put the openning
curly braces of a function on a separate line.

Thank you.
