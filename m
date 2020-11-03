Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEAE2A39F1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgKCBgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgKCBgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:36:23 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F2E6206CA;
        Tue,  3 Nov 2020 01:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604367382;
        bh=WybVzO3ynbZ+cIklhwKT7iEq7rg/FghTbJ1z3fbAWOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YMuEK/sshMfSA1dEqSUZwDWiCQbuiIvb9FkcVapeZceWdbzxZh+B1AMY73xPvco/R
         ICF6oK18cf7ITqaC/HwRokMMHLkgaG/bJLiaKCRnSfmSiWrwYK35Oc/+JEfV8PXlZm
         1PJUteP9qs5zAHipDtRJsA/iRVd29kiVV7ELBi+g=
Date:   Mon, 2 Nov 2020 17:36:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pshelar@ovn.org>, <davem@davemloft.net>,
        <xiangxia.m.yue@gmail.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] openvswitch: Use IS_ERR instead of
 IS_ERR_OR_NULL
Message-ID: <20201102173621.32e43f6a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031060153.39912-1-yuehaibing@huawei.com>
References: <20201031060153.39912-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 14:01:53 +0800 YueHaibing wrote:
> Fix smatch warning:
> 
> net/openvswitch/meter.c:427 ovs_meter_cmd_set() warn: passing zero to 'PTR_ERR'
> 
> dp_meter_create() never returns NULL, use IS_ERR
> instead of IS_ERR_OR_NULL to fix this.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!
