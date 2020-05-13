Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A41D1EEF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390442AbgEMTVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:21:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4921C061A0C;
        Wed, 13 May 2020 12:21:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F111127E3293;
        Wed, 13 May 2020 12:21:42 -0700 (PDT)
Date:   Wed, 13 May 2020 12:21:41 -0700 (PDT)
Message-Id: <20200513.122141.1205756916957021603.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2020-05-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513081517.GA35645@isister-mobl.amr.corp.intel.com>
References: <20200513081517.GA35645@isister-mobl.amr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:21:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Wed, 13 May 2020 11:15:17 +0300

> Here's a second attempt at a bluetooth-next pull request which
> supercedes the one dated 2020-05-09. This should have the issues
> discovered by Jakub fixed.
> 
>  - Add support for Intel Typhoon Peak device (8087:0032)
>  - Add device tree bindings for Realtek RTL8723BS device
>  - Add device tree bindings for Qualcomm QCA9377 device
>  - Add support for experimental features configuration through mgmt
>  - Add driver hook to prevent wake from suspend
>  - Add support for waiting for L2CAP disconnection response
>  - Multiple fixes & cleanups to the btbcm driver
>  - Add support for LE scatternet topology for selected devices
>  - A few other smaller fixes & cleanups
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks Johan.
