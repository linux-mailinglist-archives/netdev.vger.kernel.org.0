Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8DD2DD0EB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgLQLze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:55:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37006 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgLQLz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:55:27 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201217115347euoutp01762bfac77e83d82720133978fbca9a89~RftycNSdB0517905179euoutp01Q
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 11:53:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201217115347euoutp01762bfac77e83d82720133978fbca9a89~RftycNSdB0517905179euoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608206027;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kowqX+pUdYTLjIfgzcQV2kFfeMYszGxqY9Jb5xFs/OumEnmqCWrv2T0CGFERpOxfa
         B6EGph1jn3ugdl/llJHbPoltcuNd0a4Tkk2YwWtJpZJMME4TCmc3Kbmi0v5+zMJzGW
         MWp39qYK1Rf+q+6IFH1vku8YzWLL6wqygDOT2QLQ=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201217115342eucas1p1ff7e583b3f29f39324fc9a2b7aedd9af~RfttawpAn2472824728eucas1p1n;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 55.9D.45488.6C64BDF5; Thu, 17
        Dec 2020 11:53:42 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201217115342eucas1p1fc286236ae945e6e14bd7e05bbbf7757~RfttExonA2627326273eucas1p1b;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201217115342eusmtrp28e18e7db6e3395ae2258ae89c72a65bb~RfttDZ6150862108621eusmtrp2E;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
X-AuditID: cbfec7f5-c77ff7000000b1b0-bc-5fdb46c6ebf8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 19.A7.21957.5C64BDF5; Thu, 17
        Dec 2020 11:53:42 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201217115341eusmtip1fa1df90bfa0ce40f753c82c101c49ea2~Rfts0gLYE2573425734eusmtip1a;
        Thu, 17 Dec 2020 11:53:41 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v9 1/3] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Thu, 17 Dec 2020 12:53:28 +0100
Message-Id: <20201217115330.28431-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217115330.28431-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djPc7rH3G7HG+zdI21x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyDu96z1Lwk62i+8x51gbGn6xd
        jJwcEgImEtev7GTpYuTiEBJYwSgx89M6ZgjnC6PE+ScfWSGcz4wSb2YuZYZpaXu3HKplOVBi
        31smCOc5o8SBfx/ZQarYBBwl+peeAGsXEbjHLLG+/QEjiMMscJ9R4t7z1UCzODiEBVwlXm4w
        BWlgEVCV+D39JxOIzStgLTHp1kZ2iHXyEu3Lt7OB2JwCNhJtSx+xQtQISpyc+YQFxOYX0JJY
        03QdzGYGqm/eOhvsCQmBU5wSTVvmMUIMcpG4eHE7lC0s8er4FqgFMhL/d85nArlHQqBeYvIk
        M4jeHkaJbXN+sEDUWEvcOfeLDaSGWUBTYv0ufYhyR4n5y6UgTD6JG28FIS7gk5i0bTozRJhX
        oqNNCGKGisS6/j1Q86Qkel+tYJzAqDQLyS+zkNw/C2HVAkbmVYziqaXFuempxcZ5qeV6xYm5
        xaV56XrJ+bmbGIEp7/S/4193MK549VHvECMTB+MhRgkOZiUR3oQDN+OFeFMSK6tSi/Lji0pz
        UosPMUpzsCiJ8+7auiZeSCA9sSQ1OzW1ILUIJsvEwSnVwKS15v60D63n99hctucqtBF/7Tb3
        BPtezdCcRJFVfMxaj4Q/qiuvVT0bvnXrv9R5B3KX2b6S8dC/uuSl5NkTzX4rbj6Y0nEoaiLv
        k4X31lbYHnWbacI3M2Pv8uchMypfSr0u4W04HhKbMqHmxm3rVSIOD6pvHXlwmtnAgHNJzOTL
        tXqqropVO/ZM0t7e6cYRzBUSHKe9pWDfs0V2cUeWOx479mTNDdErpbO7DLKsM9ZtXSU+r9C9
        N8iO2W6695tdDqd2Luq8l/03csGWT8y8yy713dl3VbNhcdDV0Fg3rgr5uKPbc3fI/pt4kdtv
        TZ0ta5uZufhL/+0fPT7POHt29s2dVk99XZmPBXrzFGelGsUosRRnJBpqMRcVJwIAHtzWd+gD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xu7rH3G7HG2x6xGhx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyDu96z1Lwk62i+8x51gbGn6xdjJwcEgImEm3vlrOA2EICSxkl
        5t/N6WLkAIpLSaycmw5RIizx51oXWxcjF1DJU6CS4yuYQRJsAo4S/UtPsIIkRATeMEs03XvL
        DuIwC9xnlPj16QUjyCRhAVeJlxtMQRpYBFQlfk//yQRi8wpYS0y6tZEdYoO8RPvy7WwgNqeA
        jUTb0kesEAdZS6ydf5gRol5Q4uTMJywgI5kF1CXWzxMCCfMLaEmsaboOdj8z0JjmrbOZJzAK
        zULSMQuhYxaSqgWMzKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzEC43vbsZ+bdzDOe/VR7xAj
        EwfjIUYJDmYlEd6EAzfjhXhTEiurUovy44tKc1KLDzGaAn02kVlKNDkfmGDySuINzQxMDU3M
        LA1MLc2MlcR5t85dEy8kkJ5YkpqdmlqQWgTTx8TBKdXAFHRx08UXyxSjep7+UZGuPmix2I4l
        9G980vx/O1WzWk4l3KmYqznzr7gQTzxry+zFGTPt+z6H/9unuDtzQm/NqaOiX3n+y5efn9f1
        5vyp1VvXz/KSP8fVfvHuT+ncC+eKvi9XcKoVFI0T3aI165K4l7/lu03mR4vT+vZonnxwcnHN
        1ExrFWfHjcu0Qnf1XXz3duG5FLuD7yWu205aVuXz/H/MleygyDDG/KOs+1heb26bL/Gh8OA0
        oZ2n+65e7Dzu1/vn/92Ptuat65Yv2sNd3WxTnvzl2/ZPzHa/z9yrsYtP9K2Zs/CE0P6i4qAD
        3icLd26wkwz5adC8UKXjZmjjn8cTagRSOQ5YnsgX2mzjWqbEUpyRaKjFXFScCAA5iosIeAMA
        AA==
X-CMS-MailID: 20201217115342eucas1p1fc286236ae945e6e14bd7e05bbbf7757
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201217115342eucas1p1fc286236ae945e6e14bd7e05bbbf7757
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201217115342eucas1p1fc286236ae945e6e14bd7e05bbbf7757
References: <20201217115330.28431-1-l.stelmach@samsung.com>
        <CGME20201217115342eucas1p1fc286236ae945e6e14bd7e05bbbf7757@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the prefix for ASIX Electronics Corporation.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2735be1a8470..ce3b3f6c9728 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -117,6 +117,8 @@ patternProperties:
     description: Asahi Kasei Corp.
   "^asc,.*":
     description: All Sensors Corporation
+  "^asix,.*":
+    description: ASIX Electronics Corporation
   "^aspeed,.*":
     description: ASPEED Technology Inc.
   "^asus,.*":
-- 
2.26.2

