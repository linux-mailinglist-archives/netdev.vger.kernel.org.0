Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A520D41676
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406712AbfFKUwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 16:52:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57735 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406629AbfFKUwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 16:52:33 -0400
Received: from [107.15.85.130] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hankp-00015x-IO; Tue, 11 Jun 2019 16:52:30 -0400
Date:   Tue, 11 Jun 2019 16:52:22 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com
Subject: Re: [PATCH v3] [sctp] Free cookie before we memdup a new one
Message-ID: <20190611205222.GA31473@hmswarspite.think-freely.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190611192245.9110-1-nhorman@tuxdriver.com>
 <20190611.130856.1857826051148231972.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611.130856.1857826051148231972.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 01:08:56PM -0700, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Tue, 11 Jun 2019 15:22:45 -0400
> 
> > v2->v3
> > net->sctp
> > also free peer_chunks
> 
> Neil this isn't the first time you're submitting sctp patches right? ;-)
> 
> Subject: "[PATCH v3 net] sctp: Free cookie before we memdup a new one"
> 
> It's "subsystem_prefix: " and I even stated this explicitly yesterday.
> 
No, sorry, I'm trying to do this while I get a CI mess sorted out at the same
time, and I'm not close attention here.

If you want to take over a few dozen user space packages for me in RHEL, I'll
gladly get this right on the first try :)

Neil

