Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9C51CE591
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbgEKUcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729517AbgEKUcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:32:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CE9C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:32:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09BE111D698A3;
        Mon, 11 May 2020 13:32:09 -0700 (PDT)
Date:   Mon, 11 May 2020 13:32:09 -0700 (PDT)
Message-Id: <20200511.133209.1693822192358543471.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] sfc: remove nic_data usage in common code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:32:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Mon, 11 May 2020 13:23:55 +0100

> efx->nic_data should only be used from NIC-specific code (i.e. nic_type
>  functions and things they call), in files like ef10[_sriov].c and
>  siena.c.  This series refactors several nic_data usages from common
>  code (mainly in mcdi_filters.c) into nic_type functions, in preparation
>  for the upcoming ef100 driver which will use those functions but have
>  its own struct layout for efx->nic_data distinct from ef10's.
> After this series, one nic_data usage (in ptp.c) remains; it wasn't
>  clear to me how to fix it, and ef100 devices don't yet have PTP support
>  (so the initial ef100 driver will not call that code).

Series applied, thanks.
