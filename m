Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C3718836
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 12:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfEIKL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 06:11:58 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:53388 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725847AbfEIKL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 06:11:58 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 66A76C010D;
        Thu,  9 May 2019 10:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557396721; bh=PjdcNEdS1PCRSeR4w19ppWzBzJBcNmltWn+YgWpVPuA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Q1i6zushaePVDHpJ1VW0EqwuQNzXnr0xl8F55lr7NZT1nG54Ocz5vmCu/LjqiRTp8
         T/UrIQvqhtSIW7CxbYmHZsjOUUHkcIGrCB4I9Q+EoG0ECsCL/jRJcQX1wzteMAVi9P
         LrJrtvZsCw676Q5ec+8WE/rpywo9d7Gpn6/NN0dXvHg++XnaTaNCa7wjJmj0gDnu1p
         WmvOdxibWcO0Ff1nzDuH8GzR3aF3cqycMV2k/xgSgQx5esyw4cESugKfhro5KbzA5k
         sUI8MHHkhk7Ho5IysV+pdSFDLIDifnoYSxEST5GnMofmQicVsiwnejysGy9uZELk++
         YcPaNCesxYsdg==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 18623A0347;
        Thu,  9 May 2019 10:11:56 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 May 2019 03:11:56 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 9 May 2019 12:11:54 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 00/11] net: stmmac: Selftests
Thread-Topic: [PATCH net-next 00/11] net: stmmac: Selftests
Thread-Index: AQHVBXLZwJ2RZgEDF0CNP6MWY759gKZiX+4AgAAzhpA=
Date:   Thu, 9 May 2019 10:11:53 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B47AC7F@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <20190509090416.GB1605@Red>
In-Reply-To: <20190509090416.GB1605@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>
Date: Thu, May 09, 2019 at 10:04:16

> What means 1 for "Perfect Filter UC" ?

Thank you for the testing :)

1 means that either the expected packet was not received or that the=20
filter did not work.

For GMAC there is the need to set the HPF bit in order for the test to=20
pass. Do you have such bit in your HW ? It should be in EMAC_RX_FRM_FLT=20
register.

> I have added my patch below

Do you want me to add your patch to the series ? If you send me with=20
git-send-email I can apply it with your SoB.

Thanks,
Jose Miguel Abreu
