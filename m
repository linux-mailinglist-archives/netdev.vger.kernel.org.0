Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78821BB97D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgD1JIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:08:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35220 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgD1JIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:08:09 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 69C0725AD57;
        Tue, 28 Apr 2020 19:08:06 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 5D3231A94; Tue, 28 Apr 2020 11:08:04 +0200 (CEST)
Date:   Tue, 28 Apr 2020 11:08:04 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Re: [PATCH 37/38] docs: networking: convert ipvs-sysctl.txt to ReST
Message-ID: <20200428090804.GB14072@vergenet.net>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
 <c47a3042ec7d3f8cb3a44f68eb4cf5c94c075a3c.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c47a3042ec7d3f8cb3a44f68eb4cf5c94c075a3c.1588024424.git.mchehab+huawei@kernel.org>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 12:01:52AM +0200, Mauro Carvalho Chehab wrote:
> - add SPDX header;
> - add a document title;
> - mark lists as such;
> - mark code blocks and literals as such;
> - adjust identation, whitespaces and blank lines;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Simon Horman <horms@verge.net.au>

