Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5963FB0F4
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 07:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhH3FyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 01:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhH3FyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 01:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5AD60F4B;
        Mon, 30 Aug 2021 05:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630302800;
        bh=ulQEWLwWaUk2Ht3cUAnH16w3liGoE6Hvs4iXfS1QVzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Up35zxoQ0UHkVvSRxBDt7+eIzMRvjx9ZHJFihzDjgoNBgZILm9BX3lJvpBQ4343sm
         x4R55Fp/do9sLCmJKN04sbVjaMZ6rbM/vZE5ZKpC5mTHVlrAVwhGNb18v4Vyygd2bU
         L/28rDzh/LunM6cEmwYGgS16oaNXDGnuJLttNzpA=
Date:   Mon, 30 Aug 2021 07:53:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3] net: usb: pegasus: fixes of set_register(s) return
 value evaluation;
Message-ID: <YSxySm5LtRkt6ytA@kroah.com>
References: <20210829203403.10167-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829203403.10167-1-petko.manolov@konsulko.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 11:34:02PM +0300, Petko Manolov wrote:
>   - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
>     Kicinski;
>   - hurried up and removed redundant assignment in pegasus_open() before yet
>     another checker complains;

THat is two different things, why not just do one thing per patch?

> 
>   v3:
>      Added CC: stable@vger.kernel.org in a vague hope this time it'll go in;

This goes below the --- line, as the documentation states.

thanks,

greg k-h
