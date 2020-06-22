Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520C7203F10
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgFVSVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:21:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgFVSVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:21:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnR4B-001hdP-BH; Mon, 22 Jun 2020 20:21:11 +0200
Date:   Mon, 22 Jun 2020 20:21:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
Subject: Re: [PATCH 5/5] Huawei BMA: Adding Huawei BMA driver: host_kbox_drv
Message-ID: <20200622182111.GB405672@lunn.ch>
References: <20200622160311.1533-1-yunaixin03610@163.com>
 <20200622160311.1533-6-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622160311.1533-6-yunaixin03610@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:03:11AM +0800, yunaixin03610@163.com wrote:
> From: yunaixin <yunaixin03610@163.com>
> 

> The BMA software is a system management software offered by
> Huawei. It supports the status monitoring, performance monitoring,
> and event monitoring of various components, including server CPUs,
> memory, hard disks, NICs, IB cards, PCIe cards, RAID controller
> cards, and optical modules.
> 
> The host_kbox_drv driver serves the function of a black box. When a
> panic or mce event happen to the system, it will record the event
> time, system's status and system logs and send them to BMC before
> the OS shutdown. This driver depends on the host_edms_drv driver.

You never responded to my email, about moving this out of netdev.

I suggest you just drop this patch. I doubt it will ever got merged in
any form.

    Andrew
