Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CDD166658
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBTSbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:31:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgBTSbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:31:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE3FB15AD78EE;
        Thu, 20 Feb 2020 10:31:34 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:31:34 -0800 (PST)
Message-Id: <20200220.103134.65963913215957539.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2020-02-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220145456.11571-1-jwi@linux.ibm.com>
References: <20200220145456.11571-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 10:31:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 20 Feb 2020 15:54:53 +0100

> please apply the following patch series for qeth to netdev's net tree.
> 
> This corrects three minor issues:
> 1) return a more fitting errno when VNICC cmds are not supported,
> 2) remove a bogus WARN in the NAPI code, and
> 3) be _very_ pedantic about the RX copybreak.

Series applied, thanks.
