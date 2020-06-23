Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492A2066D1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388619AbgFWWCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387860AbgFWWCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 18:02:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA472078E;
        Tue, 23 Jun 2020 22:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592949754;
        bh=7eJfE0siEUKsnDRAW9ZV6NcOIY7onZdbsXkDRT2g9WA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P/6PjQSyv9vn9AD1Fm2m0GZB4FpQ5zu9rjETDTUjAjl5VrclzYcSeCQ2TVVnl42QA
         iaPa92PSv7oO+gPi7wtSo314vcJtq1wrGWmMwxPEOzsDby0oumampZCn50ijrbkG6M
         4nFuuW4sxdO/Fs6Z7Ze9b5njU5p9YcbtWiveN+KA=
Date:   Tue, 23 Jun 2020 15:02:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v2 5/5] hinic: add support to get eeprom
 information
Message-ID: <20200623150233.440583b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623142409.19081-6-luobin9@huawei.com>
References: <20200623142409.19081-1-luobin9@huawei.com>
        <20200623142409.19081-6-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 22:24:09 +0800 Luo bin wrote:
> +int hinic_get_sfp_eeprom(struct hinic_hwdev *hwdev, u8 *data, u16 *len)
> +{
> +	struct hinic_cmd_get_std_sfp_info sfp_info = {0};
> +	u16 out_size = sizeof(sfp_info);
> +	u8 port_id;
> +	int err;
> +
> +	if (!hwdev || !data || !len)
> +		return -EINVAL;

> +int hinic_get_sfp_type(struct hinic_hwdev *hwdev, u8 *data0, u8 *data1)
> +{
> +	u8 sfp_data[STD_SFP_INFO_MAX_SIZE];
> +	u16 len;
> +	int err;
> +
> +	if (!hwdev || !data0 || !data1)
> +		return -EINVAL;

No need to check these, callers are correct. We don't do defensive
programming in the kernel.

> +	return  0;

double space
