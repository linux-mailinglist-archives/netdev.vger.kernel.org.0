Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3397392BAA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhE0KYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:24:15 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:47496 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbhE0KYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:24:10 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 4141A800051;
        Thu, 27 May 2021 12:22:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 12:22:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 27 May
 2021 12:22:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 622DB3180390; Thu, 27 May 2021 12:22:35 +0200 (CEST)
Date:   Thu, 27 May 2021 12:22:35 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <zuoqilin1@163.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] net: Remove unnecessary variables
Message-ID: <20210527102235.GN40979@gauss3.secunet.de>
References: <20210514075513.1801-1-zuoqilin1@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210514075513.1801-1-zuoqilin1@163.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 03:55:13PM +0800, zuoqilin1@163.com wrote:
> From: zuoqilin <zuoqilin@yulong.com>
> 
> It is not necessary to define variables to receive -ENOMEM,
> directly return -ENOMEM.
> 
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>

Applied to ipsec-next, thanks!
