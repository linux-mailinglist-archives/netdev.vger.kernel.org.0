Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2A2E9425
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfJ3Aix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:38:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ3Aiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:38:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46A5013E812FB;
        Tue, 29 Oct 2019 17:38:52 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:38:51 -0700 (PDT)
Message-Id: <20191029.173851.1382000552603122409.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, jarod@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] Documentation: net-sysfs: describe missing
 statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028160800.69707-1-jwi@linux.ibm.com>
References: <20191028160800.69707-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:38:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon, 28 Oct 2019 17:08:00 +0100

> Sync the ABI description with the interface statistics that are currently
> available through sysfs.
> 
> CC: Jarod Wilson <jarod@redhat.com>
> CC: Jonathan Corbet <corbet@lwn.net>
> CC: linux-doc@vger.kernel.org
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied, thank you.
