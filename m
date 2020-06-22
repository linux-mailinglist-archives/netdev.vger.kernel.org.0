Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2756B203F14
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbgFVSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:22:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbgFVSWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:22:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnR5S-001heh-9G; Mon, 22 Jun 2020 20:22:30 +0200
Date:   Mon, 22 Jun 2020 20:22:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
Subject: Re: [PATCH 4/5] Huawei BMA: Adding Huawei BMA driver: cdev_veth_drv
Message-ID: <20200622182230.GC405672@lunn.ch>
References: <20200622160311.1533-1-yunaixin03610@163.com>
 <20200622160311.1533-5-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622160311.1533-5-yunaixin03610@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:03:10AM +0800, yunaixin03610@163.com wrote:
> From: yunaixin <yunaixin03610@163.com>
> 
> The BMA software is a system management software offered by Huawei. It supports the status monitoring, performance monitoring, and event monitoring of various components, including server CPUs, memory, hard disks, NICs, IB cards, PCIe cards, RAID controller cards, and optical modules.
> 
> This cdev_veth_drv driver is one of the communication drivers used by BMA software. It depends on the host_edma_drv driver. It will create a char device once loaded, offering interfaces (open, close, read, write and poll) to BMA to send/receive RESTful messages between BMC software. When the message is longer than 1KB, it will be cut into packets of 1KB. The other side, BMC's cdev_veth driver, will assemble these packets back into original mesages.

Again, you never replied to my questions. In general, a char dev
interface to 'firmware' is not allowed. So i suggest you drop this
patch.

	Andrew
