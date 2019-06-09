Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485763A35A
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfFICdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:33:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:37438 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfFICdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3Fp1yuwwbOTbYdEqsZgF9iklbrQHl3f9VYC9FtEc6kI=; b=QklMMOA9CGj+eXx0W9MvmFE0by
        0aQedeNfBMWna6CYprMFaEI2qA4kPeOnRyOEvn2aWyVBRVrFxHsJhJT4y8j8WRET4/OuncElTGcKY
        1kXcQ0a8VlI2NwrvtTMO2cQ3q7h1Jn66qeukXioB6/N9vSPhV0EgdPWi9n/gC+9fmyNydhA9BXiNo
        9yKbfd0o7rTBHQVpNnQx4TQOlFVXinBGdjSGKt7RUOGCGI+/dbrJnHDzL0AkB20um1bet10+OzDMq
        dP0ath70zmmP8wrAoVRXdoywUNkrUudR2U+ifiamGNlWhAtXUpuSrxNwDl+xdQy39vJRKkx3vlkf3
        aQ09AIQw==;
Received: from 179.176.115.133.dynamic.adsl.gvt.net.br ([179.176.115.133] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZneK-0004xW-3Q; Sun, 09 Jun 2019 02:33:36 +0000
Date:   Sat, 8 Jun 2019 23:33:31 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 00/22] Some documentation fixes
Message-ID: <20190608233149.6a35bee9@coco.lan>
In-Reply-To: <20190608134407.580f8bb5@lwn.net>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
        <20190607115521.6bf39030@lwn.net>
        <20190607154430.4879976d@coco.lan>
        <20190608134407.580f8bb5@lwn.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 8 Jun 2019 13:44:07 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Fri, 7 Jun 2019 15:44:30 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> > After doing that, there are 17 patches yet to be applied. Two new
> > patches are now needed too, due to vfs.txt -> vfs.rst and
> > pci.txt -> pci.rst renames.  
> 
> OK, I've applied the set, minus those that had been picked up elsewhere.

Thank you!

I'm sending the conversion patches based after your tree + linux-next.

I opted to split it on a few series, as I have already 85 patches
here (and still several new "orphan" index files that I need to work
in order to find them a place).

Sending right now the first 33 patches.


Thanks,
Mauro
