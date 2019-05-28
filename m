Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFDE92C594
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfE1LlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfE1LlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 07:41:02 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B1E2070D;
        Tue, 28 May 2019 11:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559043662;
        bh=Pmf36PSoO6MqqVNDWMf/14CvackxSCX3cql021PGiak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uRa9ej4A2afDXo/lHs1JyaDCQtE/lA1B2deM7fWA7F+QbCG2xWGVnnubjBb0iv5wV
         v3xDILdEZA5Pk4oHr2M/DIwFOBowuLByJLQ9RWMckvmp8DkjQ5Nfvj5gCQ/wGJOXok
         DQfqXdM2+jSD3YcRmy/cHYXUn4uWT2SJdP1kwXNM=
Date:   Tue, 28 May 2019 14:40:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     RDMA mailing list <linux-rdma@vger.kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: CFP: 4th RDMA Mini-Summit at LPC 2019
Message-ID: <20190528114058.GI4633@mtr-leonro.mtl.com>
References: <20190514122321.GH6425@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514122321.GH6425@mtr-leonro.mtl.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

REMINDER

On Tue, May 14, 2019 at 03:23:21PM +0300, Leon Romanovsky wrote:
> This is a call for proposals for the 4th RDMA mini-summit at the Linux
> Plumbers Conference in Lisbon, Portugal, which will be happening on
> September 9-11h, 2019.
>
> We are looking for topics with focus on active audience discussions
> and problem solving. The preferable topic is up to 30 minutes with
> 3-5 slides maximum.
>
> This year, the LPC will include netdev track too and it is
> collocated with Kernel Summit, such timing makes an excellent
> opportunity to drive cross-tree solutions.
>
> BTW, RDMA is not accepted yet as a track in LPC, but let's think
> positive and start collect topics.
>
> Thanks
