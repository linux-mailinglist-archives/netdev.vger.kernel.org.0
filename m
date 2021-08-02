Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04543DDF87
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhHBSpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:45:40 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:39038 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhHBSpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 14:45:40 -0400
Received: (qmail 48634 invoked by uid 89); 2 Aug 2021 18:45:27 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 2 Aug 2021 18:45:27 -0000
Date:   Mon, 2 Aug 2021 11:45:25 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210802184525.jzcp6ty6uwfmhika@bsd-mbp.local>
References: <20210802165157.1706690-1-jonathan.lemon@gmail.com>
 <20210802170910.GB9832@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802170910.GB9832@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 10:09:10AM -0700, Richard Cochran wrote:
> On Mon, Aug 02, 2021 at 09:51:57AM -0700, Jonathan Lemon wrote:
> 
> > The resources are collected under a driver procfs directory:
> > 
> >   [jlemon@timecard ~]$ ls -g /proc/driver/ocp1
> 
> I thought that adding new stuff under /proc was stopped years ago?

The Documentation seems to indicate that driver specific entries
should be under /proc/driver, and there are several existing examples
in the tree.  No idea whether this is current best practice.
-- 
Jonathan
