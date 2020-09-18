Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B7D2703ED
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgIRSZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIRSZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 14:25:28 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D886720DD4;
        Fri, 18 Sep 2020 18:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600453527;
        bh=St7xrC1YAXFSKU+RhJNVRfCOiAh7WO9dh71WajWIgkU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mBE0nW9xNDq6f32pid1WqUOZdyUcsjSBjpR8wHnb+gdJoPBGoYqzm1FPQ4hAFG3Be
         AEAn12nDVOuGi/NAKdxFg71slmJtBjGVZ6jDa2Zlnxexo/aOznNnmDaxQiXAHlku+Z
         QKuP5PcxpNhnmjSyhYFr++5XEvKHVhqARQmv5KPM=
Message-ID: <9a43d342868ca6803119e401e7898180b65c4e7c.camel@kernel.org>
Subject: Re: [PATCH v3,net-next,2/4] octeontx2-af: add support to manage the
 CPT unit
From:   Saeed Mahameed <saeed@kernel.org>
To:     Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        kuba@kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, schandran@marvell.com, pathreya@marvell.com,
        Vidya Sagar Velumuri <vvelumuri@marvell.com>,
        Lukas Bartosik <lbartosik@marvell.com>
Date:   Fri, 18 Sep 2020 11:25:25 -0700
In-Reply-To: <20200917132835.28325-3-schalla@marvell.com>
References: <20200917132835.28325-1-schalla@marvell.com>
         <20200917132835.28325-3-schalla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 18:58 +0530, Srujana Challa wrote:
> 
> 
> +int rvu_mbox_handler_nix_inline_ipsec_lf_cfg(struct rvu *rvu,
> 
> +               struct nix_inline_ipsec_lf_cfg *req, struct msg_rsp
> 

Can you do something about this code alignment ?


checkpatch outputs:

---------------------------------------------------------------------
---
Commit c5f9e5da557f ("octeontx2-af: add support to manage the CPT
unit")
---------------------------------------------------------------------
---
CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
#958: FILE: drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:3454:
+int rvu_mbox_handler_nix_inline_ipsec_lf_cfg(struct rvu *rvu,
+               struct nix_inline_ipsec_lf_cfg *req, struct msg_rsp
*rsp)

WARNING:NO_AUTHOR_SIGN_OFF: Missing Signed-off-by: line by nominal
patch author 'Srujana <schalla@marvell.com>'

