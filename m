Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251E51CC4F0
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgEIWcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgEIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 18:32:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D05A320A8B;
        Sat,  9 May 2020 22:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589063521;
        bh=Fzp6MWZMRw0o3pSLYLuZA5ZlR2+DLc/UwB9a62QOE60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t3nb2z2Z3UqoBkXxXXYkiY2w1dbCFvafaCtku3m0k/ktP00bgfNRIBhyFoHTPq3Bi
         dOaga3mtYzXJaoYaCoyzAIEjwYlUhx8nCOD72BD3JG2zJFvQ3lereE5OdSj7Vh9ujc
         eXopC4FeoHeVkPp5CCMdazx+ArPg0MsLz8AjthqU=
Date:   Sat, 9 May 2020 15:31:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v2] hinic: add three net_device_ops of vf
Message-ID: <20200509153159.24e21d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508201850.5003-1-luobin9@huawei.com>
References: <20200508201850.5003-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 20:18:50 +0000 Luo bin wrote:
> adds ndo_set_vf_rate/ndo_set_vf_spoofchk/ndo_set_vf_link_state
> to configure netdev of virtual function
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied, thank you. Please make sure you fix the time on your system,
this patch arrived with a date set few hours in the past.
