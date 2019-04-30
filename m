Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D5F958
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfD3Mzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:55:37 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:33586 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfD3Mzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 08:55:37 -0400
Received: by mail.osadl.at (Postfix, from userid 1001)
        id 756C05C1015; Tue, 30 Apr 2019 14:54:44 +0200 (CEST)
Date:   Tue, 30 Apr 2019 14:54:44 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Nicholas Mc Guire <hofrat@osadl.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] rds: ib: force endiannes annotation
Message-ID: <20190430125444.GB26274@osadl.at>
References: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
 <20190430114321.GA9813@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430114321.GA9813@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 04:43:21AM -0700, Christoph Hellwig wrote:
> The patch looks good, but the force in the subject sounds weird now.


True - but last time I renamed the subject when seindg a V2 I
wsa told not to do that - the rational was if I rename it and
call it V2 -then there is no V1...

If thats nonsense - then I'll resend with a new commit subject

thx!
hofrat
