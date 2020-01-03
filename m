Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9D012FDFA
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgACUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:34:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgACUeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:34:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7AE5A15845603;
        Fri,  3 Jan 2020 12:34:11 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:34:11 -0800 (PST)
Message-Id: <20200103.123411.2031888816087832091.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, konstantin@linuxfoundation.org,
        jakub.kicinski@netronome.com
Subject: Re: [net-next PATCH] doc/net: Update git https URLs in netdev-FAQ
 documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157805498247.1556791.15507479174775505447.stgit@carbon>
References: <157805498247.1556791.15507479174775505447.stgit@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:34:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 03 Jan 2020 13:36:22 +0100

> DaveM's git tree have been moved into a named subdir 'netdev' to deal with
> allowing Jakub Kicinski to help co-maintain the trees.
> 
> Link: https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied to 'net', thanks for catching this.
