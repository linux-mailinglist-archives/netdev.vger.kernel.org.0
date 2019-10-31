Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7869EA853
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfJaAma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:42:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfJaAm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:42:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C5FE14E2E4BA;
        Wed, 30 Oct 2019 17:42:29 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:42:28 -0700 (PDT)
Message-Id: <20191030.174228.2265439224854919563.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH net-next] vxlan: drop "vxlan" parameter in
 vxlan_fdb_alloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <909fa55ac93fa8727ee1d9ec273011056ad7d61f.1572382598.git.gnault@redhat.com>
References: <909fa55ac93fa8727ee1d9ec273011056ad7d61f.1572382598.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:42:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Tue, 29 Oct 2019 21:57:10 +0100

> This parameter has never been used.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thank you.
