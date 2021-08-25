Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788DD3F70BA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbhHYH4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:56:02 -0400
Received: from verein.lst.de ([213.95.11.211]:55188 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238830AbhHYH4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 03:56:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 92E3A67357; Wed, 25 Aug 2021 09:55:12 +0200 (CEST)
Date:   Wed, 25 Aug 2021 09:55:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     syzbot <syzbot+f74aa89114a236643919@syzkaller.appspotmail.com>
Cc:     Kai.Makisara@kolumbus.fi, axboe@kernel.dk, davem@davemloft.net,
        hch@lst.de, jejb@linux.ibm.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-block@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, martin.petersen@oracle.com, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in do_blk_trace_setup
Message-ID: <20210825075512.GA29930@lst.de>
References: <0000000000003830e105ca522cba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003830e105ca522cba@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 11:19:21AM -0700, syzbot wrote:
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Aug 16 13:19:03 2021 +0000
> 
>     st: do not allocate a gendisk

That's very obviously a bisection one-off, the culprit was the sg
conversion.  I've send a fix.
