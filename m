Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E16283F6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfEWQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:39:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfEWQj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:39:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E73631509CB0E;
        Thu, 23 May 2019 09:39:27 -0700 (PDT)
Date:   Thu, 23 May 2019 09:39:27 -0700 (PDT)
Message-Id: <20190523.093927.1439495378437759011.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: offload VLAN flows regardless of VLAN
 ethtype
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523151144.15587-1-rajur@chelsio.com>
References: <20190523151144.15587-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:39:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Thu, 23 May 2019 20:41:44 +0530

> VLAN flows never get offloaded unless ivlan_vld is set in filter spec.
> It's not compulsory for vlan_ethtype to be set.
> 
> So, always enable ivlan_vld bit for offloading VLAN flows regardless of
> vlan_ethtype is set or not.
> 
> Fixes: ad9af3e09c (cxgb4: add tc flower match support for vlan)
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied and queued up for -stable.
