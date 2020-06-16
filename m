Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C881FC221
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFPXL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:11:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42758 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgFPXL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 19:11:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlKji-000t1A-NT; Wed, 17 Jun 2020 01:11:22 +0200
Date:   Wed, 17 Jun 2020 01:11:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, yunaixin <yunaixin@huawei.com>
Subject: Re: [PATCH 5/5] Huawei BMA: Adding Huawei BMA driver: host_kbox_drv
Message-ID: <20200616231122.GC205574@lunn.ch>
References: <20200616020554.1443-1-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616020554.1443-1-yunaixin03610@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The host_kbox_drv driver serves the function of a black box. When a
> panic or mce event happen to the system, it will record the event
> time, system's status and system logs and send them to BMC before
> the OS shutdown. This driver depends on the host_edms_drv driver.

This does not belong in net, or a network driver.

It is also very difficult to do anything with a panicing kernel. Which
is what kexec on panic is all about. Get into a fresh kernel, and use
that kernel to dump the status of the crashed kernel.

So i doubt you will find a home anywhere in the kernel for any of this
code.

	Andrew
