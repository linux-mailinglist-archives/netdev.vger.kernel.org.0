Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D18E16484
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEGNY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:24:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44544 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEGNYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:24:55 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190507132446euoutp014b1bef6b5156e686824945f46a0b2910~caWy_EBtn2846928469euoutp01a
        for <netdev@vger.kernel.org>; Tue,  7 May 2019 13:24:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190507132446euoutp014b1bef6b5156e686824945f46a0b2910~caWy_EBtn2846928469euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557235486;
        bh=HePsI2obF6bYrams1J31uq3qDheNx0jPg7cbk18CcCo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gVNh+gdZP8JjL6KEk/sofaf92S2jaBESPYs7IhzM7dlD+BgqGGsb3lpSkmfsZavBP
         OweODdkZt3q69D1IKxStAYeBcoJZHk5yQ6iKWlrJmcg4MBtplp/MMefhwmRv9lHSfE
         cBa8Uu9eftmkrlqa7CHJ0Xxvd3qOW7+KTntymA3c=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190507132446eucas1p276c1b2db5552552d991f368747316488~caWyKfuMs1887718877eucas1p21;
        Tue,  7 May 2019 13:24:46 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id F5.3A.04377.D1781DC5; Tue,  7
        May 2019 14:24:45 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190507132445eucas1p12fed4a0cdc75e8f5343b450bf1893c54~caWxVbC6C1246812468eucas1p11;
        Tue,  7 May 2019 13:24:45 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190507132444eusmtrp17aa7a507c83e6e2dfe5747c7b1b08091~caWxHRTcE2518525185eusmtrp1Z;
        Tue,  7 May 2019 13:24:44 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-01-5cd1871d0c78
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 4A.BA.04140.C1781DC5; Tue,  7
        May 2019 14:24:44 +0100 (BST)
Received: from amdc2143 (unknown [106.120.51.59]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20190507132444eusmtip102380f308f9d3546384b476e83d2801e~caWwssKF41198511985eusmtip16;
        Tue,  7 May 2019 13:24:44 +0000 (GMT)
Message-ID: <d071578df35b11b858752f014f4ae5923b61be49.camel@samsung.com>
Subject: Re: [PATCH] extensions: libxt_owner: Add complementary groups
 option
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Date:   Tue, 07 May 2019 15:24:43 +0200
In-Reply-To: <20190505225930.w4bcrlsgzq7cipvg@salvia>
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsWy7djP87qy7RdjDC6dNbD4u7Od2WLO+RYW
        i229qxkt/r/WsbjcN43Z4vKuOWwWxxaIWUxYd4rFYvqbq8wOnB6nmzayeGxZeZPJY+esu+we
        b3+fYPI49H0Bq8fnTXIBbFFcNimpOZllqUX6dglcGVu/rmUvaGCtWPwnroHxF3MXIyeHhICJ
        xM7pz9m7GLk4hARWMEp8/bOTFcL5wijxdsdkJpAqIYHPjBLrZ4vBdKy8PpEFomg5o8SV+Y2M
        EM4zRol16/6BzeUV8JB4On85WLewgL9E6+kjYHE2AQOJ7xf2gtkiAtoS7TdawSYxC0xnkrhz
        q50NJMEioCrxoP8CK4jNKWAq8evTN7AGUQFdiRsbnrFBLBCUODnzCQuIzSwgL7H97RxmkEES
        AtvYJWbO2soGcauLxOwPlxghbGGJV8e3sEPYMhKnJ/cANXMA2dUSJ89UQPR2MEpsfDEbqt5a
        4vOkLcwgNcwCmhLrd+lDhB0lpvadYYVo5ZO48VYQ4gQ+iUnbpjNDhHklOtqEIKpVJV7vgRko
        LfHxz16oAzwkek4dYJzAqDgLyTOzkDwzC2HvAkbmVYziqaXFuempxUZ5qeV6xYm5xaV56XrJ
        +bmbGIEp6PS/4192MO76k3SIUYCDUYmH90XBxRgh1sSy4srcQ4wSHMxKIryJz87FCPGmJFZW
        pRblxxeV5qQWH2KU5mBREuetZngQLSSQnliSmp2aWpBaBJNl4uCUamCMbvVtrthXYPVHc+/6
        k8Uc/n+mPYp6K7h9++uElG3rvGoZJbNX1Nn3H7A3uKF1T95lMVt+lWcg+/+scK8bn9x//zz3
        JWXHhf+8Rzk1omct9HV0dVyb+aF1Znv1w6US03/p9La0n/JYrGv5wlp5155X9tnK6dVq6W+V
        /KLn6i73vuv179+Tx8lKLMUZiYZazEXFiQCCSFnPPQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xu7oy7RdjDL5eMrf4u7Od2WLO+RYW
        i229qxkt/r/WsbjcN43Z4vKuOWwWxxaIWUxYd4rFYvqbq8wOnB6nmzayeGxZeZPJY+esu+we
        b3+fYPI49H0Bq8fnTXIBbFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2
        NimpOZllqUX6dgl6GVu/rmUvaGCtWPwnroHxF3MXIyeHhICJxMrrE1m6GLk4hASWMkq8W3OL
        FSIhLXH8wEIoW1jiz7UuNoiiJ4wSiyfNYAFJ8Ap4SDydv5wJxBYW8JXYM/8/WJxNwEDi+4W9
        YBtEBLQl2m+0gm1gFpjOJHFmznawIhYBVYkH/RfANnAKmEr8+vSNGWLDfkaJS+tesoMkmAU0
        JVq3/wazRQV0JW5seMYGsVlQ4uTMJywQNfIS29/OYZ7AKDgLScssJGWzkJQtYGRexSiSWlqc
        m55bbKRXnJhbXJqXrpecn7uJERhh24793LKDsetd8CFGAQ5GJR7eFwUXY4RYE8uKK3MPMUpw
        MCuJ8CY+OxcjxJuSWFmVWpQfX1Sak1p8iNEU6KOJzFKiyfnA6M8riTc0NTS3sDQ0NzY3NrNQ
        EuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cB4ZIme4QYbuRVtLJx+1yJvtMgevb87xbJBIVv9
        9DTnhL33FgkJc27azH/27sF9s3lF2NxVj7NoS8+0s3DYsIcz+lC0aJGB5tYQzzy1o9kPMyfd
        Obs+OHDxpbk392t25nFENYTGaTmxHlnTI/WVK61/1sIq49e9C/98X5G5v+HNr9LOHf/5npQp
        sRRnJBpqMRcVJwIAoFjKicYCAAA=
X-CMS-MailID: 20190507132445eucas1p12fed4a0cdc75e8f5343b450bf1893c54
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10
References: <CGME20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10@eucas1p1.samsung.com>
        <20190426160257.4139-1-l.pawelczyk@samsung.com>
        <20190505225930.w4bcrlsgzq7cipvg@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-05-06 at 00:59 +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 26, 2019 at 06:02:57PM +0200, Lukasz Pawelczyk wrote:
> > The --compl-groups option causes GIDs specified with --gid-owner to
> > be
> > also checked in the complementary groups of a process.
> 
> Please, could you also update manpage?

Will do. iptables-extensions(8) I presume? Anything else?

> BTW, I think you refer to _supplementary_ groups, right? Existing
> documentation uses this term.

Yes, that's correct, my bad. I'll send the updated patches.

Thanks.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



