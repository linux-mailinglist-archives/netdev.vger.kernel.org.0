Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1162299694
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792602AbgJZTNQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Oct 2020 15:13:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:42044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404222AbgJZTEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 15:04:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E8A94AE2B;
        Mon, 26 Oct 2020 19:04:08 +0000 (UTC)
Date:   Mon, 26 Oct 2020 20:04:07 +0100
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Suchanek <msuchanek@suse.de>, netdev@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cris Forno <cforno12@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmveth: Fix use of ibmveth in a bridge.
Message-Id: <20201026200407.fcf43678ba4cef7fe0cb7c98@suse.de>
In-Reply-To: <20201026115237.21b114fe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201026104221.26570-1-msuchanek@suse.de>
        <20201026115237.21b114fe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:52:37 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 26 Oct 2020 11:42:21 +0100 Michal Suchanek wrote:
> > From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > 
> > The check for src mac address in ibmveth_is_packet_unsupported is wrong.
> > Commit 6f2275433a2f wanted to shut down messages for loopback packets,
> > but now suppresses bridged frames, which are accepted by the hypervisor
> > otherwise bridging won't work at all.
> > 
> > Fixes: 6f2275433a2f ("ibmveth: Detect unsupported packets before sending to the hypervisor")
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> 
> Since the From: line says Thomas we need a signoff from him.

you can add

Signed-off-by: tbogendoerfer@suse.de

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
