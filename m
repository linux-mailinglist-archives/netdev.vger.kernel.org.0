Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461EC17C9F
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfEHOxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:53:25 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:42140 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbfEHOxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:53:24 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1BD09C00D4;
        Wed,  8 May 2019 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557327207; bh=AzTYHeJKASjlwCwioI8MqZT2M/656QyxqvxLNLUOSJk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HHzW0/0heleLIqLJFRLN3CHo2zyols5ZIzlJNYZrwqUhIQAKB5PDAstO1e4l0U5Zi
         qAJz9I+fW6G0h9NsRffdBM+xSmyPNcBAtLSnrb0pEFbVJGokADC1JYsnI/Vb7V0jzs
         PlSyj2WHQgYjKTCEr/QqAoI1VJYp4Ks+ZFgOdZwjH1ZxqnNPC9wtvfEgsWtcH2owTt
         e5ayto95sswKkSEfTV5tEqsfq6WJaHwWlc4LQ2EB0X8ogjVedls6nJXZvwlOgtpJXo
         IwUG1m5VBbOuxPJUkFHkn25SBMQlVafYsM9ZXwOpJQsAAFNTAKIZJ7LGIsx8sm/lHh
         1Wtz6nBehXYRg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A26C8A0097;
        Wed,  8 May 2019 14:53:18 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 8 May 2019 07:53:18 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 8 May 2019 16:53:16 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 07/11] net: stmmac: dwmac1000: Also pass
 control frames while in promisc mode
Thread-Topic: [PATCH net-next 07/11] net: stmmac: dwmac1000: Also pass
 control frames while in promisc mode
Thread-Index: AQHVBXLaRE4he0xXQEOeXEPfIQeeHaZhABYAgABQZIA=
Date:   Wed, 8 May 2019 14:53:15 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B479FB0@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <c6c1449e173dc4805f5fc785f1906e4392ccc66f.1557300602.git.joabreu@synopsys.com>
 <20190508120458.GD30557@lunn.ch>
In-Reply-To: <20190508120458.GD30557@lunn.ch>
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

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, May 08, 2019 at 13:04:58

> Do you mean pause frames?

Yes in order for the test to pass the MAC has to pass the pause frames to=20
the stack.

Thanks,
Jose Miguel Abreu
