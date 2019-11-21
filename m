Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B085105A90
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKUTqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:46:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKUTqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:46:39 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12B7B15043D31;
        Thu, 21 Nov 2019 11:46:39 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:46:38 -0800 (PST)
Message-Id: <20191121.114638.2013379680595724494.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCHv2 net-next 0/4] net: sched: support vxlan and erspan
 options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:46:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 21 Nov 2019 18:03:25 +0800

> This patchset is to add vxlan and erspan options support in
> cls_flower and act_tunnel_key. The form is pretty much like
> geneve_opts in:
> 
>   https://patchwork.ozlabs.org/patch/935272/
>   https://patchwork.ozlabs.org/patch/954564/
> 
> but only one option is allowed for vxlan and erspan.
> 
> v1->v2:
>   - see each patch changelog.

Series applied.

