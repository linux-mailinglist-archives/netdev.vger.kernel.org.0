Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28913203F02
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgFVSSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:18:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbgFVSSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:18:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnR1j-001hb4-4X; Mon, 22 Jun 2020 20:18:39 +0200
Date:   Mon, 22 Jun 2020 20:18:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
Subject: Re: [PATCH 0/5] Adding Huawei BMA drivers
Message-ID: <20200622181839.GA405672@lunn.ch>
References: <20200622160311.1533-1-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622160311.1533-1-yunaixin03610@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:03:06AM +0800, yunaixin03610@163.com wrote:
> From: yunaixin <yunaixin03610@163.com>
> 
> This patch set contains 5 communication drivers for Huawei BMA software.
> The BMA software is a system management software. It supports the status
> monitoring, performance monitoring, and event monitoring of various
> components, including server CPUs, memory, hard disks, NICs, IB cards,
> PCIe cards, RAID controller cards, and optical modules.
> 
> These 5 drivers are used to send/receive message through PCIe channel in
> different ways by BMA software.

This is v2 right? Please put v2 into the subject.

Also, you need to list what changes you have made since v1.

Thanks
      Andrew
