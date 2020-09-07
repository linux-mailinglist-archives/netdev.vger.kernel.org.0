Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17401260543
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgIGTtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgIGTtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 15:49:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F5B2177B;
        Mon,  7 Sep 2020 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599508193;
        bh=y4+KPMofQ5/NigUZ6VtbNziLe9OS3wSyiplQ7cm/tdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JPue85SbO4O3VbPxNUwVOSGNp7phyJh2LuzwnbdMqoTHlwRbeQMIoKFrL4ipD8DJO
         AwHWdk0gVJDUQ1/6bCV/Q3FtwT5ZOK+YT575b5jXCymJ2kXnadmQUUUNrOZ6iagBZO
         7OcemmfcPM8MRXRSQv/jM/TaRJOSLbNlr+Pxfjnw=
Date:   Mon, 7 Sep 2020 12:49:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH net] netdevice.h: fix proto_down_reason kernel-doc
 warning
Message-ID: <20200907124951.044d34be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7275c711-b313-b78c-bea5-e836f323b0ef@infradead.org>
References: <7275c711-b313-b78c-bea5-e836f323b0ef@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 20:31:16 -0700 Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix kernel-doc warning in <linux/netdevice.h>:
> 
> ../include/linux/netdevice.h:2158: warning: Function parameter or member 'proto_down_reason' not described in 'net_device'
> 
> Fixes: 829eb208e80d ("rtnetlink: add support for protodown reason")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>

Applied, but I had to fix a checkpatch warning about a space before a
tab..
