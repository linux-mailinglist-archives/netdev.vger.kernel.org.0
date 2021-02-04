Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A787730EA23
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhBDCYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233319AbhBDCYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:24:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 431AD64DF5;
        Thu,  4 Feb 2021 02:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612405418;
        bh=k9YFdTEJxhaIspUMpRfyPEFg1dzP2qQ+cKSiVvDs01g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IZclPNSXjIE3U67tLi7br7f2C5w2//nXj5CBmq7Jsm/hy2ldDO895kGWamuYw/C4U
         CleEnfyFA8R8SuHTeh0yL+/LEQDy6pQ85ItplfVtqXz5x90K0f2xK/Os2gTL8LKPqr
         Itv5cdhzNr6HVcbr/h21iwWQcGyGzLN9WKBuDJThXzHyWCD0w+Xxu1OlPAjeJ4O2N1
         bE4+W9LYWk6aqjptrzL16oa834G5kIbTqTZjG59OADM+OKbh33Z4aUr6I8h/2u2rs7
         eRguHDZZ27EWV5UZaFZZTcXj++6/h+gyi+W7/fMdRcfhRJc48WyDKbf2Pxd1k15LC/
         q+jGeib79s5CA==
Date:   Wed, 3 Feb 2021 18:23:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add new T6 PCI device id 0x6092
Message-ID: <20210203182337.3a77480a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202182511.8109-1-rajur@chelsio.com>
References: <20210202182511.8109-1-rajur@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 23:55:11 +0530 Raju Rangoju wrote:
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Does this device require any code which only exists in net-next?

Pure device id patches are okay for net.
