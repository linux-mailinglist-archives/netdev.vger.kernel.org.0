Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7561FC1EA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFPW4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:56:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgFPW4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 18:56:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlKVL-000suQ-3Z; Wed, 17 Jun 2020 00:56:31 +0200
Date:   Wed, 17 Jun 2020 00:56:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yunaixin03610@163.com
Cc:     netdev@vger.kernel.org, yunaixin <yunaixin@huawei.com>
Subject: Re: [PATCH 4/5] Huawei BMA: Adding Huawei BMA driver: cdev_veth_drv
Message-ID: <20200616225631.GB205574@lunn.ch>
References: <20200616020528.1389-1-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616020528.1389-1-yunaixin03610@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This cdev_veth_drv driver is one of the communication drivers used
> by BMA software. It depends on the host_edma_drv driver. It will
> create a char device once loaded, offering interfaces (open, close,
> read, write and poll) to BMA to send/receive RESTful messages
> between BMC software. When the message is longer than 1KB, it will
> be cut into packets of 1KB. The other side, BMC's cdev_veth driver,
> will assemble these packets back into original mesages.

Hi Yunaixin

Interfaces like this nearly always get a NACK.

Is the user space code using this API open source?

   Thanks
	Andrew

