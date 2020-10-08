Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F99286CDB
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 04:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgJHCia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 22:38:30 -0400
Received: from sonic312-10.consmr.mail.ne1.yahoo.com ([66.163.191.241]:42041
        "EHLO sonic312-10.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728225AbgJHCi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 22:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602124706; bh=q/UmU7EtSiP+23uHOg8VlE+g23CI2A1cDj54tJPDCyA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Ng2GkCeZkCHmsUpvJqmkTRVQuanuvkSICTLkGZkmbVIxK1REjajX0/69X14niigdetY0NBSB11NxQd+A1e1GhjfG9re+u9iw7Pq69XFhQBd9fpzcW53k7o/z1+V6YEQvXi3lIdkHv9CsI7ZNb6pDHuWrFzInOeY3RPLZeHzKWje4nkaudlDQZqTJSFYh6KMZCbw24bf5ZLrTWNlOsA6EfuyJ5r+ngvPo1jRV5Z2HriwEStKyE9NMLgBPnYKiykphI+hf7kfVfo5CwVjlhyYmhA2aoJBzJInqbfYtEH5dQsCs1xzLkarwO4WzwLu1xRJSmDO6QNEtsvELq/M0mBoQEQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602124706; bh=6ke0movnO0AUXBFCunNGEEzEuLeixKbxUQpoXOsOrc7=; h=Date:From:Subject; b=BvVGVhKfmN6gAEObtkOAOds6T9iWRR1/bL0QCr2heRfk8Kl5NP7UQ4NNDBTB/Yj510HOsWuCSEy+lYJQgVktcf/Z+H+eN7Sn8yXVaVQ5KJp9QpQM9i0Pj4Zfwrltq+Xe+fGv+FKjeR6xxAKARltet8jiIHHMI6F8oL/4lJQBHkgXVvEsJkV021zdmn0MKy49DR/LOZgyhvJHzmPORC2y4aovYtGWPOX7gWR85tdgP5RsXhIqeF7iWrhNUKE7pHDtLiVli2mKSg7i+9V3c51i2KoBLpmCUuQgAxD3UfmLW+i7ZDs2PsbiRpD+iiOCM+fF8dWwwEimDdZQmJh1yMDRWw==
X-YMail-OSG: mHSr4N4VM1kfMbX5OVQ51Am_vMq..vTm61ZZQH19uTVCFgvbeQRsAge_0GyEpmt
 xJWWmRM5vaz5xijsiVi1.LHSF9xlMvHPCxKSBGu15H5Rxd5r9w.Tgs0Hptq.mZtEusIaHCQlBF4E
 QhHovnkRt9Jq5RHQhq.Mb64oeGjPgFblFM79HRHJ2bUfHMAtiegIJ_izBr7AQOlnki9eM8YvJ9Xe
 5w56PoOZBh7RzGhMdWHQncDo_smrfmqUZ5qYyQ577jZiOipPWx9HkoF4KsZfXQcYCnCRXtjVnSym
 ZJfNGz7BSmNHip5OMYBYESzqWg6xnYYUu89Yu9it3V6ylYgim_0Nq4nktTUFjXUvd0RkbMNDA59W
 HJSncpLYdE1poOevU2PDIqxikfBa36Gqf20u6ubz75sHyu3.nNOXTcqjGRF6U8nwlaV.qgMC5ysF
 hoqX5g3qqTW12dqFkvUn3fhzW3QIDU3_t3SVSaDh9mULy4EyIXbDusYk2u8M63_UCBY8xBthv_Et
 bdoBmJT9.bE7Ejse0IFRxarTFSfOMF54nMHleeIg2yI6wEatpmn.PQBtZ4PlfxP_V.hQbu7IsZoQ
 2dxtwPgCY5UyrYUkO2nw_nTBO6TL_sg8VHwdIYVZL0Q84RHj5WQ_uT3FE9Z7d0dVnNR.sMplcvQZ
 5s0uk_5glzFlKqr1ybwN04zL6N_O7dreVT5a_KYO0.dbf4iZ99lBWFBi52HpWqdt0sXTiJUbbJn2
 d8.hmB2itKWH4xA77PAfumYXujFs46Ge7VEjwnk0i1hYlGko9l6br74nh2F9bD8_Mpoulu8siIrQ
 yckd7vr1Jwt0ezAYYrklv6QIH_vAVZRbHgQDIY1e_iX87d2eDLX4faytrUWVeCltzEGUe7qcZYqu
 Y_ZhyFYTIRFAW0_vgI8sYLyDNLd6lc2GflOI7xcX8Digd75OdP_Q5lfzB3_gYAc_1.099d0ndbsh
 XRaeJ5BNr2TxZhmDQCX8j3iP7LwqUL6gS.rJRbgAUbYgPgnKFEbqrh3c4U9dHcIKdd151OV29CoF
 ML3gfmL1LMXjVWeHHMdddBtI9a9m9B.H5u5hzcMdoD4Q3YQlHk_sj3TMxcT0.QFPJETubKJY8wnX
 co_hD8yhifkj6H0thKgjONQ1yUqEyeli5J.kqIqCQoL50ph8dQkWbmGCMrmWVII2zL2ziHOr0EnO
 UstQruEe2zLctlgakMV8Z6ahIQ6hu4aGq9fJilCqBe84MthpGvQTW3e_4kVl8_Zbow6CmaUW7c61
 labdudXoHSamzuyhALL_WKULZT9wxIvQvTl4_wTnjl0h3ieZJBWkptpzpVxPo6C23ufFA_rZZ1AE
 jh.L0U0vM4QtuXIfoJyqvRzteHGev_sdZ0_EBYtTgRLgjlAk.BO.vD0JuRZd0A3xm2OT.l9TysAq
 jeHh9lApX54_OmCmX7GC7bhI6qjAC.iXN8e96JboG5Zogi6Ff2gBYodvNsHBylOgpjapc_Ee8SlV
 vuw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Thu, 8 Oct 2020 02:38:26 +0000
Date:   Thu, 8 Oct 2020 02:36:25 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau52@fdco.in>
Reply-To: maurhinck14@gmail.com
Message-ID: <342583894.519567.1602124585840@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <342583894.519567.1602124585840.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck14@gmail.com) f=
or further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
