Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D0B15CDFC
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 23:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgBMWRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 17:17:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgBMWRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 17:17:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6E3315B770C4;
        Thu, 13 Feb 2020 14:17:23 -0800 (PST)
Date:   Thu, 13 Feb 2020 14:17:23 -0800 (PST)
Message-Id: <20200213.141723.1544210414606786043.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     amir@vadai.me, yotamg@mellanox.com, jiri@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] add missing validation of 'skip_hw/skip_sw'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1581444848.git.dcaratti@redhat.com>
References: <cover.1581444848.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2020 14:17:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 11 Feb 2020 19:33:38 +0100

> ensure that all classifiers currently supporting HW offload
> validate the 'flags' parameter provided by user:
> 
> - patch 1/2 fixes cls_matchall
> - patch 2/2 fixes cls_flower

Series applied and queued up for -stable, thanks.
