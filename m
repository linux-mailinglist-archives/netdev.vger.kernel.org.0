Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E6D22BD79
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgGXF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:28:44 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56314 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGXF2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 01:28:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 62AE72052E
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:28:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iFdYB9QnPrkP for <netdev@vger.kernel.org>;
        Fri, 24 Jul 2020 07:28:43 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 05CE2201A0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:28:43 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 07:28:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 24 Jul
 2020 07:28:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4B48531805D5; Fri, 24 Jul 2020 07:28:42 +0200 (CEST)
Date:   Fri, 24 Jul 2020 07:28:42 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC ipsec-next] xfrm: Make the policy hold queue work
 with VTI.
Message-ID: <20200724052842.GU20687@gauss3.secunet.de>
References: <20200717083532.GB20687@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200717083532.GB20687@gauss3.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 10:35:32AM +0200, Steffen Klassert wrote:
> We forgot to support the xfrm policy hold queue when
> VTI was implemented. This patch adds everything we
> need so that we can use the policy hold queue together
> with VTI interfaces.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

This is now applied to ipsec-next.
