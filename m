Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E435222617B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgGTN6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:58:50 -0400
Received: from ms.lwn.net ([45.79.88.28]:46908 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgGTN6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:58:50 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 566F42CD;
        Mon, 20 Jul 2020 13:58:49 +0000 (UTC)
Date:   Mon, 20 Jul 2020 07:58:48 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
Message-ID: <20200720075848.26bc3dfe@lwn.net>
In-Reply-To: <20200720045626.GF127306@unreal>
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
        <20200720045626.GF127306@unreal>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 07:56:26 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> >  Documentation/networking/rds.rst | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)  
> 
> Why can't it be done in one mega-patch?
> It is insane to see patch for every file/link.
> 
> We have more than 4k files with http:// in it.

Do *you* want to review that megapatch?  The number of issues that have
come up make it clear that these patches do, indeed, need review...

jon
