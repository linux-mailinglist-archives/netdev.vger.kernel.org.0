Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3921F6E3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGNQOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgGNQOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:14:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9F92253A;
        Tue, 14 Jul 2020 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594743240;
        bh=z5J+dYoqDiiM1283WkXl2NWoTt/gHF3TppmStMEmZus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r2Rf7aOWtfe+SjzHn9XUjkoZ8+11/+EbCZNvqjDYa390dYHN4ljdqsUNhnb9Id+cn
         0zIof5R64C7rfXmnH2eRlnNyhR6UHtKVrd6FjAArbGG8sUKbIUZ3nMbcvjTMYU56+R
         WQJFSgG0U6rlyAkjv2EwPJJcuSR9kZ+3hQVXeBiM=
Date:   Tue, 14 Jul 2020 18:13:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
Cc:     Miguel =?iso-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Simplify usbnet_cdc_update_filter
Message-ID: <20200714161357.GA2091238@kroah.com>
References: <20180701081550.GA7048@kroah.com>
 <20180701090553.7776-1-miguel@det.uvigo.gal>
 <20180701090553.7776-2-miguel@det.uvigo.gal>
 <b02575d7937188167ed711a403e6d9fa3f80e60d.camel@wxcafe.net>
 <20200714060628.GC657428@kroah.com>
 <5c67c82b3988d6423317792e06a3127f97a51ba6.camel@wxcafe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c67c82b3988d6423317792e06a3127f97a51ba6.camel@wxcafe.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:13:18AM -0400, Wxcafé wrote:
> Hi Greg,
> 
> Thanks for your feedback! I'm not sure what you mean by "a format they
> can be applied in", I'm guessing as three emails, with a single patch
> each?

We have loads of documentation about how to do this in the kernel tree,
you might want to read up on it starting at Documentation/process/

thanks!

greg k-h
