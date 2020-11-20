Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9520E2BB1E3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgKTSAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgKTSAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:00:09 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9962240B;
        Fri, 20 Nov 2020 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605895208;
        bh=T3biKhUEAaIAP2ETbP8365VNKZeQ1atM6pSuMEEjscc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JxD4pcLH3cc+PJtccnGtIcN5wGI13aUTJBKBsowHWnCDutwYrajbyqCssmv1gMP9x
         PbhMlsnq7NzvHpjETrydr6AnjslKLbysI2axtLweRN3Dln3Rpzn9iD/awDRauVceOx
         OfsvV5Hiz3v90uHxlp8uq0SsfIarkArSc6b4ix5w=
Date:   Fri, 20 Nov 2020 10:00:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, brouer@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] net: netsec: add xdp tx return bulking support
Message-ID: <20201120100007.5b138d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
References: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 10:35:28 +0100 Lorenzo Bianconi wrote:
> Convert netsec driver to xdp_return_frame_bulk APIs.
> Rely on xdp_return_frame_rx_napi for XDP_TX in order to try to recycle
> the page in the "in-irq" page_pool cache.
> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> This patch is just compile tested, I have not carried out any run test

Doesn't look like anyone will test this so applied, thanks!
