Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E976C35013C
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhCaNcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:32:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38088 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235828AbhCaNcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 09:32:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2C736204B4
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 15:32:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id w4Bg7fpq_Tgq for <netdev@vger.kernel.org>;
        Wed, 31 Mar 2021 15:32:09 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6E71920270
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 15:32:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 15:32:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 31 Mar
 2021 15:32:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7FBE831804DE; Wed, 31 Mar 2021 15:32:08 +0200 (CEST)
Date:   Wed, 31 Mar 2021 15:32:08 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: [ANNOUNCE] New list for technical discussion about IPsec
 implementation and specification.
Message-ID: <20210331133208.GK62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

I want to announce a new public mailinglist for technical discussion
about IPsec implementation and specification.

Discussion topics are development on IPsec implementation (ESP, IKEv2 etc.)
and specification. Patches for an early review are welcome too.

If you are interested, please subscribe at:

https://linux-ipsec.org/mailman/listinfo/devel/

Please also note that this new list is NOT the right list if you want
to submit patches to Linux IPsec/xfrm. All patches for Linux IPsec/xfrm
MUST be sent to netdev as usual.
