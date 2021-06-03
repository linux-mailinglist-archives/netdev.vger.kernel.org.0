Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C45399948
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFCEp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhFCEp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 00:45:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46328613BA;
        Thu,  3 Jun 2021 04:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622695412;
        bh=iBrVSaDhqE8uFABGWrDJeYHOE6iBHbWDWzWxi6Jrflw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AH/gyS9TTOx0VAHLFgYBRFlVkVj9G0e4MGs9R7KiDwKloke9F60xk+iPrefkYaJvj
         bvzyPRk1PLbutzhmbJrjXlzyzVPrUaL9ghP8qmyNcUZ8M8wH9qHSbpIfgkoj7eMhOe
         PoiQACmtOFsKbBDXuKpuqrzPsbNkFoFBOdF4NfYA=
Date:   Thu, 3 Jun 2021 06:43:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kurt Manucredo <fuzzybritches0@gmail.com>
Cc:     syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v3] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <YLhd8BL3HGItbXmx@kroah.com>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602212726.7-1-fuzzybritches0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 09:27:26PM +0000, Kurt Manucredo wrote:
> UBSAN: shift-out-of-bounds in kernel/bpf/core.c:1414:2
> shift exponent 248 is too large for 32-bit type 'unsigned int'

I'm sorry, but I still do not understand what this changelog text means.

Please be very descriptive about what you are doing and why you are
doing it.  All that is here is a message from a random tool :(

thanks,
greg k-h
