Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F6BB002
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfIWIx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:53:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731943AbfIWIx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:53:29 -0400
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BE95154467CB;
        Mon, 23 Sep 2019 01:53:27 -0700 (PDT)
Date:   Mon, 23 Sep 2019 10:53:23 +0200 (CEST)
Message-Id: <20190923.105323.344196507088158149.davem@davemloft.net>
To:     pc@cjr.nz
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        aaptel@suse.com
Subject: Re: [PATCH v2 1/3] cifs: Add support for root file systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190919152116.27076-1-pc@cjr.nz>
References: <20190716220452.3382-1-paulo@paulo.ac>
        <20190919152116.27076-1-pc@cjr.nz>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Sep 2019 01:53:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit this series when the net-next tree opens back up, and also
with an appropriate "[PATCH 0/N]" header posting explaining what the patch
series is doing, how it is doing it, and why it is doing it that way.

Thank you.
