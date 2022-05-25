Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AAC533C65
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiEYMNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243012AbiEYMND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:13:03 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E7A2AC68;
        Wed, 25 May 2022 05:12:42 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PAu5ij032597;
        Wed, 25 May 2022 08:12:23 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3g93vddpaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:12:22 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 24PCCLZQ008027
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 May 2022 08:12:21 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Wed, 25 May
 2022 08:12:20 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Wed, 25 May 2022 08:12:20 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 24PCC3xm028274;
        Wed, 25 May 2022 08:12:05 -0400
From:   <alexandru.tachici@analog.com>
To:     <kuba@kernel.org>
CC:     <alexandru.tachici@analog.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <edumazet@google.com>,
        <geert+renesas@glider.be>, <geert@linux-m68k.org>,
        <josua@solid-run.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux-kernel@vger.kernel.org>, <michael.hennerich@analog.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock description syntax
Date:   Wed, 25 May 2022 15:28:13 +0300
Message-ID: <20220525122813.88431-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524112425.72f8c6e0@kernel.org>
References: <20220524112425.72f8c6e0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: O1MHOuA5jaqGAD2SYyMLIOF5bz-hzPLI
X-Proofpoint-ORIG-GUID: O1MHOuA5jaqGAD2SYyMLIOF5bz-hzPLI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=891
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250062
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 24 May 2022 16:30:18 +0200 Geert Uytterhoeven wrote:
> > On Tue, May 24, 2022 at 4:12 PM Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> > > "make dt_binding_check":
> > >
> > >     Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)
> > >
> > > The first line of the description ends with a colon, hence the block
> > > needs to be marked with a "|".
> > >
> > > Fixes: 1f77204e11f8b9e5 ("dt-bindings: net: adin: document phy clock output properties")
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > >  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-  
> > 
> > Alexandru Ardelean's email address bounces, while he is listed as
> > a maintainer in several DT bindings files.
> 
> Let's CC Alexandru Tachici, maybe he knows if we need to update 
> and to what.

Yeah, I should have updated this one. You can add me instead or I will come back with a patch.

  - Alexandru Tachici <alexandru.tachici@analog.com>

Regards,
Alexandru
