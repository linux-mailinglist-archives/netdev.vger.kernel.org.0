Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A1D2244A9
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGQTyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgGQTyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:54:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E31C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 12:54:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 836BA11E45929;
        Fri, 17 Jul 2020 12:54:46 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:54:45 -0700 (PDT)
Message-Id: <20200717.125445.2113775442625506234.davem@davemloft.net>
To:     priyarjha@google.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] tcp: improve handling of DSACK covering
 multiple segments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716191235.1556723-1-priyarjha@google.com>
References: <20200716191235.1556723-1-priyarjha@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:54:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Priyaranjan Jha <priyarjha@google.com>
Date: Thu, 16 Jul 2020 12:12:33 -0700

> Currently, while processing DSACK, we assume DSACK covers only one
> segment. This leads to significant underestimation of no. of duplicate
> segments with LRO/GRO. Also, the existing SNMP counters, TCPDSACKRecv
> and TCPDSACKOfoRecv, make similar assumption for DSACK, which makes them
> unusable for estimating spurious retransmit rates.
> 
> This patch series fixes the segment accounting with DSACK, by estimating
> number of duplicate segments based on: (DSACKed sequence range) / MSS.
> It also introduces a new SNMP counter, TCPDSACKRecvSegs, which tracks
> the estimated number of duplicate segments.

Series applied, thank you.
