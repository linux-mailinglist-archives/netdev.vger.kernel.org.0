Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE445BE3
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfFNLzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:55:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46574 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfFNLzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:55:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so2185324wrw.13
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 04:55:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cxChIMoPFj6cXUwSST1OW2WRxLfIqJJkEEB8ABgEhGU=;
        b=iIYKa6zdSGKEvjPsfIRNt1DfH6b9b8uKnwypwAm32vpW+beBSRzei/mMqJXuE4aSBs
         MWDoJ3pNPNh4lkXy0sC7cuXgWiHldIPSm70yATTyBtpo0a60AB+DKQ8ZHy8eq82dTEMz
         fWQaviXOMOcnjsuBkhOpeg3Gk1eycddnpRDjZIKFpLunwjMdbmZUyreE52usiMSfw8xZ
         YDZ8rIBbwNyR5LTf6eaBPT5tCHKET1XzDVlPfg+e63hzKwRRX9b5X8/S1BaKaXh1+Prf
         CjNYu9GB/CSw5YKG+9ZWobpEugG55LYgNrnZgkZPBFsklrpYU2pcP7Aj618lV22zn3RY
         +CVA==
X-Gm-Message-State: APjAAAXetQ3mllGOP0yd907gDO0bfs0ZS3SsJtp81nVaFCqU3a/VeKkI
        5JOO/tEXhZkgrfudCwLiz38mDw==
X-Google-Smtp-Source: APXvYqx15efgp+f/EFsg4st60Vdhr30IZ301XzwdkHldChc/7LL+DpcDlKYkI6BDF7CeErsceMT+jg==
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr1980032wrt.295.1560513309723;
        Fri, 14 Jun 2019 04:55:09 -0700 (PDT)
Received: from linux.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id s12sm2315434wmh.34.2019.06.14.04.55.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 04:55:09 -0700 (PDT)
Date:   Fri, 14 Jun 2019 13:55:07 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Guillaume Nault <g.nault@alphalink.fr>, netdev@vger.kernel.org
Subject: Re: [PATCH] l2tp: no need to check return value of debugfs_create
 functions
Message-ID: <20190614115506.GA28890@linux.home>
References: <20190614070438.GA25351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614070438.GA25351@kroah.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 09:04:38AM +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Also, there is no need to store the individual debugfs file name, just
> remove the whole directory all at once, saving a local variable.
> 
Acked-by: Guillaume Nault <gnault@redhat.com>
