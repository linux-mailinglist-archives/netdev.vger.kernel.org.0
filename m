Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD46C19041C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgCXEGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:06:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgCXEGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:06:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8C77155371C6;
        Mon, 23 Mar 2020 21:05:59 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:05:58 -0700 (PDT)
Message-Id: <20200323.210558.579490999359919534.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     kstewart@linuxfoundation.org, robert.dolca@intel.com,
        gregkh@linuxfoundation.org, gustavo@embeddedor.com,
        sameo@linux.intel.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] NFC: fdp: Fix a signedness bug in
 fdp_nci_send_patch()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320132117.GA95012@mwanda>
References: <20200320132117.GA95012@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:06:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 20 Mar 2020 16:21:17 +0300

> The nci_conn_max_data_pkt_payload_size() function sometimes returns
> -EPROTO so "max_size" needs to be signed for the error handling to
> work.  We can make "payload_size" an int as well.
> 
> Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied and queued up for -stable, thanks Dan.
