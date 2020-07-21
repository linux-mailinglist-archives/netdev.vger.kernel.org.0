Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B12228657
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgGUQph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgGUQph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:45:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF2F2065E;
        Tue, 21 Jul 2020 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595349936;
        bh=sVISY5lpdV9HiNMF+TZ1l+7adHwyshehoDDieXPK3ag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BTtjeGT0AbJjjcCUzlAdp6UTvpAib9877kH2dgQ9qGkR/6cmA83R6cHaMlf31Pj4U
         cxb6477Py1xl2XXSrpjUOwq0XVqIj4AFWOeKlkA19aprsj3fECBs+dGuA8mubbvKq6
         m1yG2lCaDo0hrILubeGWBpIb60l2uRqTqKDMLSqo=
Date:   Tue, 21 Jul 2020 09:45:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        kernel test robot <lkp@intel.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200721094535.15df7245@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <aa134db3-a860-534c-9ee2-d68cded37061@solarflare.com>
References: <f1a206ef-23a0-1d3e-9668-0ec33454c2a1@solarflare.com>
        <202007170155.nhtIpp5L%lkp@intel.com>
        <aa134db3-a860-534c-9ee2-d68cded37061@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 15:48:00 +0100 Edward Cree wrote:
> Aaaaargh; does anyone have any bright ideas?

No bright ideas. Why do you want the driver to be modular in the first
place? This is a high performance adapter, not a embedded system. Does
this ~1MB of memory use really matter? Folks who care can rebuild their
kernel and disable the device support with a boolean flag.

Maybe I'm wrong, but I've never seen a reason to break up vendor drivers
for high performance NICs into multiple modules.
