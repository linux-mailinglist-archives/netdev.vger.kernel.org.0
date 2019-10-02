Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9F9C8E14
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfJBQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:15:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfJBQPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:15:44 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C59615404E23;
        Wed,  2 Oct 2019 09:15:41 -0700 (PDT)
Date:   Wed, 02 Oct 2019 12:15:38 -0400 (EDT)
Message-Id: <20191002.121538.299094926277817963.davem@davemloft.net>
To:     pc@cjr.nz
Cc:     netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, smfrench@gmail.com
Subject: Re: [PATCH net-next 0/2] Experimental SMB rootfs support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001171028.23356-1-pc@cjr.nz>
References: <20191001171028.23356-1-pc@cjr.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 09:15:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Date: Tue,  1 Oct 2019 14:10:26 -0300

> This patch series enables Linux to mount root file systems over the
> network by utilizing SMB protocol.
 ...

Series applied, thanks.
