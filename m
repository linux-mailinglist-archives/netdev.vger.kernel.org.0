Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFA2336B0
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgG3QZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgG3QZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 12:25:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDBE52082E;
        Thu, 30 Jul 2020 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596126304;
        bh=O5aeCbvn0jroZ3OR53wOp+tsTnlc+pBO02UpSEBopQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2NJNvsRFI5Na26wlxWqI9ZjI/srRJS8XAs/MWYMW9HVePHjvs7dHZtt1wu0VTnf1A
         PYydf19me56ggFLc0yb4kiqqeDXu07rBZXY2LbABRSZ7Z+fHRWvuptIQ5hIK+Pdj7A
         uXEuI3dvk4/yh1xcMXUxDd+AWiXcRcEaceb2mVf8=
Date:   Thu, 30 Jul 2020 09:25:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v1 1/2] hinic: add generating mailbox random
 index support
Message-ID: <20200730092502.4582ac4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730083716.4613-2-luobin9@huawei.com>
References: <20200730083716.4613-1-luobin9@huawei.com>
        <20200730083716.4613-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 16:37:15 +0800 Luo bin wrote:
> +bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_fun=
c,
> +			     u8 *header)

This set seems to add new W=3D1 C=3D1 warnings:

drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:572:6: warning: no previo=
us prototype for =E2=80=98check_vf_mbox_random_id=E2=80=99 [-Wmissing-proto=
types]
  572 | bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_t=
o_func,
      |      ^~~~~~~~~~~~~~~~~~~~~~~

drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:1352:28: warning: symbol =
'hw_cmd_support_vf' was not declared. Should it be static?
