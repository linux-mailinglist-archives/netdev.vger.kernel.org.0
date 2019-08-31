Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE0A433C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 10:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfHaITD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 31 Aug 2019 04:19:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:51642 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfHaITD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 04:19:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81E3EAEF8;
        Sat, 31 Aug 2019 08:19:01 +0000 (UTC)
Date:   Sat, 31 Aug 2019 10:19:00 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, yuehaibing@huawei.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: seeq: Fix the function used to release some memory
 in an error handling path
Message-Id: <20190831101900.c3f8881c1bbebf870eed9c68@suse.de>
In-Reply-To: <20190831071751.1479-1-christophe.jaillet@wanadoo.fr>
References: <20190831071751.1479-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Aug 2019 09:17:51 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> In commit 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv"),
> a call to 'get_zeroed_page()' has been turned into a call to
> 'dma_alloc_coherent()'. Only the remove function has been updated to turn
> the corresponding 'free_page()' into 'dma_free_attrs()'.
> The error hndling path of the probe function has not been updated.

Looks good.

Reviewed-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
