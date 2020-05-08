Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3191CB9F0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgEHVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgEHVgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 17:36:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 604C12051A;
        Fri,  8 May 2020 21:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588973772;
        bh=K5R9WT/9E/N7mkbhsm6BFk5bbnSyq6jNBK74D+vDTHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ot9kgaai/yY4qvM3le5pw9nnNB2U+J6+4fjKa+eGE8dsRhIDVCHHNiMpm5RqaEjqP
         74Ct77lwNuDnrGgvZD45RsNtONzSB1K0oDFN9XNjeajyGbXFC81EwFqoEX36vqiCzP
         qRWoMNY+DA2ndQVeP7UVpDbtgMZfxXOx6gzkGkuQ=
Date:   Fri, 8 May 2020 14:36:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v1] hinic: add three net_device_ops of vf
Message-ID: <20200508143606.65767cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507182119.20494-1-luobin9@huawei.com>
References: <20200507182119.20494-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 18:21:19 +0000 Luo bin wrote:
> +	return hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
> +				 HINIC_COMM_CMD_HWCTXT_SET,
> +				 &hw_ioctxt, sizeof(hw_ioctxt), NULL,
> +				 NULL, HINIC_MGMT_MSG_SYNC);
> +
> +	return 0;

Oh, well, I think there will be a v2 :)
