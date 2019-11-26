Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8C10A6FA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKZXOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:14:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKZXOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:14:23 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37A0514DB4EAC;
        Tue, 26 Nov 2019 15:14:23 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:14:17 -0800 (PST)
Message-Id: <20191126.151417.221231165879328487.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, joestringer@nicira.com, pshelar@ovn.org
Subject: Re: [PATCH net] openvswitch: fix flow command message size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7df4df3b89d405b3f01b6e637a52321bf36d37d4.1574769169.git.pabeni@redhat.com>
References: <7df4df3b89d405b3f01b6e637a52321bf36d37d4.1574769169.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 15:14:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 26 Nov 2019 12:55:50 +0100

> When user-space sets the OVS_UFID_F_OMIT_* flags, and the relevant
> flow has no UFID, we can exceed the computed size, as
> ovs_nla_put_identifier() will always dump an OVS_FLOW_ATTR_KEY
> attribute.
> Take the above in account when computing the flow command message
> size.
> 
> Reported-by: Qi Jun Ding <qding@redhat.com>
> Fixes: 74ed7ab9264c ("openvswitch: Add support for unique flow IDs.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thanks.
