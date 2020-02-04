Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D655151712
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgBDIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:30:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgBDIaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:30:22 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58D42155566EF;
        Tue,  4 Feb 2020 00:30:21 -0800 (PST)
Date:   Tue, 04 Feb 2020 09:30:19 +0100 (CET)
Message-Id: <20200204.093019.125174840126212089.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mrv@mojatatu.com, liuhangbin@gmail.com, jhs@mojatatu.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] unbreak 'basic' and 'bpf' tdc testcases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1580740848.git.dcaratti@redhat.com>
References: <cover.1580740848.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 00:30:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Mon,  3 Feb 2020 16:29:28 +0100

> - patch 1/2 fixes tdc failures with 'bpf' action on fresch clones of the
>   kernel tree
> - patch 2/2 allow running tdc for the 'basic' classifier without tweaking
>   tdc_config.py

Series applied, thanks Davide.
