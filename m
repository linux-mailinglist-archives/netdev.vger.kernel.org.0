Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85E967C7E4
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbjAZKAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbjAZKA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:00:27 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F92611FA;
        Thu, 26 Jan 2023 02:00:24 -0800 (PST)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q7Atex013303;
        Thu, 26 Jan 2023 05:00:05 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n8dua4r4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 05:00:05 -0500
Received: from m0167089.ppops.net (m0167089.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30Q9qM7j003219;
        Thu, 26 Jan 2023 05:00:05 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3n8dua4r4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 05:00:05 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 30QA03eU052988
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 26 Jan 2023 05:00:03 -0500
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 26 Jan
 2023 05:00:02 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 26 Jan 2023 05:00:02 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.156])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 30Q9xajt019197;
        Thu, 26 Jan 2023 04:59:41 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <alexandru.tachici@analog.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <kuba@kernel.org>,
        <lennart@lfdomain.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <robh+dt@kernel.org>,
        <weiyongjun1@huawei.com>, <yangyingliang@huawei.com>
Subject: Re: [net-next 1/3] net: ethernet: adi: adin1110: add PTP clock support
Date:   Thu, 26 Jan 2023 11:59:34 +0200
Message-ID: <20230126095934.23107-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Y889m+CUSTbuv9Db@lunn.ch>
References: <Y889m+CUSTbuv9Db@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: CSdz5-FUxGUAIPzeiM6stx2G47iDicZy
X-Proofpoint-ORIG-GUID: nTeuF_HGmUaznaKOcJjLfP21ysXkbOPB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_03,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 clxscore=1011 mlxlogscore=926
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260094
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int adin1110_enable_perout(struct adin1110_priv *priv,
> > +				  struct ptp_perout_request perout,
> > +				  int on)
> > +{
> > +	u32 on_nsec;
> > +	u32 phase;
> > +	u32 mask;
> > +	int ret;
> > +
> > +	if (priv->cfg->id == ADIN2111_MAC) {
> > +		ret = phy_clear_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
> > +					 ADIN2111_LED_CNTRL,
> > +					 ADIN2111_LED_CNTRL_LED0_FUNCTION);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = phy_set_bits_mmd(priv->ports[0]->phydev, MDIO_MMD_VEND1,
> > +				       ADIN2111_LED_CNTRL,
> > +				       on ? ADIN2111_LED_CNTRL_TS_TIMER : 0);
> 
> I normally say a MAC driver should not be accessing PHY register...
> 
> You have the advantage of knowing it is integrated, so you know
> exactly what PHY it is. But you still have a potential race condition
> sometime in the future. You are not taking the phydev->lock, which is
> something phylib nearly always does before accessing a PHY. If you
> ever add control of the LEDs, that lack of locking could get you in
> trouble.
> 
> Is this functionality always on LED0? It cannot be LED1 or LED2?
> 
>    Andrew

Hi Andrew,

Thanks for the insight. Will add the phylib locking. Device only allows
LED0 pin or INTN pin to be converted to timer output. Can't lose IRQ capability
here so only LED0 could possibly be used.

Thanks,
Alexandru 
 
