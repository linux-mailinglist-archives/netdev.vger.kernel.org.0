Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100482CEAC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbfE1S3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:29:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfE1S3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:29:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19BD1133E9740;
        Tue, 28 May 2019 11:29:47 -0700 (PDT)
Date:   Tue, 28 May 2019 11:29:46 -0700 (PDT)
Message-Id: <20190528.112946.1159547861106769615.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] fsl/fman: include IPSEC SPI in the Keygen
 extraction
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558960332-12450-1-git-send-email-madalin.bucur@nxp.com>
References: <1558960332-12450-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 11:29:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Mon, 27 May 2019 15:32:12 +0300

> The keygen extracted fields are used as input for the hash that
> determines the incoming frames distribution. Adding IPSEC SPI so
> different IPSEC flows can be distributed to different CPUs.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>

Applied.
