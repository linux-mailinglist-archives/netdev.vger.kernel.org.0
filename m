Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F214161366
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 03:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfGGBDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 21:03:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33970 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfGGBDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 21:03:37 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hjvaK-00025m-Nz; Sun, 07 Jul 2019 01:03:25 +0000
Date:   Sun, 7 Jul 2019 02:03:20 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Per.Hallsmark@windriver.com
Subject: Re: [PATCH 1/2] proc: revalidate directories created with
 proc_net_mkdir()
Message-ID: <20190707010317.GR17978@ZenIV.linux.org.uk>
References: <20190706165201.GA10550@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706165201.GA10550@avx2>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 07:52:02PM +0300, Alexey Dobriyan wrote:
> +struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
> +				   struct proc_dir_entry **parent, void *data)

	Two underscores, please...

> +	parent->nlink++;
> +	pde = proc_register(parent, pde);
> +	if (!pde)
> +		parent->nlink++;

	Really?
