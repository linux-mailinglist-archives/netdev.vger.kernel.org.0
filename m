Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549CD63F40
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 04:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfGJCVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 22:21:52 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43130 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGJCVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 22:21:52 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so705838qka.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 19:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=unvZDjN9kre6psmsB+/DO8sq0hzYLAmdGDNLpsXbVH0=;
        b=E5gpuJLjFkfovVsP6Ax5iGhesnoLJeEcchd7fuqXH1PfcxfYiTcpgLeb3nVB9kWDGe
         0QN8/CNulZ9xbze4R10L11mIAZM5cqwkpsLcHi2800RvQ4TWRDMAXibRXVR4NaX/yAiP
         IxaFn8AiOYrJvyvtQz9Iqtq1PygO9ZWq1LWucpratJUCkdw5+fhccWls3nd0xEkWRWQ5
         NWOmaSElulZQ17RbioHSICoIKK+n6uT2M15TatxDsFV1FOxOwV6z46T3rWVlnALXHwMN
         Hip7yWXmg7T4ycaKQPo+mG3Cl7l208x9raO4ujB7zTb+hfAVU91ll9p78Q98K839eM0R
         qnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=unvZDjN9kre6psmsB+/DO8sq0hzYLAmdGDNLpsXbVH0=;
        b=rI7Mu3DF+vIjUv8CpGowqsTMJZ1aXn6GANy7D7GLXdIR+6Xx2Pla0QxBikyNYkhR9o
         uJkrzF96+ZKku8uW2FmfaIJuitxe+IwOhRw7j6MgUPGsHIqPIJCXG8jQsFhKs7s8ydM9
         T851CVwzcZO0qhMKmnb87dhDBc6n1xxa4cPf60K9FYshjt8vgVV3tWGjYU05g2QMSH3c
         OdD1gEegn5+j2sF8Dul1Hr5AODGTmQ5UsZdvAD1D5xgCKEBY+SVtITDoXFbko4oTzgFV
         lFdDa4C0T8T0TaOprA9BGozYd+7BKpbmeEofL6mU1SLGTEwlA+YywYw5n3L4FoxdYi2m
         lkBA==
X-Gm-Message-State: APjAAAXXnQgKGUiwo41yUYzSwwt5SBlilELNaVFIHZiiKukyhmB3c4Ir
        8tjZvZPKbjJFt1xrGxRQpKHtUA==
X-Google-Smtp-Source: APXvYqxCjy5HfKU5iLOE3RPYTY9mZicl5S0/RRVQ5hl4qopBDJc2zNqZ93acRVRcnkU/jmx97KBoeA==
X-Received: by 2002:a37:a94:: with SMTP id 142mr19619112qkk.89.1562725310958;
        Tue, 09 Jul 2019 19:21:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r189sm445843qkc.60.2019.07.09.19.21.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 19:21:50 -0700 (PDT)
Date:   Tue, 9 Jul 2019 19:21:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 0/6] bpf: sockmap/tls fixes
Message-ID: <20190709192145.473d2d80@cakuba.netronome.com>
In-Reply-To: <20190709170459.387bced6@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
        <20190708231318.1a721ce8@cakuba.netronome.com>
        <5d24b55e8b868_3b162ae67af425b43e@john-XPS-13-9370.notmuch>
        <20190709170459.387bced6@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 17:04:59 -0700, Jakub Kicinski wrote:
> On Tue, 09 Jul 2019 08:40:14 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:  
> > > Looks like strparser is not done'd for offload?    
> > 
> > Right so if rx_conf != TLS_SW then the hardware needs to do
> > the strparser functionality.  
> 
> Can I just take a stab at fixing the HW part?
> 
> Can I rebase this onto net-next?  There are a few patches from net
> missing in the bpf tree.

I think I fixed patch 1 for offload, I need to test it a little more
and I'll send it back to you. In the meantime, let me ask some
questions about the other two :)
