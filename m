Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD821326B8
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 13:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgAGMwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 07:52:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41870 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgAGMwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 07:52:03 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200107125158epoutp024869a2be5d5a76249549d7408f885377~nm9GJySKF0107101071epoutp02H
        for <netdev@vger.kernel.org>; Tue,  7 Jan 2020 12:51:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200107125158epoutp024869a2be5d5a76249549d7408f885377~nm9GJySKF0107101071epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1578401518;
        bh=z3QqzQeWELWtbdYfxbjfYm18/UmAbiaEUXAhmAM2oBo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=CEkLvv/X55mJb2k1eu6x8gvr48b+4nths8qKaq2VswJDF/+c4OWsMSxHZx4y1OUCn
         oJGAAKkTusqqZFy3UomjrLdwthk1yNY1ZykXOLrDKYLeux/CuJNkFy5Z6Z+FqEuvvN
         Mo+NTraqRTkZBipdG5RIv74mdPcz23VdLr6kVDwY=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200107125158epcas5p48bb7fc12493c86c760b299c8d4713026~nm9FmzniC2920629206epcas5p4F;
        Tue,  7 Jan 2020 12:51:58 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.AA.19726.EEE741E5; Tue,  7 Jan 2020 21:51:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200107125156epcas5p32d73c07df46c7ef9737bc1c2f2834823~nm9Eda_M22813728137epcas5p3q;
        Tue,  7 Jan 2020 12:51:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200107125156epsmtrp21cc851de8abadd6f9b0cba8944cf5713~nm9EcyYy21083110831epsmtrp2i;
        Tue,  7 Jan 2020 12:51:56 +0000 (GMT)
X-AuditID: b6c32a49-7c1ff70000014d0e-91-5e147eee958f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.7F.10238.CEE741E5; Tue,  7 Jan 2020 21:51:56 +0900 (KST)
Received: from sriramdash03 (unknown [107.111.85.29]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200107125154epsmtip28f9f64ea37fb59c4ce9d5b7f134b24f9~nm9BzaH2g2079120791epsmtip2Q;
        Tue,  7 Jan 2020 12:51:53 +0000 (GMT)
From:   "Sriram Dash" <sriram.dash@samsung.com>
To:     "'Jose Abreu'" <Jose.Abreu@synopsys.com>, <netdev@vger.kernel.org>
Cc:     "'Joao Pinto'" <Joao.Pinto@synopsys.com>,
        "'Giuseppe Cavallaro'" <peppe.cavallaro@st.com>,
        "'Alexandre Torgue'" <alexandre.torgue@st.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Maxime Coquelin'" <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'kernelci . org bot'" <bot@kernelci.org>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>
In-Reply-To: <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
Subject: RE: [PATCH net] net: stmmac: Fixed link does not need MDIO Bus
Date:   Tue, 7 Jan 2020 18:21:52 +0530
Message-ID: <014201d5c559$3e6204b0$bb260e10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQFZUtiDrXKRSclDK/XtxWw9Crh9QgFfdnd3qM0QNJA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SeyxVcRzA97vnnHuPx9XpEl9U6iIjj2y0w1Q2rU6trf6o9VZ3nBAuuwfF
        H2VR2Z2aolW361XNymbyLlHekojolkcxrsk1pizznNx7WP77fF+/z/e7/UhM0kvYkGHyGFYh
        l0VIhcZ4eb2zk9vkNYvAXVolRhdpWxH9paeGoNWfk3F6frJBRC8PjRP07FAjRv9cnCLo4mEN
        QXdVqoW0UqMl6KylAoJuyrGkl8fLkL+YKX3ZI2DeqH6ImKoxU6bk+XWmQpOFMbXvPJmR2WqM
        KX0/jZjp4q3HjM4Y+wWzEWFxrMJj70Xj0NzaHGH0b7Or87eJRNRpqkRGJFBe0DCSRCiRMSmh
        3iJIfKpGfPAHQffQ4Gowg2Dw4SyxNlL0YBHXs4SqRpA3JeebdAiS23IE+oKQcoO27zeEerag
        DkB/34DBgVGjGLR8m8T0BSMqENqmMwxsTh2EzKpxgwGnHKD3SYohL6Z8oPPTM5znjdDyWGtg
        jLKDigk1xm+0DeZG8gg+bwWNc6kYL/aFRs2CQQxUuQgmhpMQP7AfFhYbVtkcdM2lIp5tYHqy
        WshzOHTdHV0VxMAjXS7O8z6o6VavMLkic4bCSg/eawZ3FrQCfRooMaTckvDdjqDrK1l93RZq
        CloFPDOQMTUoSkPbVesuU627TLXuGtV/WQ7C85E1G81FhrCcd7SnnL3izskiuVh5iHtQVGQx
        Mvw4l0Ovkar9SB2iSCQ1FadtNg+UELI4Lj6yDgGJSS3ELq4WgRJxsCw+gVVEXVDERrBcHbIl
        camV+D7x9ZyECpHFsOEsG80q1qoC0sgmEe1uHjOrtz5vT57wdg1XntqS+eHwJvVYfoB1vEuq
        g1PsyFHPINvxlNGOdvuPlSYQ3uFjW7OzbMZE9+ps74A0+XLahl9LhenpPe2lhS+SduQued/c
        o/E7uISy+1p9L0WZePladuZbBzj2+6dwp5vmTooSskV29+bzq+2Ou3M9bundf6U4FyrzdMEU
        nOwfVautm20DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvO6bOpE4g1WbdC02PjnNaHHp5gFW
        iznnW1gsfr07wm7x/9FrVosfj44yW9z784HVYtPja6wWl3fNYbPouvaE1WLe37WsFscWiFn8
        f72V0YHXY8vKm0weO2fdZffY85LHY/OSeo/t1+YxexzcZ+jx9MdeZo8t+z8zenzeJBfAGcVl
        k5Kak1mWWqRvl8CVsfDgAraCj3wVv9pZGxgv8nQxcnJICJhIbJz6h6WLkYtDSGA3o8TGxTdY
        uxg5gBLSEj/v6kLUCEus/PecHaLmBaPE5YvfWEESbAK6EmdvNLGB2CICHhI7Dq0EK2IWeM8s
        8W/1NSaIjvWMErO3XwCr4hSIkzj7eQoziC0s4C4xd89rsEksAioSt2Z3gMV5BSwlLp5ZzAJh
        C0qcnPmEBeQiZgE9ibaNjCBhZgF5ie1v5zBDXKcg8fPpMlaIuLjE0Z89zBAHWUkcvfabdQKj
        8Cwkk2YhTJqFZNIsJN0LGFlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEx6mW5g7G
        y0viDzEKcDAq8fBaSAnHCbEmlhVX5h5ilOBgVhLh1dIRiRPiTUmsrEotyo8vKs1JLT7EKM3B
        oiTO+zTvWKSQQHpiSWp2ampBahFMlomDU6qBUZptiaNjNZfsuzUh5iFR3sscVZkOOyUWnJ0V
        dUJr9ZNLTe/l5oic2xFuJGD5ZckHTsvulh+lk31q9t32Pr7o+cPbS25Nmld5p3rxKeElTA07
        lY15Z3w8LLHl0j3DU0tybh6dqm178vFH1k8dD6o6mtR65z/ZnuBRv9R/xmMjST7XZtHtvZl2
        0UosxRmJhlrMRcWJAO6yr/7PAgAA
X-CMS-MailID: 20200107125156epcas5p32d73c07df46c7ef9737bc1c2f2834823
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200107123550epcas5p2d1914646e71e0ff0095b4a14eb5e1551
References: <CGME20200107123550epcas5p2d1914646e71e0ff0095b4a14eb5e1551@epcas5p2.samsung.com>
        <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Subject: [PATCH net] net: stmmac: Fixed link does not need MDIO Bus
> 
> When using fixed link we don't need the MDIO bus support.
> 
> Reported-by: Heiko Stuebner <heiko@sntech.de>
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Fixes: d3e014ec7d5e ("net: stmmac: platform: Fix MDIO init for platforms
> without PHY")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Acked-by: Sriram Dash <Sriram.dash@samsung.com>

> 
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: kernelci.org bot <bot@kernelci.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Sriram Dash <sriram.dash@samsung.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index cc8d7e7bf9ac..4775f49d7f3b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -320,7 +320,7 @@ static int stmmac_mtl_setup(struct platform_device
> *pdev,  static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
>  			 struct device_node *np, struct device *dev)  {
> -	bool mdio = false;
> +	bool mdio = !of_phy_is_fixed_link(np);
>  	static const struct of_device_id need_mdio_ids[] = {
>  		{ .compatible = "snps,dwc-qos-ethernet-4.10" },
>  		{},
> --
> 2.7.4


