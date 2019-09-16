Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BDCB3574
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfIPHUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:20:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:20:47 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76ECD15163FB8;
        Mon, 16 Sep 2019 00:20:45 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:20:41 +0200 (CEST)
Message-Id: <20190916.092041.1169364114444204711.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jbenc@redhat.com, tgraf@suug.ch,
        u9012063@gmail.com
Subject: Re: [PATCH net-next 0/6] net: add support for ip_tun_info options
 setting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:20:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 16 Sep 2019 15:10:14 +0800

> With this patchset, users can configure options with LWTUNNEL_IP(6)_OPTS
> by ip route encap for ersapn or vxlan lwtunnel. Note that in kernel part
> it won't parse the option details but do some check and memcpy only, and
> the options will be parsed by iproute in userspace.

Sorry, this will have to wait until net-next opens back up.

Thank you.
