Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F2F259916
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgIAQgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732019AbgIAQgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 12:36:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB1A207D3;
        Tue,  1 Sep 2020 16:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598978175;
        bh=y5k1W0HvaX2B/mtA0NNGDduxI5wo07lnwmFxpVoaIsA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=izlYcnvsXN3eGynXrHUpyeHfIvEdX59/D8DdlvnrJK6bYo+yi/c/jTAQwr00nOCHG
         GGv1t4iP7bVxp78SJByy4WebmYNb/BelP+FZotwp0vWbzAjPKBw/EM8UsK3d82cLuN
         086f6woRCiZAqm3Um/iSDhbZG9bePFSKBLqb4gV8=
Date:   Tue, 1 Sep 2020 09:36:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        zeil@yandex-team.ru, khlebnikov@yandex-team.ru, pabeni@redhat.com,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: Re: [PATCH net-next] net: diag: add workaround for inode truncation
Message-ID: <20200901093613.28a36553@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <26351e38-ccbc-c0ce-f12e-96f85913a6dc@gmail.com>
References: <20200831235956.2143127-1-kuba@kernel.org>
        <26351e38-ccbc-c0ce-f12e-96f85913a6dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Sep 2020 08:55:29 +0200 Eric Dumazet wrote:
> On 8/31/20 4:59 PM, Jakub Kicinski wrote:
> > Dave reports that struct inet_diag_msg::idiag_inode is 32 bit,
> > while inode's type is unsigned long. This leads to truncation.
> > 
> > Since there is nothing we can do about the size of existing
> > fields - add a new attribute to carry 64 bit inode numbers.
> 
> Last time I checked socket inode numbers were 32bit ?
> 
> Is there a plan changing this ?

Ugh, you're right that appears to be a local patch :/ 

I should have checked, sorry for the noise.
