Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115DA17E621
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCIRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:53:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCIRxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:53:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83CF01593EEDE;
        Mon,  9 Mar 2020 10:53:06 -0700 (PDT)
Date:   Mon, 09 Mar 2020 10:52:57 -0700 (PDT)
Message-Id: <20200309.105257.687115756240472950.davem@davemloft.net>
To:     mayflowerera@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] macsec: Support XPN frame handling - IEEE
 802.1AEbw
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309194702.117050-1-mayflowerera@gmail.com>
References: <20200309194702.117050-1-mayflowerera@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 10:53:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


In the future, please fix the time on your computer.  It is inaccurate and this
shows up in the email headers, and thus makes your patches appear out of order
relative to other submissions on this mailing list when they are queued up in
patchwork.

Thank you.
