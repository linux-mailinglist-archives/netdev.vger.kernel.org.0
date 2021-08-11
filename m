Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85813E97D5
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhHKSoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:44:55 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:10263 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKSoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:44:54 -0400
Received: (qmail 87087 invoked by uid 89); 11 Aug 2021 18:44:27 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 11 Aug 2021 18:44:27 -0000
Date:   Wed, 11 Aug 2021 11:44:26 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, davem@davemloft.net
Subject: Re: [PATCH -next] ptp: ocp: Fix missing pci_disable_device() on
 error in ptp_ocp_probe()
Message-ID: <20210811184426.imoyh2wa3fjetiyc@bsd-mbp.dhcp.thefacebook.com>
References: <20210810125453.2182835-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810125453.2182835-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 08:54:53PM +0800, Yang Yingliang wrote:
> If ptp_ocp_device_init() fails, pci_disable_device() need be
> called, fix this by using pcim_enable_device().

I just posted an alternate patch to address this.
-- 
Jonathan
