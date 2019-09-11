Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A79B05D5
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 01:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfIKXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 19:01:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfIKXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 19:01:33 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5397E154FCEF8;
        Wed, 11 Sep 2019 16:01:32 -0700 (PDT)
Date:   Thu, 12 Sep 2019 01:01:30 +0200 (CEST)
Message-Id: <20190912.010130.736236657631199212.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net-next] nfp: read chip model from the PluDevice
 register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911152118.30698-1-simon.horman@netronome.com>
References: <20190911152118.30698-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 16:01:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Wed, 11 Sep 2019 16:21:18 +0100

> From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> 
> The PluDevice register provides the authoritative chip model/revision.
> 
> Since the model number is purely used for reporting purposes, follow
> the hardware team convention of subtracting 0x10 from the PluDevice
> register to obtain the chip model/revision number.
> 
> Suggested-by: Francois H. Theron <francois.theron@netronome.com>
> Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Applied.
