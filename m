Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE02A4ED59
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfFUQoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUQoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 12:44:32 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2599920665;
        Fri, 21 Jun 2019 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561135471;
        bh=m33EIjjXIG8VQjpoiuplC1PQdv27MnbGyWxYvzJb5iU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edhSQJnoaE2M7HPSpl01zi1vEtEhmwOmlCV0ykFpyZQG5VE2zNsgNeeX9l26kpK/O
         ZO8r1GMrygTMMQ4BoZ/jXGQeC0bZQ+63UD5uJNe9J19Ud7q20fKYRhuSgrnbV8YnYr
         qZhG27ydBquwpLnQgwXYJGdiDokvJ4YE5w5SAe+0=
Date:   Fri, 21 Jun 2019 11:44:29 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 0/3] net: fddi: skfp: Use PCI generic definitions
 instead of private duplicates
Message-ID: <20190621164429.GA187016@google.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
 <20190621162024.53620dd9@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621162024.53620dd9@alans-desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 04:20:24PM +0100, Alan Cox wrote:
> On Fri, 21 Jun 2019 15:16:04 +0530
> Puranjay Mohan <puranjay12@gmail.com> wrote:
> 
> > This patch series removes the private duplicates of PCI definitions in
> > favour of generic definitions defined in pci_regs.h.
> 
> Why bother ? It's an ancient obsolete card ?

That's a fair question.

Is there anything that would indicate that "this file is obsolete and
problems shouldn't be fixed"?  Nobody wants to waste time on things
that don't need to be fixed, but I don't know how to tell if something
is obsolete.

My naive assumption is that if something is in the tree, it's fair
game for fixes and cleanups.

Bjorn
