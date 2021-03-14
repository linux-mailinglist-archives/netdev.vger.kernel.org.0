Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A4D33A448
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhCNK7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 06:59:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50960 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbhCNK6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 06:58:36 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Mar 2021 06:58:36 EDT
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B2E5463135;
        Sun, 14 Mar 2021 11:52:58 +0100 (CET)
Date:   Sun, 14 Mar 2021 11:53:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David R <david@unsolicited.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: Panic after upgrading to 5.11.6 stable
Message-ID: <20210314105301.GA27784@salvia>
References: <dfd0563b-91da-87ab-0cfa-c1b99c659212@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dfd0563b-91da-87ab-0cfa-c1b99c659212@unsolicited.net>
User-Agent: Mozilla/5.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 10:30:55AM +0000, David R wrote:
> I attempted to upgrade my home server to 5.11 today. The system panics
> soon after boot with the following :-
> 
> In iptables by the looks of the stack.
> 
> 5.10.23 works fine.
> 
> Can provide config (and boot logs from 5.10.23) if required.

Please have a look at:

https://bugzilla.kernel.org/show_bug.cgi?id=211911
