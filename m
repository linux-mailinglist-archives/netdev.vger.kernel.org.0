Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E0B57244
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfFZUHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:07:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfFZUHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:07:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FA4E14DB8366;
        Wed, 26 Jun 2019 13:07:29 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:07:29 -0700 (PDT)
Message-Id: <20190626.130729.2125111135503705774.davem@davemloft.net>
To:     puranjay12@gmail.com
Cc:     skhan@linuxfoundation.org, bjorn@helgaas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] net: ethernet: atheros: atlx: Remove unused and
 private PCI definitions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621163921.26188-4-puranjay12@gmail.com>
References: <20190621163921.26188-1-puranjay12@gmail.com>
        <20190621163921.26188-4-puranjay12@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:07:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Puranjay Mohan <puranjay12@gmail.com>
Date: Fri, 21 Jun 2019 22:09:21 +0530

> Remove unused private PCI definitions from skfbi.h because generic PCI
> symbols are already included from pci_regs.h.
> 
> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>

Please also handle the PCI register bit value define duplications as well,
as pointed out by Bjorn.

Thanks.
