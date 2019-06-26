Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C14B57237
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFZUGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:06:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:06:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 482F114DB71DF;
        Wed, 26 Jun 2019 13:05:59 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:05:58 -0700 (PDT)
Message-Id: <20190626.130558.961377889679553755.davem@davemloft.net>
To:     puranjay12@gmail.com
Cc:     skhan@linuxfoundation.org, bjorn@helgaas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH v5 0/3] net: fddi: skfp: Use PCI generic definitions
 instead of private duplicates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621154037.25245-1-puranjay12@gmail.com>
References: <20190621154037.25245-1-puranjay12@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:05:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Puranjay Mohan <puranjay12@gmail.com>
Date: Fri, 21 Jun 2019 21:10:34 +0530

> This patch series removes the private duplicates of PCI definitions in
> favour of generic definitions defined in pci_regs.h.
> 
> This driver only uses some of the generic PCI definitons,
> which are included from pci_regs.h and thier private versions
> are removed from skfbi.h with all other private defines.
> 
> The skfbi.h defines PCI_REV_ID and other private defines with different
> names, these are renamed to Generic PCI names to make them
> compatible with defines in pci_regs.h.
> 
> All unused defines are removed from skfbi.h.
 ...

Series applied, thanks.
