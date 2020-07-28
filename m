Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8AB230F42
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgG1QbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731070AbgG1QbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:31:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935DD20825;
        Tue, 28 Jul 2020 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595953868;
        bh=LLdtzofhNm4AnIrlGUWlkvuOLBb2fQyIHFnBbHmS2BQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uscRVu3NPkgHKIl7NfvZFw0LsTmviND000Zz+j+N1p5rLSzqFylAfHUku4IJD2B5t
         orPdXJweQhtZXs5iYeCHFLgHIMEbjpR13fzENlMFhDmNkDpi7gcR4P+eSAKJhxzePQ
         zLXeMQBZB93ukiMkplVqWofH965u+S3iJdZdCR2A=
Date:   Tue, 28 Jul 2020 18:31:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728163100.GD4181352@kroah.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-22-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727224444.2987641-22-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:44:44PM -0700, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> This provides the interface between the netgpu core module and the
> nvidia kernel driver.  This should be built as an external module,
> pointing to the nvidia build.  For example:
> 
> export NV_PACKAGE_DIR=/w/nvidia/NVIDIA-Linux-x86_64-440.64
> make -C ${kdir} M=`pwd` O=obj $*

Ok, now you are just trolling us.

Nice job, I shouldn't have read the previous patches.

Please, go get a lawyer to sign-off on this patch, with their corporate
email address on it.  That's the only way we could possibly consider
something like this.

Oh, and we need you to use your corporate email address too, as you are
not putting copyright notices on this code, we will need to know who to
come after in the future.

greg k-h
