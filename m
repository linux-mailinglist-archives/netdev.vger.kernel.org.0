Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421E2231213
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgG1S6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgG1S6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:58:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7739207FC;
        Tue, 28 Jul 2020 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595962679;
        bh=0HV8lN5IdMCC9MkRn4BlddQazVVZ1gMba/PI+cxls5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ui0hdp7k5vqJCLPDJjb3SsvcXVjVUivndHyYTLkJEFjSh0vvHfUnBKMVVlc8L3gbV
         kraVidre/lhIU5GpEK/z35Bm7EaCDHh7RA83ohP9jbF7q0DJWP5nu6p4HceAGm7I09
         D74AAx8+4sHtUVPBS1Zn5gR1fzycy20TX4ytumsU=
Date:   Tue, 28 Jul 2020 11:57:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: iproute2 DDMMYY versioning - why?
Message-ID: <20200728115758.1588ba88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJ3xEMhk+EQ_avGSBDB5_Gnj09w3goUJKkxzt8innWvFkTeEVA@mail.gmail.com>
References: <CAJ3xEMhk+EQ_avGSBDB5_Gnj09w3goUJKkxzt8innWvFkTeEVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 16:05:50 +0300 Or Gerlitz wrote:
> Stephen,
> 
> Taking into account that iproute releases are aligned with the kernel
> ones -- is there any real reason for the confusing DDMMYY double
> versioning?
> 
> I see that even the git tags go after the kernel releases..

+1


