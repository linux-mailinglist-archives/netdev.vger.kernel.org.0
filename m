Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B727574B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfGYSxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:53:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGYSxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:53:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D1FE143986A8;
        Thu, 25 Jul 2019 11:53:48 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:53:47 -0700 (PDT)
Message-Id: <20190725.115347.1639559656820873202.davem@davemloft.net>
To:     chris.packham@alliedtelesis.co.nz
Cc:     madalin.bucur@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsl/fman: Remove comment referring to non-existent
 function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723233501.6626-1-chris.packham@alliedtelesis.co.nz>
References: <20190723233501.6626-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:53:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Wed, 24 Jul 2019 11:35:01 +1200

> fm_set_max_frm() existed in the Freescale SDK as a callback for an
> early_param. When this code was ported to the upstream kernel the
> early_param was converted to a module_param making the reference to the
> function incorrect. The rest of the comment already does a good job of
> explaining the parameter so removing the reference to the non-existent
> function seems like the best thing to do.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Applied, thanks.
