Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67381C872
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfENMXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENMXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 08:23:25 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0699720850;
        Tue, 14 May 2019 12:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557836604;
        bh=ovaUcWCRrSIqpnGvgTJrI7a7teTV+2l9ZYOtBT+OmF4=;
        h=Date:From:To:Cc:Subject:From;
        b=Ebg+AHk11N2DV0tHSlNQqwSdCHRCKZ5TEkK09AKWwyElKUZNDZMVyGyyuOA2SIVLB
         TGhdMkHrxAXYP+0BgVJFy/foHuBo1XUQzLkqt4uN09VwqbgWPVq6T3X4/0XTAAzBjy
         2E3fppiJ0/ohbf/TTINeM6rBiCDvZYqCaLz5fHks=
Date:   Tue, 14 May 2019 15:23:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     RDMA mailing list <linux-rdma@vger.kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>
Subject: CFP: 4th RDMA Mini-Summit at LPC 2019
Message-ID: <20190514122321.GH6425@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a call for proposals for the 4th RDMA mini-summit at the Linux
Plumbers Conference in Lisbon, Portugal, which will be happening on
September 9-11h, 2019.

We are looking for topics with focus on active audience discussions
and problem solving. The preferable topic is up to 30 minutes with
3-5 slides maximum.

This year, the LPC will include netdev track too and it is
collocated with Kernel Summit, such timing makes an excellent
opportunity to drive cross-tree solutions.

BTW, RDMA is not accepted yet as a track in LPC, but let's think
positive and start collect topics.

Thanks
