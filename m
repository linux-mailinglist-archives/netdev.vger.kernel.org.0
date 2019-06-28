Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0277759190
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfF1Crv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:47:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfF1Crv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:47:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED454149C725D;
        Thu, 27 Jun 2019 19:47:50 -0700 (PDT)
Date:   Thu, 27 Jun 2019 19:47:50 -0700 (PDT)
Message-Id: <20190627.194750.1006294668550591969.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/5] nfp: extend flower capabilities for GRE
 tunnel offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627231243.8323-1-jakub.kicinski@netronome.com>
References: <20190627231243.8323-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 19:47:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 27 Jun 2019 16:12:38 -0700

> Pieter says:
> 
> This set extends the flower match and action components to offload
> GRE decapsulation with classification and encapsulation actions. The
> first 3 patches are refactor and cleanup patches for improving
> readability and reusability. Patch 4 and 5 implement GRE decap and
> encap functionality respectively.

Series applied.
