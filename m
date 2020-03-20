Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A0218D986
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCTUgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbgCTUgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 16:36:35 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D2BD20739;
        Fri, 20 Mar 2020 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584736595;
        bh=JuKTOX/pLGJtmGtCCEnRQ02o0f4W5xGkTZgRqJR/9hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ERrLb2PF6N0qySGoiMVatTgeXXoh1EcDzIPWBC5fr969pn0bP+Hpo2HjGse+oiIrp
         If+XyD12IRWYrtUVWEDtxkA6PjH5w4UB5OQBbTpqY+9MSrupUBOnopO1dc7BxKrWli
         ocVzi7MHFdzZ8ZztHktbUubYya6F4YiZUpDUdGCk=
Date:   Fri, 20 Mar 2020 13:36:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v4 net-next 0/8] octeontx2-vf: Add network driver for
 virtual function
Message-ID: <20200320133633.30ceec6a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Mar 2020 00:27:18 +0530 sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patch series adds  network driver for the virtual functions of
> OcteonTX2 SOC's resource virtualization unit (RVU).

Acked-by: Jakub Kicinski <kuba@kernel.org>
