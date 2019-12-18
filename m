Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B658123FFF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLRHEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:04:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47698 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRHEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:04:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63A0615039441;
        Tue, 17 Dec 2019 23:04:01 -0800 (PST)
Date:   Tue, 17 Dec 2019 23:04:01 -0800 (PST)
Message-Id: <20191217.230401.1145786498004179773.davem@davemloft.net>
To:     pdurrant@amazon.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH net-next 3/3] xen-netback: remove 'hotplug-status' once
 it has served its purpose
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217133218.27085-4-pdurrant@amazon.com>
References: <20191217133218.27085-1-pdurrant@amazon.com>
        <20191217133218.27085-4-pdurrant@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 23:04:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>
Date: Tue, 17 Dec 2019 13:32:18 +0000

> Removing the 'hotplug-status' node in netback_remove() is wrong; the script
> may not have completed. Only remove the node once the watch has fired and
> has been unregistered.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

Applied.
